const express = require('express');
const router = express.Router();
const { register, login, getMe } = require('../Controller/authController');
const authMiddleware = require('../middleWares/authMiddleware');

router.post('/register', register);
router.post('/login', login);
router.get('/me', authMiddleware, getMe);

module.exports = router;