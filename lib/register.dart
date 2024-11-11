import 'package:flutter/material.dart';
import 'lista.dart'; // Importa la clase Post para acceder al modelo

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userId = TextEditingController();
  final TextEditingController _body = TextEditingController();
  final TextEditingController _title = TextEditingController();
  Post? _post; // Para almacenar el post que estamos editando

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Recibir el post a editar, si lo hay
    final Post? post = ModalRoute.of(context)?.settings.arguments as Post?;
    if (post != null) {
      _post = post;
      // Cargar los datos del post en los controladores
      _userId.text = post.userId.toString();
      _title.text = post.title;
      _body.text = post.body;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_post == null ? 'Registrar Post' : 'Editar Post'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Campo User ID
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          hintText: "0",
                          label: Text("User ID"),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        keyboardType: TextInputType.number,
                        controller: _userId,
                        readOnly: _post != null, // No editable si es edición
                      ),
                      const SizedBox(height: 16.0),
                      // Campo Título
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          hintText: "Titulo",
                          label: Text("Título"),
                          prefixIcon: Icon(Icons.title),
                        ),
                        controller: _title,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese un título';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      // Campo Cuerpo del post
                      TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          hintText: "Escribe la publicación",
                          label: Text("Publicación"),
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                        controller: _body,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingrese el cuerpo del post';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32.0),
                      // Botón de guardar
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _savePost,
                          child: Text(_post == null ? 'Crear Post' : 'Guardar Cambios'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Método para guardar los cambios del post
  void _savePost() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedPost = Post(
        userId: int.parse(_userId.text), // Obtener el UserId del campo
        id: _post?.id ?? 0, // Si es edición, mantenemos el ID del post actual
        title: _title.text,
        body: _body.text,
      );

      // Aquí se pueden manejar los datos, como enviarlos a una API o base de datos
      print("Post guardado: ${updatedPost.toJson()}");

      // Volver a la pantalla anterior (Lista)
      Navigator.pop(context);
    }
  }
}
