const { sequelize } = require('../Utils/database');
const User = require('./User');
const Comment = require('./Comment');
const Rating = require('./Rating'); 

Comment.belongsTo(User, {
  foreignKey: 'user_id',
  as: 'User',
});

User.hasMany(Comment, {
  foreignKey: 'user_id',
  as: 'comments',
});

Comment.hasMany(Comment, {
  foreignKey: 'parent_id',
  as: 'replies',
  onDelete: 'CASCADE',
});

Comment.belongsTo(Comment, {
  foreignKey: 'parent_id',
  as: 'parent',
});

Rating.belongsTo(User, {
  foreignKey: 'user_id',
  as: 'User',
});

User.hasMany(Rating, {
  foreignKey: 'user_id',
  as: 'ratings',
});

module.exports = {
    sequelize,
    User,
    Comment,
    Rating
};