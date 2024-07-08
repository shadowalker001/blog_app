import 'package:blog_app/graphql/graphql_config.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import '../graphql/queries.dart';

class BlogService {
  final GraphQLClient _client;

  BlogService(this._client);

  Future<bool> createBlogPostService(
      String title, String subTitle, String body) async {
    try {
      final result = await _client.mutate(
        MutationOptions(
          document: gql(createBlogPost),
          variables: {
            'title': title,
            'subTitle': subTitle,
            'body': body,
          },
        ),
      );

      return result.data?[GraphQLConfig.createBlog]['success'] ?? false;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating blog post: $e');
      }
      return false;
    }
  }

  Future<bool> updateBlogPostService(
      String blogId, String title, String subTitle, String body) async {
    try {
      final result = await _client.mutate(
        MutationOptions(
          document: gql(updateBlogPost),
          variables: {
            'blogId': blogId,
            'title': title,
            'subTitle': subTitle,
            'body': body,
          },
        ),
      );

      return result.data?[GraphQLConfig.updateBlog]['success'] ?? false;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating blog post: $e');
      }
      return false;
    }
  }

  Future<bool> deleteBlogPostService(String blogId) async {
    try {
      final result = await _client.mutate(
        MutationOptions(
          document: gql(deleteBlogPost),
          variables: {
            'blogId': blogId,
          },
        ),
      );

      return result.data?[GraphQLConfig.deleteBlog]['success'] ?? false;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting blog post: $e');
      }
      return false;
    }
  }

  static String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('MMMM dd, yyyy hh:mm a').format(dateTime);
  }
}
