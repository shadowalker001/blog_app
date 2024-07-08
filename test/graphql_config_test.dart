import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:blog_app/graphql/graphql_config.dart';

void main() {
  test('GraphQLClient initialization', () {
    final client = GraphQLConfig.initializeClient();

    expect(client, isA<ValueNotifier<GraphQLClient>>());
    expect(client.value, isA<GraphQLClient>());
  });
}
