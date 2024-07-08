import 'package:blog_app/graphql/graphql_config.dart'; // Import GraphQLConfig for GraphQL client initialization
import 'package:blog_app/screens/blog_list_screen.dart'; // Import BlogListScreen widget
import 'package:flutter/material.dart'; // Flutter framework
import 'package:graphql_flutter/graphql_flutter.dart'; // GraphQL Flutter integration

void main() {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter binding is initialized
  final ValueNotifier<GraphQLClient> client =
      GraphQLConfig.initializeClient(); // Initialize GraphQL client

  runApp(MyApp(
      client: client)); // Run the application with initialized GraphQL client
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client; // GraphQL client instance

  const MyApp({Key? key, required this.client})
      : super(key: key); // Constructor initializing with GraphQL client

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      // Provide GraphQL client to the widget tree
      client: client,
      child: CacheProvider(
        // Provide cache for GraphQL requests
        child: MaterialApp(
          // Root application widget
          debugShowCheckedModeBanner: false, // Disable debug banner
          title: 'Blog App', // Application title
          theme: ThemeData(
            // Application theme
            primarySwatch: Colors.blue, // Primary color theme
          ),
          home: const BlogListScreen(), // Initial screen of the application
        ),
      ),
    );
  }
}
