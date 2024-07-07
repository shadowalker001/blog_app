import 'package:blog_app/services/blog_service.dart';

class BlogPost {
  final String id;
  final String title;
  final String subTitle;
  final String body;
  final String dateCreated;

  BlogPost(
      {required this.id,
      required this.title,
      required this.subTitle,
      required this.body,
      required this.dateCreated});

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    return BlogPost(
      id: json['id'],
      title: json['title'],
      subTitle: json['subTitle'],
      body: json['body'],
      dateCreated: BlogService.formatDateString(json['dateCreated']),
    );
  }
}
