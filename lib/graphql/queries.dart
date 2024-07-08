import 'package:blog_app/graphql/graphql_config.dart';

String fetchAllBlogs = """
query fetchAllBlogs {
  ${GraphQLConfig.allBlogPosts} {
    id
    title
    subTitle
    body
    dateCreated
  }
}
""";

String getBlog = """
query getBlog(\$blogId: String!) {
  ${GraphQLConfig.blogPost}(blogId: \$blogId) {
    id
    title
    subTitle
    body
    dateCreated
  }
}
""";

String createBlogPost = """
mutation createBlogPost(\$title: String!, \$subTitle: String!, \$body: String!) {
  ${GraphQLConfig.createBlog}(title: \$title, subTitle: \$subTitle, body: \$body) {
    success
    blogPost {
      id
      title
      subTitle
      body
      dateCreated
    }
  }
}
""";

String updateBlogPost = """
mutation updateBlogPost(\$blogId: String!, \$title: String!, \$subTitle: String!, \$body: String!) {
  ${GraphQLConfig.updateBlog}(blogId: \$blogId, title: \$title, subTitle: \$subTitle, body: \$body) {
    success
    blogPost {
      id
      title
      subTitle
      body
      dateCreated
    }
  }
}
""";

String deleteBlogPost = """
mutation deleteBlogPost(\$blogId: String!) {
  ${GraphQLConfig.deleteBlog}(blogId: \$blogId) {
    success
  }
}
""";
