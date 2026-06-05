const { Rating, User, sequelize } = require('../Models'); 
const { Op } = require('sequelize');

exports.getMovieRatings = async (req, res) => {
  try {
    const { movieId } = req.params;
    const userId = req.user?.id;

    // Get rata2 rating
    const avgResult = await Rating.findOne({
      where: { movie_id: movieId },
      attributes: [
        [sequelize.fn('AVG', sequelize.col('rating')), 'average'],
        [sequelize.fn('COUNT', sequelize.col('id')), 'count']
      ],
      raw: true
    });

    const average = avgResult.average ? parseFloat(avgResult.average).toFixed(1) : null;
    const count = parseInt(avgResult.count) || 0;

    let userRating = null;
    if (userId) {
      const userRatingData = await Rating.findOne({
        where: { movie_id: movieId, user_id: userId }
      });
      userRating = userRatingData ? userRatingData.rating : null;
    }

    res.json({
      success: true,
      data: {
        average: average,
        count: count,
        userRating: userRating
      }
    });

  } 
  
  catch (error) {
    console.error('Error getting ratings:', error);
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
};

// Post rating
exports.addOrUpdateRating = async (req, res) => {
  try {
    const { movieId } = req.params;
    const { rating } = req.body;
    const userId = req.user.id;

    if (!rating || rating < 1 || rating > 5) {
      return res.status(400).json({
        success: false,
        message: 'Rating must be between 1 and 5'
      });
    }

    const existingRating = await Rating.findOne({
      where: { movie_id: movieId, user_id: userId }
    });

    let result;
    if (existingRating) {
      existingRating.rating = rating;
      await existingRating.save();
      result = existingRating;
    } else {
      result = await Rating.create({
        movie_id: movieId,
        user_id: userId,
        rating: rating
      });
    }

    res.status(201).json({
      success: true,
      message: existingRating ? 'Rating updated' : 'Rating added',
      data: result
    });

  } 
  
  catch (error) {
    console.error('Error adding rating:', error);
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
};

//Delete rating
exports.deleteRating = async (req, res) => {
  try {
    const { movieId } = req.params;
    const userId = req.user.id;

    const rating = await Rating.findOne({
      where: { movie_id: movieId, user_id: userId }
    });

    if (!rating) {
      return res.status(404).json({
        success: false,
        message: 'Rating not found'
      });
    }

    await rating.destroy();

    res.json({
      success: true,
      message: 'Rating deleted'
    });

  } 
  
  catch (error) {
    console.error('Error deleting rating:', error);
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
};