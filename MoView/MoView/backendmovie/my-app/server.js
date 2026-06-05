
console.log('API KEY:', process.env.OMDB_API_KEY);
const app = require('./app');
const { connectDB } = require('./Utils/database');
const models = require('./Models');

const PORT = process.env.PORT || 3000;

connectDB().then(() => {
  app.listen(PORT, () => {
    console.log(`\n🎬 Movie Finder API berjalan di http://localhost:${PORT}`);
    console.log(`📋 Dokumentasi endpoint: http://localhost:${PORT}\n`);
  });
});
