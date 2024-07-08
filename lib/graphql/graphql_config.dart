import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  static String allBlogPosts = "allBlogPosts";
  static String createBlog = "createBlog";
  static String updateBlog = "updateBlog";
  static String deleteBlog = "deleteBlog";
  static String blogPost = "blogPost";
  static String bookmarks = "bookmarks";

  static HttpLink httpLink = HttpLink(
    'https://uat-api.vmodel.app/graphql/',
  );

  static ValueNotifier<GraphQLClient> initializeClient() {
    final Link link = httpLink;

    return ValueNotifier(
      GraphQLClient(
        link: link,
        cache: GraphQLCache(store: InMemoryStore()),
      ),
    );
  }
}
