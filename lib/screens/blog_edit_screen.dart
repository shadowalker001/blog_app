import 'package:flutter/material.dart';
import '../models/blog_post.dart';
import '../services/blog_service.dart'; // Import BlogService

class BlogEditScreen extends StatefulWidget {
  final BlogPost blogPost;
  final BlogService blogService;

  const BlogEditScreen(
      {super.key, required this.blogPost, required this.blogService});

  @override
  BlogEditScreenState createState() => BlogEditScreenState();
}

class BlogEditScreenState extends State<BlogEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _subTitleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.blogPost.title);
    _subTitleController = TextEditingController(text: widget.blogPost.subTitle);
    _bodyController = TextEditingController(text: widget.blogPost.body);
  }

  bool pageLoader = false;
  void setIsLoading(bool val) {
    setState(() {
      pageLoader = val;
    });
  }

  void showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text((isError ? 'Error: ' : '') + message)),
    );
  }

  void _submitForm() async {
    if (pageLoader) return;
    try {
      if (_titleController.text.trim().isEmpty ||
          _subTitleController.text.trim().isEmpty ||
          _bodyController.text.trim().isEmpty) {
        //invalid form
        showMessage("Form not properly filled!");
        return;
      }

      setIsLoading(true);
      // Perform update blog post operation
      var result = await widget.blogService.updateBlogPostService(
        widget.blogPost.id,
        _titleController.text,
        _subTitleController.text,
        _bodyController.text,
      );
      setIsLoading(false);
      if (result) {
        var updatedBlog = BlogPost(
          id: widget.blogPost.id,
          dateCreated: widget.blogPost.dateCreated,
          body: _bodyController.text,
          subTitle: _subTitleController.text,
          title: _titleController.text,
          isBookmarked: widget.blogPost.isBookmarked,
        );
        showMessage("Blog post updated successfully!", isError: false);
        // ignore: use_build_context_synchronously
        Navigator.pop(context, updatedBlog);
      } else {
        showMessage("Failed to update blog post.");
      }
    } catch (e) {
      setIsLoading(false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subTitleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Blog Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _subTitleController,
                decoration: const InputDecoration(
                  labelText: 'Subtitle',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _bodyController,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Body',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    // Adjust opacity based on pageLoader
                    return pageLoader
                        ? Colors.blue.withOpacity(0.5)
                        : Colors.blue;
                  }),
                ),
                child: pageLoader
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : const Text('Update Blog Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
