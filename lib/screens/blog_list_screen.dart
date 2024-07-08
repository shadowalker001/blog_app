import 'package:blog_app/graphql/graphql_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../graphql/queries.dart';
import '../models/blog_post.dart';
import '../services/blog_service.dart';
import 'blog_detail_screen.dart';
import 'blog_form_screen.dart';
import 'blog_search_delegate.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({Key? key}) : super(key: key);

  @override
  BlogListScreenState createState() => BlogListScreenState();
}

class BlogListScreenState extends State<BlogListScreen> {
  late GraphQLClient client;
  late BlogService blogService;
  List<BlogPost> blogs = [];
  List<String> bookmarkedIds = [];

  @override
  void initState() {
    super.initState();
    // Load bookmarks once the widget binding is complete
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (bookmarkedIds.isEmpty) await loadBookmarks();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize GraphQL client and blog service when dependencies change
    setupClientAndService();
  }

  void setupClientAndService() {
    client = GraphQLProvider.of(context).value;
    blogService = BlogService(client);
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $message')),
    );
  }

  List<BlogPost> setBlogs(List tmpBlogs) {
    // Convert the list of dynamic objects to a list of BlogPost objects
    return tmpBlogs.map((json) => BlogPost.fromJson(json)).map((e) {
      e.isBookmarked = bookmarkedIds.contains(e.id);
      return e;
    }).toList();
  }

  Future<void> loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> bookmarkIds =
        prefs.getStringList(GraphQLConfig.bookmarks) ?? [];

    setState(() {
      bookmarkedIds = bookmarkIds;
    });
  }

  Future<void> saveBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(GraphQLConfig.bookmarks, bookmarkedIds);
  }

  void toggleBookmark(String postId) {
    setState(() {
      if (bookmarkedIds.contains(postId)) {
        bookmarkedIds.remove(postId);
      } else {
        bookmarkedIds.add(postId);
      }
    });
    saveBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog Posts'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              if (blogs.isNotEmpty) {
                showSearch(
                  context: context,
                  delegate: BlogSearchDelegate(
                    blogs: blogs,
                    blogService: blogService,
                    onToggleBookmark: toggleBookmark,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Query(
        options: QueryOptions(document: gql(fetchAllBlogs)),
        builder: (QueryResult result,
            {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            // Show error message if there's an exception
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
              showError("Failed to connect, make sure your network is stable!");
            });
            if (kDebugMode) {
              print(result.exception.toString());
            }
            return const Center(
                child: Text("Opps! Unable to fetch blogs at this time."));
          }

          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          blogs = setBlogs(result.data?[GraphQLConfig.allBlogPosts] ?? []);

          return blogs.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: blogs.length,
                  itemBuilder: (context, index) {
                    BlogPost blogPost = blogs[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
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
                              toggleBookmark(blogPost.id);
                              setState(() {
                                blogPost.isBookmarked = !blogPost.isBookmarked;
                              });
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
            if (result.hasException) {
              // Show error message if there's an exception
              if (kDebugMode) {
                print(result.exception.toString());
              }
            }
            return FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BlogFormScreen(blogService: blogService),
                  ),
                );

                if (result == true && refetch != null) {
                  // Refetch the blogs if a new blog post is added
                  refetch();
                }
              },
              child: const Icon(Icons.add),
            );
          }),
    );
  }
}
