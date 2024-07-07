import 'package:blog_app/services/blog_service.dart';

String fetchAllBlogs = """
query fetchAllBlogs {
  ${BlogService.allBlogPosts} {
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
  ${BlogService.blogPost}(blogId: \$blogId) {
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
  ${BlogService.createBlog}(title: \$title, subTitle: \$subTitle, body: \$body) {
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
  ${BlogService.updateBlog}(blogId: \$blogId, title: \$title, subTitle: \$subTitle, body: \$body) {
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
  ${BlogService.deleteBlog}(blogId: \$blogId) {
    success
  }
}
""";
