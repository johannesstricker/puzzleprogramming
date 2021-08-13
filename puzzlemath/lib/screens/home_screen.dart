import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Puzzle Programming'),
        centerTitle: true,
      ),
      body: Center(
        child: Ink(
          width: 100.0,
          height: 100.0,
          decoration: ShapeDecoration(
            color: Theme.of(context).primaryColor,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: const Icon(Icons.camera, size: 50.0),
            color: Colors.white,
            onPressed: () {
              Navigator.pushNamed(context, '/camera');
            },
          ),
        ),
      ),
    );
  }
}
