const { DataTypes } = require('sequelize');
const { sequelize } = require('../Utils/database');

const Movie = sequelize.define('Movie', {
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },
  imdb_id: {
    type: DataTypes.STRING(20),
    unique: true,
    allowNull: false,
  },
  title: {
    type: DataTypes.STRING(255),
    allowNull: false,
  },
  year: {
    type: DataTypes.STRING(10),
  },
  genre: {
    type: DataTypes.STRING(255),
  },
  plot: {
    type: DataTypes.TEXT,
  },
  poster: {
    type: DataTypes.STRING(500),
  },
  imdb_rating: {
    type: DataTypes.STRING(10),
  },
  rotten_tomatoes: {
    type: DataTypes.STRING(10),
  },
  runtime: {
    type: DataTypes.STRING(20),
  },
}, {
  tableName: 'movies',
  timestamps: false, 
});

module.exports = Movie;