const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../Models/User');


const register = async (req, res, next) => {
  try {
    const { username, password } = req.body;

    if (!username || username.trim().length < 3) {
      return res.status(400).json({
        success: false,
        message: 'Username minimal 3 characters.',
      });
    }

    if (!password || password.length < 6) {
      return res.status(400).json({
        success: false,
        message: 'Password minimal 6 characters.',
      });
    }

    // Cek username udh dipake
    const existingUser = await User.findOne({ where: { username: username.trim() } });
    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: 'Username is already taken.',
      });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Simpen user baru
    const newUser = await User.create({
      username: username.trim(),
      password: hashedPassword,
    });

    res.status(201).json({
      success: true,
      message: 'Registration successful!',
      data: {
        id: newUser.id,
        username: newUser.username,
      },
    });
  } catch (err) {
    next(err);
  }
};


const login = async (req, res, next) => {
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      return res.status(400).json({
        success: false,
        message: 'Username and password have to be filled.',
      });
    }

    // Cari user
    const user = await User.findOne({ where: { username: username.trim() } });
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Username or password is incorrect.',
      });
    }

    // Cek pw
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'Username or password is incorrect.',
      });
    }

    // Buat JWT token
    const token = jwt.sign(
      { id: user.id, username: user.username },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
    );

    res.json({
      success: true,
      message: 'Login successful!',
      data: {
        token,
        user: {
          id: user.id,
          username: user.username,
        },
      },
    });
  } catch (err) {
    next(err);
  }
};

// GET
const getMe = async (req, res, next) => {
  try {
    const user = await User.findByPk(req.user.id, {
      attributes: ['id', 'username'],
    });

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found.',
      });
    }

    res.json({ success: true, data: user });
  } catch (err) {
    next(err);
  }
};

module.exports = { register, login, getMe };