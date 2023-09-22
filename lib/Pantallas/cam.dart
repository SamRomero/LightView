import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class Cam extends StatefulWidget {
  const Cam({
    required this.url,
  });

  final String url;
  @override
  _CamState createState() => _CamState();
}

class _CamState extends State<Cam> {
  late VlcPlayerController _vlcPlayerController;


  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    _vlcPlayerController = VlcPlayerController.network(
      widget.url,
      hwAcc: HwAcc.full, // You can adjust hardware acceleration as needed
    )..initialize().then((_) {
      setState(() {}); // Refresh the UI when the player is initialized
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cam Streaming'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9, // Adjust this according to your streaming's aspect ratio
          child: VlcPlayer(
            controller: _vlcPlayerController,
            aspectRatio: 16 / 9,
            placeholder: Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _vlcPlayerController.dispose();
  }
}



