import 'package:flutter/material.dart';
import '../models/blog_post.dart';
import '../services/blog_service.dart';
import 'blog_detail_screen.dart';

class BlogSearchDelegate extends SearchDelegate<String> {
  List<BlogPost> blogs;
  final BlogService blogService;
  final Function(String) onToggleBookmark;

  BlogSearchDelegate({
    required this.blogs,
    required this.blogService,
    required this.onToggleBookmark,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search results based on `query`
    return _buildListView(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement suggestions based on `query`
    return _buildListView(context);
  }

  Widget _buildListView(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text('Type to search blogs'),
      );
    }

    List<BlogPost> filteredBlogs = blogs.where((blogPost) {
      return blogPost.title.toLowerCase().contains(query.toLowerCase()) ||
          blogPost.subTitle.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return StatefulBuilder(builder: (context, setState) {
      return ListView.builder(
        itemCount: filteredBlogs.length,
        itemBuilder: (context, index) {
          BlogPost blogPost = filteredBlogs[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
                trailing: IconButton(
                  icon: Icon(
                    blogPost.isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: blogPost.isBookmarked ? Colors.blue : null,
                  ),
                  onPressed: () {
                    setState(() {
                      blogs = blogs.map((e) {
                        if (e.id == blogPost.id) {
                          e.isBookmarked = !e.isBookmarked;
                        }
                        return e;
                      }).toList();
                    });
                    onToggleBookmark(blogPost.id);
                  },
                ),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlogDetailScreen(
                        blogPost: blogPost,
                        blogService: blogService,
                      ),
                    ),
                  );

                  if (result != false) {
                    // ignore: use_build_context_synchronously
                    close(context, result);
                  }
                },
              ),
            ),
          );
        },
      );
    });
  }
}
