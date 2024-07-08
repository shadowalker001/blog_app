import 'package:blog_app/graphql/graphql_config.dart';

// GraphQL query to fetch all blog posts
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

// GraphQL query to fetch a single blog post by ID
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

// GraphQL mutation to create a new blog post
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

// GraphQL mutation to update an existing blog post
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

// GraphQL mutation to delete a blog post by ID
String deleteBlogPost = """
mutation deleteBlogPost(\$blogId: String!) {
  ${GraphQLConfig.deleteBlog}(blogId: \$blogId) {
    success
  }
}
""";
