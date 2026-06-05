const express = require('express');
const router = express.Router();
const movieController = require('../Controller/movieController');
const validateApiKey = require('../middleWares/validateApiKey');

router.use(validateApiKey);

router.get('/search', movieController.searchMovies);
router.get('/genre', movieController.getMoviesByGenre);
router.get('/title/:title', movieController.getMovieByTitle);
router.get('/:id', movieController.getMovieById);

module.exports = router;