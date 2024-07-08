import 'package:blog_app/graphql/graphql_config.dart';
import 'package:blog_app/screens/blog_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final ValueNotifier<GraphQLClient> client = GraphQLConfig.initializeClient();

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Blog App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const BlogListScreen(),
        ),
      ),
    );
  }
}
