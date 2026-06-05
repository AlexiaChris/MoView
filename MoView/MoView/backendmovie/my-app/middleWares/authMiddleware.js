const jwt = require('jsonwebtoken');

const authMiddleware = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1]; 

  if (!token) {
    return res.status(401).json({
      success: false,
      message: 'Token tidak ditemukan. Silakan login terlebih dahulu.',
    });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded; 
    next();
  } catch (err) {
    return res.status(403).json({
      success: false,
      message: 'Token tidak valid atau sudah expired. Silakan login ulang.',
    });
  }
};

module.exports = authMiddleware;