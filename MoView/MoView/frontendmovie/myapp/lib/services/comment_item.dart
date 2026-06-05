import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  final Map<String, dynamic> comment;
  final int currentUserId;
  final Function(int commentId) onDelete;
  final Function(int parentId, String parentUsername) onReply;
  final int level; //utk indent

  const CommentItem({
    Key? key,
    required this.comment,
    required this.currentUserId,
    required this.onDelete,
    required this.onReply,
    this.level = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOwn = comment['user_id'] == currentUserId;
    final username = comment['User']?['username'] ?? 'Unknown';
    final replies = (comment['replies'] as List?) ?? [];
    
    return Padding(
      padding: EdgeInsets.only(
        left: level * 24.0,
        top: 8.0,
        bottom: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: level == 0 
                ? const Color(0xFF2A0A3D) 
                : const Color(0xFF1A0528),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFA600FF).withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_circle, 
                      color: const Color(0xFFA600FF), 
                      size: 20
                    ),
                    const SizedBox(width: 8),
                    Text(
                      username,
                      style: const TextStyle(
                        color: Color(0xFFA600FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    
                    TextButton.icon(
                      onPressed: () => onReply(comment['id'], username),
                      icon: const Icon(Icons.reply, size: 16),
                      label: const Text('Reply'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white70,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                    
                    //Delete button
                    if (isOwn)
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        color: Colors.red[300],
                        onPressed: () => _showDeleteDialog(context),
                      ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  comment['comment'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                
                const SizedBox(height: 4),
            
                Text(
                  _formatDate(comment['createdAt']),
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          if (replies.isNotEmpty)
            ...replies.map((reply) => CommentItem(
              comment: reply,
              currentUserId: currentUserId,
              onDelete: onDelete,
              onReply: onReply,
              level: level + 1,
            )),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final replies = (comment['replies'] as List?) ?? [];
    final hasReplies = replies.isNotEmpty;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A0528),
        title: const Text('Delete Comment', style: TextStyle(color: Colors.white)),
        content: Text(
          hasReplies
            ? 'This will also delete ${replies.length} ${replies.length == 1 ? 'reply' : 'replies'}. Continue?'
            : 'Delete this comment?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete(comment['id']);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);
      
      if (diff.inDays > 7) {
        return '${date.day}/${date.month}/${date.year}';
      } else if (diff.inDays > 0) {
        return '${diff.inDays}d ago';
      } else if (diff.inHours > 0) {
        return '${diff.inHours}h ago';
      } else if (diff.inMinutes > 0) {
        return '${diff.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }
}