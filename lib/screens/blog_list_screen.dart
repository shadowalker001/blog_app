import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/queries.dart';
import '../models/blog_post.dart';
import '../services/blog_service.dart';
import 'blog_detail_screen.dart';
import 'blog_form_screen.dart';

class BlogListScreen extends StatelessWidget {
  const BlogListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtain GraphQLClient from GraphQLProvider
    final GraphQLClient client = GraphQLProvider.of(context).value;

    // Initialize BlogService for BlogDetailScreen
    final blogService = BlogService(client);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Posts'),
      ),
      body: Query(
        options: QueryOptions(document: gql(fetchAllBlogs)),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          List blogs = result.data?[BlogService.allBlogPosts] ?? [];

          return ListView.builder(
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              BlogPost blogPost = BlogPost.fromJson(blogs[index]);
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      blogPost.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          blogPost.subTitle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          blogPost.dateCreated,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      // Navigate to BlogDetailScreen and pass dependencies
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlogDetailScreen(
                            blogPost: blogPost,
                            blogService: blogService,
                          ),
                        ),
                      );

                      // Refetch if the blog post was updated or deleted
                      if (result != false && refetch != null) {
                        refetch();
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: Query(
        options: QueryOptions(document: gql(fetchAllBlogs)),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          return FloatingActionButton(
            onPressed: () async {
              // Navigate to BlogFormScreen and pass dependencies
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BlogFormScreen(blogService: blogService),
                ),
              );

              // Refetch if a new blog post was added
              if (result == true && refetch != null) {
                refetch();
              }
            },
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
