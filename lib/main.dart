import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gravity_playground/gp/gravity_playground_game.dart';
import 'package:gravity_playground/main_menu.dart';

void main() {
  runApp(const GravityPlayground());
}

class GravityPlayground extends StatelessWidget {
  const GravityPlayground({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final _game = GravityPlaygroundGame();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gravity Playground"),
      ),
      body: Stack(
        children: [
          InteractiveViewer(
            minScale: 0.001,
            maxScale: 10.0,
            child: GameWidget(game: _game),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MainMenu(game: _game),
          ),
        ],
      ),
    );
  }
}
