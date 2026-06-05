require('dotenv').config();
const { Sequelize } = require('sequelize');

const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASSWORD,
  {
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 3306,
    dialect: 'mysql',
    logging: false, 
    pool: {
      max: 5,
      min: 0,
      acquire: 30000,
      idle: 10000,
    },
  }
);

const connectDB = async () => {
  try {
    await sequelize.authenticate();
    console.log('✅ MySQL terhubung!');
    await sequelize.sync({ alter: true });
    console.log('✅ Tabel tersinkronisasi!');
  } catch (err) {
    console.error('❌ Gagal konek MySQL:', err.message);
    process.exit(1);
  }
};

module.exports = { sequelize, connectDB };