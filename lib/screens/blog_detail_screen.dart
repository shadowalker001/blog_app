// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import '../models/blog_post.dart';
import '../services/blog_service.dart';
import 'blog_edit_screen.dart';

class BlogDetailScreen extends StatefulWidget {
  final BlogPost blogPost;
  final BlogService blogService;

  const BlogDetailScreen(
      {super.key, required this.blogPost, required this.blogService});

  @override
  State<BlogDetailScreen> createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  late BlogPost _blogPost;
  // Completer to handle returning _blogPost from onWillPop
  late Completer<BlogPost> _completer;

  Future<void> _deleteBlogPost(BuildContext context) async {
    try {
      bool success =
          await widget.blogService.deleteBlogPostService(_blogPost.id);

      if (success) {
        // Handle success scenario (e.g., navigate back to blog list)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Blog post deleted successfully')),
        );
        Navigator.pop(context, true); // Navigate back and pass success status
      } else {
        // Handle failure scenario (e.g., show error message)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete blog post')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Unable to delete blog post at this time')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _blogPost = widget.blogPost;
    _completer = Completer<BlogPost>();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Perform additional actions before popping the screen
        // Complete the completer with _blogPost
        _completer.complete(_blogPost);

        // Allow the screen to be popped
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_blogPost.title, overflow: TextOverflow.ellipsis),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                // Navigate to edit screen or show dialog for updating blog post
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlogEditScreen(
                        blogPost: _blogPost, blogService: widget.blogService),
                  ),
                );

                // Check if the result is a BlogPost and handle accordingly
                if (result is BlogPost) {
                  // Handle the updated BlogPost
                  setState(() {
                    _blogPost = result;
                  });
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteBlogPost(context),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _blogPost.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _blogPost.subTitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _blogPost.dateCreated,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                Divider(
                  height: 30,
                  thickness: 1,
                  color: Colors.grey[300],
                ),
                Text(
                  _blogPost.body,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
