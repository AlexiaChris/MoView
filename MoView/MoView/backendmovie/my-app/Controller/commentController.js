const { Comment, User } = require('../Models');

// GET comment
exports.getComments = async (req, res) => {
  try {
    const imdbId = req.params.imdbId;

    //Ambil semua comments
    const allComments = await Comment.findAll({
      where: { movie_id: imdbId },
      include: [
        {
          model: User,
          as: 'User',
          attributes: ['id', 'username']
        }
      ],
      order: [['created_at', 'ASC']]
    });

    const commentMap = {};
    const rootComments = [];


    allComments.forEach(comment => {
      const commentData = comment.toJSON();
      commentData.replies = [];
      commentMap[commentData.id] = commentData;
    });

    allComments.forEach(comment => {
      const commentData = commentMap[comment.id];
      
      if (comment.parent_id === null) {
        rootComments.push(commentData);
      } else {
        const parent = commentMap[comment.parent_id];
        if (parent) {
          parent.replies.push(commentData);
        }
      }
    });

    res.json({
      success: true,
      data: {
        comments: rootComments
      }
    });

  } catch (error) {
    console.error('Error getting comments:', error);
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
};

//POST KOMEN BARU
exports.addComment = async (req, res) => {
  try {
    const imdbId = req.params.imdbId; 
    const { comment, parent_id } = req.body;
    const userId = req.user.id;

    console.log('=== DEBUG ADD COMMENT ===');
    console.log('imdbId:', imdbId);
    console.log('comment:', comment);
    console.log('parent_id:', parent_id);
    console.log('userId:', userId);

    if (!comment || comment.trim() === '') {
      return res.status(400).json({
        success: false,
        message: 'Comment cannot be empty'
      });
    }

    if (parent_id) {
      const parentComment = await Comment.findByPk(parent_id);
      
      if (!parentComment) {
        return res.status(404).json({
          success: false,
          message: 'Parent comment not found'
        });
      }

      if (parentComment.movie_id !== imdbId) {
        return res.status(400).json({
          success: false,
          message: 'Invalid parent comment'
        });
      }
    }

    const newComment = await Comment.create({
      movie_id: imdbId,
      user_id: userId,
      parent_id: parent_id || null,
      comment: comment.trim()
    });
    const commentWithUser = await Comment.findByPk(newComment.id, {
      include: [{
        model: User,
        as: 'User',
        attributes: ['id', 'username']
      }]
    });

    res.status(201).json({
      success: true,
      message: parent_id ? 'Reply added successfully' : 'Comment added successfully',
      data: commentWithUser
    });

  } catch (error) {
    console.error('Error adding comment:', error);
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
};

//Apus comment
exports.deleteComment = async (req, res) => {
  try {
    const id = req.params.id;
    const userId = req.user.id;

    const comment = await Comment.findByPk(id);

    if (!comment) {
      return res.status(404).json({
        success: false,
        message: 'Comment not found'
      });
    }

    //Cmn bs delete komen sendiri
    if (comment.user_id !== userId) {
      return res.status(403).json({
        success: false,
        message: 'Unauthorized to delete this comment'
      });
    }

    const countDescendants = async (parentId) => {
      const children = await Comment.findAll({
        where: { parent_id: parentId },
        attributes: ['id']
      });
      
      let count = children.length;
      
      for (const child of children) {
        count += await countDescendants(child.id);
      }
      
      return count;
    };

    const descendantCount = await countDescendants(id);
    await comment.destroy();
    const isRoot = comment.parent_id === null;
    
    let message = 'Comment deleted successfully';
    if (descendantCount > 0) {
      message = `${isRoot ? 'Comment' : 'Reply'} and ${descendantCount} nested ${descendantCount === 1 ? 'reply' : 'replies'} deleted successfully`;
    }

    res.json({
      success: true,
      message: message,
      deletedCount: descendantCount + 1
    });

  } catch (error) {
    console.error('Error deleting comment:', error);
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
};