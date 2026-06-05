const express = require('express');
const router = express.Router();
const ratingController = require('../Controller/ratingController');
const validateApiKey = require('../middleWares/validateApiKey');
const authMiddleware = require('../middleWares/authMiddleware');

router.use(validateApiKey);

router.get('/:movieId', (req, res, next) => {
  if (req.headers.authorization) {
    authMiddleware(req, res, next);
  } else {
    next();
  }
}, ratingController.getMovieRatings);

router.post('/:movieId', authMiddleware, ratingController.addOrUpdateRating);
router.delete('/:movieId', authMiddleware, ratingController.deleteRating);

module.exports = router;