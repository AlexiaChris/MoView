const express = require('express');
const router = express.Router();
const { deleteComment } = require('../Controller/commentController');
const authMiddleware = require('../middleWares/authMiddleware');

router.delete('/:id', authMiddleware, deleteComment);

module.exports = router;