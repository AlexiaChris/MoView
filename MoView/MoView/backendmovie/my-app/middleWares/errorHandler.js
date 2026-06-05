const errorHandler = (err, req, res, next) => {
  console.error(`[Error] ${err.message}`);
  if (process.env.NODE_ENV === 'development') {
    console.error(err.stack);
  }

  if (err.code === 'ECONNABORTED' || err.code === 'ERR_NETWORK') {
    return res.status(504).json({
      success: false,
      message: 'Tidak dapat terhubung ke OMDB API. Coba lagi nanti.',
    });
  }

  const statusCode = err.statusCode || err.status || 500;

  res.status(statusCode).json({
    success: false,
    message: err.message || 'Terjadi kesalahan pada server.',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
  });
};

module.exports = errorHandler;
