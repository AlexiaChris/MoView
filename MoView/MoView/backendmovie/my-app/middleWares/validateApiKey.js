const validateApiKey = (req, res, next) => {
  const appApiKey = process.env.APP_API_KEY;

  if (!appApiKey) return next();

  const clientKey = req.headers['x-api-key'];

  if (!clientKey) {
    return res.status(401).json({
      success: false,
      message: 'API key diperlukan. Sertakan header "X-API-Key".',
    });
  }

  if (clientKey !== appApiKey) {
    return res.status(403).json({
      success: false,
      message: 'API key tidak valid.',
    });
  }

  next();
};

module.exports = validateApiKey;
