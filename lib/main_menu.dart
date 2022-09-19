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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          // TODO: Need to set a max height?
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade500.withOpacity(0.3),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(2.0),
              topRight: Radius.circular(2.0),
            ),
          ),
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: MenuItem(
                  header: "Playback Control",
                  body: GestureDetector(
                    onTap: _togglePaused,
                    child: Icon(
                      _paused ? Icons.play_arrow : Icons.pause_sharp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const VerticalDivider(width: 1, color: Colors.white),
              Expanded(
                child: MenuItem(
                  header: "Playback Speed: ${widget.game.playbackSpeed.toStringAsFixed(2)}",
                  body: Slider(
                    value: widget.game.playbackSpeed,
                    label: "Playback: ${widget.game.playbackSpeed}x",
                    onChanged: (v) {
                      setState(() {
                        widget.game.playbackSpeed = v;
                      });
                    },
                    min: 0.1,
                    max: 3.0,
                    divisions: 31,
                  ),
                ),
              ),
              const VerticalDivider(width: 1, color: Colors.white),
              Expanded(
                child: MenuItem(
                  header: "Gravity Force ${widget.game.attraction.toStringAsFixed(2)}",
                  body: Slider(
                    value: widget.game.attraction,
                    label: "Force: ${widget.game.attraction}x",
                    onChanged: (v) {
                      setState(() {
                        widget.game.attraction = v;
                      });
                    },
                    min: 0.1,
                    max: 3.0,
                    divisions: 31,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.header,
    required this.body,
  });

  final String header;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            header,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          body,
        ],
      ),
    );
  }
}
