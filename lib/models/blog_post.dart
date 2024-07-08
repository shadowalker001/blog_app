import 'package:blog_app/services/blog_service.dart'; // Import BlogService for date formatting

class BlogPost {
  final String id; // Unique identifier of the blog post
  final String title; // Title of the blog post
  final String subTitle; // Subtitle of the blog post
  final String body; // Body content of the blog post
  final String dateCreated; // Date when the blog post was created
  bool isBookmarked; // Indicates if the blog post is bookmarked

  BlogPost({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.body,
    required this.dateCreated,
    this.isBookmarked = false, // Default to not bookmarked
  });

  // Factory method to create a BlogPost object from JSON data
  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'], // Extract id from JSON
      title: json['title'], // Extract title from JSON
      subTitle: json['subTitle'], // Extract subTitle from JSON
      body: json['body'], // Extract body from JSON
      dateCreated: BlogService.formatDateString(
          json['dateCreated']), // Format dateCreated using BlogService
      isBookmarked: false, // Default is not bookmarked
    );
  }
}
