import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  static String allBlogPosts =
      "allBlogPosts"; // GraphQL query for fetching all blog posts
  static String createBlog =
      "createBlog"; // Mutation for creating a new blog post
  static String updateBlog =
      "updateBlog"; // Mutation for updating an existing blog post
  static String deleteBlog = "deleteBlog"; // Mutation for deleting a blog post
  static String blogPost =
      "blogPost"; // GraphQL query for fetching a single blog post
  static String bookmarks = "bookmarks"; // Placeholder for bookmarks feature

  static HttpLink httpLink = HttpLink(
    'https://uat-api.vmodel.app/graphql/', // GraphQL endpoint URL
  );

  static ValueNotifier<GraphQLClient> initializeClient() {
    final Link link = httpLink; // HTTP link for GraphQL client

    // Initialize GraphQL client with HTTP link and in-memory cache
    return ValueNotifier(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );
  }
}
