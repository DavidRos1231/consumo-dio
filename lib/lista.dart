import 'package:flutter/material.dart';

class Lista extends StatefulWidget {
  const Lista({ super.key });

  @override
  // ignore: library_private_types_in_public_api
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Text('Lista de usuarios'),
    );
  }
}