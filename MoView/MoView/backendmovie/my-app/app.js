const express = require('express');
const cors = require('cors');


const movieRoutes = require('./routes/movieRoutes');
const commentRoutes = require('./routes/commentRoutes');
const deleteCommentRoute = require('./routes/deleteCommentRoutes');
const authRoutes = require('./routes/authRoutes');
const errorHandler = require('./middleWares/errorHandler');
const notFound = require('./middleWares/notFound');
const ratingRoutes = require('./routes/ratingRoutes');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'Movie Finder API',
    version: '1.0.0',
    endpoints: {
      register:      'POST /api/auth/register',
      login:         'POST /api/auth/login',
      me:            'GET  /api/auth/me (token)',
      search:        'GET  /api/movies/search?q={title}',
      detail:        'GET  /api/movies/:imdbId',
      byTitle:       'GET  /api/movies/title/:title',
      getComments:   'GET  /api/movies/:imdbId/comments',
      addComment:    'POST /api/movies/:imdbId/comments (token)',
      deleteComment: 'DELETE /api/comments/:id (token)',
    },
  });
});


app.use('/api/auth', authRoutes);
app.use('/api/movies', movieRoutes);
app.use('/api/comments', commentRoutes);
app.use('/api/comments', deleteCommentRoute);
app.use('/api/ratings', ratingRoutes);

app.use(notFound);
app.use(errorHandler);

module.exports = app;