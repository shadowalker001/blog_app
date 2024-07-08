import 'package:blog_app/graphql/graphql_config.dart'; // Import GraphQL configuration
import 'package:flutter/foundation.dart'; // Import foundation for kDebugMode
import 'package:graphql_flutter/graphql_flutter.dart'; // Import GraphQL Flutter library
import 'package:intl/intl.dart'; // Import date formatting library
import '../graphql/queries.dart'; // Import GraphQL queries

class BlogService {
  final GraphQLClient _client; // GraphQL client instance

  // Constructor to initialize with GraphQL client
  BlogService(this._client);

  // Method to create a new blog post
  Future<bool> createBlogPostService(
      String title, String subTitle, String body) async {
    try {
      final result = await _client.mutate(
        // Perform GraphQL mutation
        MutationOptions(
          document:
              gql(createBlogPost), // GraphQL document for creating a blog post
          variables: {
            'title': title, // Title of the blog post
            'subTitle': subTitle, // Subtitle of the blog post
            'body': body, // Body content of the blog post
          },
        ),
      );

      // Check if mutation was successful, default to false if not available
      return result.data?[GraphQLConfig.createBlog]['success'] ?? false;
    } catch (e) {
      // Handle errors during mutation
      if (kDebugMode) {
        print('Error creating blog post: $e'); // Print error in debug mode
      }
      return false; // Return false indicating failure
    }
  }

  // Method to update an existing blog post
  Future<bool> updateBlogPostService(
      String blogId, String title, String subTitle, String body) async {
    try {
      final result = await _client.mutate(
        // Perform GraphQL mutation
        MutationOptions(
          document:
              gql(updateBlogPost), // GraphQL document for updating a blog post
          variables: {
            'blogId': blogId, // ID of the blog post to update
            'title': title, // Updated title of the blog post
            'subTitle': subTitle, // Updated subtitle of the blog post
            'body': body, // Updated body content of the blog post
          },
        ),
      );

      // Check if mutation was successful, default to false if not available
      return result.data?[GraphQLConfig.updateBlog]['success'] ?? false;
    } catch (e) {
      // Handle errors during mutation
      if (kDebugMode) {
        print('Error updating blog post: $e'); // Print error in debug mode
      }
      return false; // Return false indicating failure
    }
  }

  // Method to delete a blog post
  Future<bool> deleteBlogPostService(String blogId) async {
    try {
      final result = await _client.mutate(
        // Perform GraphQL mutation
        MutationOptions(
          document:
              gql(deleteBlogPost), // GraphQL document for deleting a blog post
          variables: {
            'blogId': blogId, // ID of the blog post to delete
          },
        ),
      );

      // Check if mutation was successful, default to false if not available
      return result.data?[GraphQLConfig.deleteBlog]['success'] ?? false;
    } catch (e) {
      // Handle errors during mutation
      if (kDebugMode) {
        print('Error deleting blog post: $e'); // Print error in debug mode
      }
      return false; // Return false indicating failure
    }
  }

  // Static method to format a date string into a specific format
  static String formatDateString(String dateString) {
    DateTime dateTime =
        DateTime.parse(dateString); // Parse date string to DateTime object
    return DateFormat('MMMM dd, yyyy hh:mm a')
        .format(dateTime); // Format DateTime object
  }
}
