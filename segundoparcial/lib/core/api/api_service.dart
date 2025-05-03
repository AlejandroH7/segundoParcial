import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  // Obtener posts
  Future<List<dynamic>> getPosts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar posts');
    }
  }

  // Crear un nuevo post
  Future<void> createPost(int userId, String title, String body) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: json.encode({"userId": userId, "title": title, "body": body}),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear el post');
    }
  }
}
