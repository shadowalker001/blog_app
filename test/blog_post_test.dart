import 'package:flutter_test/flutter_test.dart';

import 'package:blog_app/models/blog_post.dart';

void main() {
  test('BlogPost.fromJson creates object correctly', () {
    final json = {
      'id': '1',
      'title': 'Test Title',
      'subTitle': 'Test Subtitle',
      'body': 'Test Body',
      'dateCreated': '2024-07-09T12:00:00Z',
    };

    final blogPost = BlogPost.fromJson(json);

    expect(blogPost.id, '1');
    expect(blogPost.title, 'Test Title');
    expect(blogPost.subTitle, 'Test Subtitle');
    expect(blogPost.body, 'Test Body');
    expect(blogPost.dateCreated, 'July 09, 2024 12:00 PM');
    expect(blogPost.isBookmarked, false); // Default value
  });
}
