import 'package:flutter/material.dart';
import 'package:gravity_playground/gp/gravity_playground_game.dart';

class MainMenu extends StatefulWidget {
  final GravityPlaygroundGame game;

  const MainMenu({super.key, required this.game});

  @override
  State<StatefulWidget> createState() {
    return MainMenuState();
  }
}

class MainMenuState extends State<MainMenu> {
  bool _paused = false;

  void _togglePaused() {
    setState(() {
      _paused = !_paused;
      if (_paused) {
        widget.game.pauseEngine();
      } else {
        widget.game.resumeEngine();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade500.withOpacity(0.3),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          )),
      height: 0.05 * MediaQuery.of(context).size.height,
      width: 0.4 * MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: _togglePaused,
              child: Icon(
                _paused ? Icons.play_arrow : Icons.pause_sharp,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Slider(
              value: widget.game.playbackSpeed,
              label: "Playback: ${widget.game.playbackSpeed}x",
              onChanged: (v) {
                setState(() {
                  widget.game.playbackSpeed = v;
                });
              },
              min: 0.01,
              max: 5.0,
              divisions: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Slider(
              value: widget.game.attraction,
              label: "Force: ${widget.game.attraction}x",
              onChanged: (v) {
                setState(() {
                  widget.game.attraction = v;
                });
              },
              min: 0.01,
              max: 10.0,
              divisions: 100,
            ),
          ),
        ],
      ),
    );
  }
}
