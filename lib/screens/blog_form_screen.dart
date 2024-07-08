import 'package:flutter/material.dart';
import '../services/blog_service.dart';

class BlogFormScreen extends StatefulWidget {
  final BlogService blogService;

  const BlogFormScreen({super.key, required this.blogService});

  @override
  BlogFormScreenState createState() => BlogFormScreenState();
}

class BlogFormScreenState extends State<BlogFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

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
      String title = _titleController.text;
      String subTitle = _subTitleController.text;
      String body = _bodyController.text;

      if (title.trim().isEmpty ||
          subTitle.trim().isEmpty ||
          body.trim().isEmpty) {
        //invalid form
        showMessage("Form not properly filled!");
        return;
      }

      setIsLoading(true);
      // Perform create blog post operation
      bool success =
          await widget.blogService.createBlogPostService(title, subTitle, body);
      setIsLoading(false);

      if (success) {
        // Handle success scenario (e.g., navigate back to blog list)
        showMessage("Blog post created successfully", isError: false);
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true); // Navigate back and pass success status
      } else {
        // Handle failure scenario
        showMessage("Failed to create blog post");
      }
    } catch (e) {
      // Handle errors
      showMessage("Unable to create blog post");
      setIsLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Blog Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _subTitleController,
                decoration: const InputDecoration(labelText: 'Subtitle'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Body'),
                maxLines: 5,
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
                    : const Text('Create Blog Post'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
