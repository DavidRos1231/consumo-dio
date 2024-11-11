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

  // Método para eliminar un post
  void deletePost(int id) {
    setState(() {
      posts.removeWhere((post) => post.id == id); // Eliminar el post de la lista
    });
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botón de editar
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Navegar a la pantalla de registro con los datos del post
                          Navigator.pushNamed(
                            context,
                            '/register',
                            arguments: post, // Pasar los datos del post
                          );
                        },
                      ),
                      // Botón de eliminar
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Eliminar el post directamente
                          deletePost(post.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a la pantalla de registro sin datos
          Navigator.pushNamed(context, '/register');
        },
        child: const Icon(Icons.person_add),
        tooltip: 'Ir a Registro',
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

  // Método para convertir un Post en un Map para JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }
}
