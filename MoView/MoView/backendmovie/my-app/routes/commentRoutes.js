const express = require('express');
const router = express.Router();
const { getComments, addComment, deleteComment } = require('../Controller/commentController');
const authMiddleware = require('../middleWares/authMiddleware');
const validateApiKey = require('../middleWares/validateApiKey');

router.use(validateApiKey);
router.get('/:imdbId', getComments);
router.post('/:imdbId', authMiddleware, addComment);
router.delete('/:id', authMiddleware, deleteComment);

module.exports = router;