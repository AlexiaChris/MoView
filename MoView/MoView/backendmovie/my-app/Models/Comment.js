const { DataTypes } = require('sequelize');
const { sequelize } = require('../Utils/database');

const Comment = sequelize.define('Comment', {
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
  parent_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    defaultValue: null,
  },
  comment: {
    type: DataTypes.TEXT,
    allowNull: false,
  },
}, {
  tableName: 'comments',
  timestamps: true,
  createdAt: 'created_at',
  updatedAt: 'updated_at',
});

module.exports = Comment;