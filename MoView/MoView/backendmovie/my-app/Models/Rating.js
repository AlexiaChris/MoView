const { DataTypes } = require('sequelize');
const { sequelize } = require('../Utils/database');

const Rating = sequelize.define('Rating', {
  id: {

    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true,
  },
  movie_id: {
    type: DataTypes.STRING(20),
    allowNull: false,
  },
  user_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  rating: {
    type: DataTypes.INTEGER,
    allowNull: false,
    validate: {
      min: 1,
      max: 5
    }
  },
}, 
{
  tableName: 'ratings',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
});

module.exports = Rating;