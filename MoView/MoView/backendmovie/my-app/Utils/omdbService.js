require('dotenv').config();
const axios = require('axios');
const NodeCache = require('node-cache');
const Movie = require('../Models/Movie');

const OMDB_BASE_URL = 'http://www.omdbapi.com';

const omdbClient = axios.create({
  baseURL: OMDB_BASE_URL,
  timeout: 10000,
});

const cache = new NodeCache({ stdTTL: 0, checkperiod: 0 });

const checkOmdbError = (data) => {
  if (data.Response === 'False') {
    const err = new Error(data.Error || 'Film tidak ditemukan');
    err.statusCode = data.Error === 'Movie not found!' ? 404 : 400;
    throw err;
  }
};

const saveToDatabase = async (movie) => {
  try {
    const ratings = movie.Ratings || [];
    const rottenTomatoes = ratings.find(
      (r) => r.Source === 'Rotten Tomatoes'
    )?.Value ?? 'N/A';
 
    await Movie.upsert({
      imdb_id: movie.imdbID,
      title: movie.Title,
      year: movie.Year,
      genre: movie.Genre,
      plot: movie.Plot,
      poster: movie.Poster,
      imdb_rating: movie.imdbRating,
      rotten_tomatoes: rottenTomatoes,
      runtime: movie.Runtime,
    });
 
    console.log(`[DB] Disimpan: ${movie.Title} (${movie.imdbID})`);
  } catch (err) {
    console.error(`[DB] Gagal simpan ${movie.imdbID}:`, err.message);
  }
};

const fetchAndSaveDetail = async (imdbID) => {
  try {
    const exists = await Movie.findOne({ where: { imdb_id: imdbID } });
    if (exists) {
      return;
    }
 
    const params = {
      apikey: process.env.OMDB_API_KEY,
      i: imdbID,
      plot: 'full',
    };
 
    const { data } = await omdbClient.get('/', { params });
    if (data.Response === 'False') return;
 
    await saveToDatabase(data);
 
    // Simpan juga ke cache
    const cacheKey = `detail_id_${imdbID}_full`;
    cache.set(cacheKey, data);
  } catch (err) {
    console.error(`[DB] Gagal fetch detail ${imdbID}:`, err.message);
  }
};

const searchMovies = async ({ query, page = 1, type = '', year = '' }) => {
  const cacheKey = `search_${query}_${page}_${type}_${year}`;
 
  const cached = cache.get(cacheKey);
  if (cached) {
    console.log(`[Cache HIT] ${cacheKey}`);
    return cached;
  }
 
  console.log(`[Cache MISS] ${cacheKey} — hit OMDB API`);
 
  const params = {
    apikey: process.env.OMDB_API_KEY,
    s: query,
    page,
    ...(type && { type }),
    ...(year && { y: year }),
  };
 
  console.log('KEY di searchMovies:', process.env.OMDB_API_KEY);
  console.log('params:', params);
 
  const { data } = await omdbClient.get('/', { params });
  checkOmdbError(data);
 
  const result = {
    results: data.Search,
    totalResults: parseInt(data.totalResults, 10),
    page: parseInt(page, 10),
    totalPages: Math.ceil(parseInt(data.totalResults, 10) / 10),
  };
 
  cache.set(cacheKey, result);
 
  setImmediate(async () => {
    console.log(`[DB] Menyimpan ${data.Search.length} film ke database...`);
    for (const movie of data.Search) {
      await fetchAndSaveDetail(movie.imdbID);
    }
  });
 
  return result;
};


const getMovieById = async (imdbId, plot = 'full') => {
  const cacheKey = `detail_id_${imdbId}_${plot}`;
 
  const cached = cache.get(cacheKey);
  if (cached) {
    console.log(`[Cache HIT] ${cacheKey}`);
    return cached;
  }
 
  const fromDB = await Movie.findOne({ where: { imdb_id: imdbId } });
  if (fromDB) {
    console.log(`[DB HIT] ${imdbId}`);
    cache.set(cacheKey, fromDB.toJSON());
    return fromDB.toJSON();
  }
 
  console.log(`[Cache MISS] [DB MISS] ${imdbId} — hit OMDB API`);
 
  const params = {
    apikey: process.env.OMDB_API_KEY,
    i: imdbId,
    plot,
  };
 
  const { data } = await omdbClient.get('/', { params });
  checkOmdbError(data);
 
  await saveToDatabase(data);
  cache.set(cacheKey, data);
 
  return data;
};

const getMovieByTitle = async (title, year = '', plot = 'full') => {
  const cacheKey = `detail_title_${title}_${year}_${plot}`;
 
  const cached = cache.get(cacheKey);
  if (cached) {
    console.log(`[Cache HIT] ${cacheKey}`);
    return cached;
  }
 
  const fromDB = await Movie.findOne({ where: { title } });
  if (fromDB) {
    console.log(`[DB HIT] ${title}`);
    cache.set(cacheKey, fromDB.toJSON());
    return fromDB.toJSON();
  }
 
  console.log(`[Cache MISS] [DB MISS] ${title} — hit OMDB API`);
 
  const params = {
    apikey: process.env.OMDB_API_KEY,
    t: title,
    plot,
    ...(year && { y: year }),
  };
 
  const { data } = await omdbClient.get('/', { params });
  checkOmdbError(data);
 
  await saveToDatabase(data);
  cache.set(cacheKey, data);
 
  return data;
};

module.exports = {
  searchMovies,
  getMovieById,
  getMovieByTitle,
};