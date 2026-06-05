const omdb = require('../Utils/omdbService');

const getRating = (ratings, source) =>
  ratings?.find((r) => r.Source === source)?.Value ?? 'N/A';

const formatMovie = (movie) => ({
  imdbID: movie.imdbID || movie.imdb_id,
  title: movie.Title || movie.title,
  year: movie.Year || movie.year,
  genre: movie.Genre || movie.genre,
  plot: movie.Plot || movie.plot,
  poster: movie.Poster || movie.poster,
  rottenTomatoesRating: movie.rotten_tomatoes || getRating(movie.Ratings, 'Rotten Tomatoes'),
  imdbRating: movie.imdbRating || movie.imdb_rating,
});

const fetchMovieDetails = async (imdbID) => {
  try {
    const detail = await omdb.getMovieById(imdbID, 'short');
    return {
      ...detail,
      Genre: detail.Genre || detail.genre,
    };
  } catch {
    return null;
  }
};

const searchMovies = async (req, res, next) => {
  try {
    const { q, page = 1, type = '', year = '', genre = '' } = req.query;

    if (!q || q.trim().length < 1) {
      return res.status(400).json({
        success: false,
        message: 'Parameter "q" (judul film) wajib diisi.',
      });
    }

    const validTypes = ['movie', 'series', 'episode', ''];
    if (!validTypes.includes(type)) {
      return res.status(400).json({
        success: false,
        message: 'Parameter "type" harus salah satu: movie, series.',
      });
    }

    const pageNum = parseInt(page, 10);
    if (isNaN(pageNum) || pageNum < 1 || pageNum > 100) {
      return res.status(400).json({
        success: false,
        message: 'Parameter "page" harus angka antara 1 - 100.',
      });
    }

    let searchData;
    try {
      searchData = await omdb.searchMovies({ query: q.trim(), page: pageNum, type, year });
    } catch (err) {
      if (err.statusCode === 404) {
        return res.json({
          success: true,
          data: {
            results: [],
            totalResults: 0,
            page: pageNum,
            totalPages: 0,
          },
        });
      }
      throw err;
    }

    if (!genre) {
      return res.json({
        success: true,
        data: searchData,
      });
    }

    const details = await Promise.all(
      searchData.results.map((movie) => fetchMovieDetails(movie.imdbID))
    );

    const filtered = details
      .filter((movie) => movie && movie.Genre)
      .filter((movie) => movie.Genre.toLowerCase().includes(genre.toLowerCase()))
      .map((movie) => formatMovie(movie));

    res.json({
      success: true,
      data: {
        results: filtered,
        totalResults: filtered.length,
        page: pageNum,
        filteredBy: genre,
        note: 'Total hasil difilter dari halaman ini saja',
      },
    });
  } catch (err) {
    next(err);
  }
};

const getMovieById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { plot = 'full' } = req.query;

    if (!/^tt\d{7,8}$/.test(id)) {
      return res.status(400).json({
        success: false,
        message: 'Format ID tidak valid. Gunakan IMDb ID, contoh: tt1375666.',
      });
    }

    const data = await omdb.getMovieById(id, plot);
    console.log('DATA FROM OMDB:', JSON.stringify(data));

    res.json({
      success: true,
      data: formatMovie(data),
    });
  } catch (err) {
    next(err);
  }
};

const getMovieByTitle = async (req, res, next) => {
  try {
    const { title } = req.params;
    const { year = '', plot = 'full' } = req.query;

    if (!title || title.trim().length < 1) {
      return res.status(400).json({
        success: false,
        message: 'Judul film wajib diisi.',
      });
    }

    const data = await omdb.getMovieByTitle(title.trim(), year, plot);

    res.json({
      success: true,
      data: formatMovie(data),
    });
  } catch (err) {
    next(err);
  }
};

const getMoviesByGenre = async (req, res, next) => {
  try {
    const { genre, page = 1, type = '' } = req.query;

    if (!genre) {
      return res.status(400).json({
        success: false,
        message: 'Parameter "genre" wajib diisi.',
      });
    }

    const { Op } = require('sequelize');
    const Movie = require('../Models/Movie');
    
    const limit = 50;
    const offset = (page - 1) * limit;


    const whereClause = {
      genre: {
        [Op.like]: `%${genre}%`
      }
    };
    
    if (type === 'movie' || type === 'series') {
      whereClause.type = type;
    }

    let movies = await Movie.findAll({
      where: whereClause,
      limit: limit,
      offset: offset,
      order: [['imdb_rating', 'DESC']]
    });

    //Fetch poster yang ilang
    const moviesWithPosters = await Promise.all(
      movies.map(async (movie) => {
        if (!movie.poster || movie.poster === 'N/A' || movie.poster === '') {
          try {
            const detail = await omdb.getMovieById(movie.imdb_id, 'short');
            if (detail.Poster && detail.Poster !== 'N/A') {
              movie.poster = detail.Poster;
              await movie.save();
              console.log(`✅ Updated poster for: ${movie.title}`);
            }
          } catch (err) {
            console.log(`❌ Failed to fetch poster for ${movie.title}`);
          }
        }
        return movie;
      })
    );

    const validMovies = moviesWithPosters.filter(
      m => m.poster && m.poster !== 'N/A' && m.poster !== ''
    );

    const formatted = validMovies.map((m) => ({
      imdbID: m.imdb_id,
      Title: m.title,
      Year: m.year,
      Genre: m.genre,
      Plot: m.plot,
      Poster: m.poster,
      imdbRating: m.imdb_rating,
      Ratings: m.rotten_tomatoes ? [{ Source: 'Rotten Tomatoes', Value: m.rotten_tomatoes }] : [],
      Runtime: m.runtime,
      Type: m.type,
    }));

    res.json({
      success: true,
      data: {
        results: formatted,
        totalResults: formatted.length,
        page: parseInt(page, 10),
        genre,
      },
    });
  } catch (err) {
    next(err);
  }
};

module.exports = {
  searchMovies,
  getMovieById,
  getMovieByTitle,
  getMoviesByGenre,
};