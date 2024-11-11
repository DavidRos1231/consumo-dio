import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Lista extends StatefulWidget {
  const Lista({super.key});

  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  late Dio dio; // Usaremos Dio para hacer la solicitud HTTP
  List<Post> posts = []; // Lista para almacenar los posts

  @override
  void initState() {
    super.initState();
    dio = Dio(); // Inicializar Dio
    fetchPosts(); // Llamar al método para obtener los posts
  }

  // Método para obtener los posts desde el servidor
  Future<void> fetchPosts() async {
    try {
      // URL del endpoint (aquí puedes poner la URL de tu API real)
      final response = await dio.get('https://jsonplaceholder.typicode.com/posts');
      
      // Parsear los datos JSON a una lista de objetos Post
      if (response.statusCode == 200) {
        List<Post> fetchedPosts = (response.data as List)
            .map((postJson) => Post.fromJson(postJson))
            .toList();

        setState(() {
          posts = fetchedPosts; // Actualizamos la lista de posts
        });
      } else {
        throw Exception('Error al cargar los posts');
      }
    } catch (e) {
      print("Error al hacer la consulta: $e");
      // Aquí puedes manejar los errores (mostrar un mensaje, etc.)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Posts'),
      ),
      body: posts.isEmpty
          ? const Center(child: CircularProgressIndicator()) // Mientras carga
          : ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(post.body),
                  leading: CircleAvatar(
                    child: Text(post.id.toString()), // Muestra el ID del post
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla de registro cuando se presiona el botón
          Navigator.pushNamed(context, '/register');
        },
        tooltip: 'Ir a Registro',
        child: const Icon(Icons.person_add),
      ),
    );
  }
}

// Clase para mapear los datos JSON
class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  // Método para crear un objeto Post desde un JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
