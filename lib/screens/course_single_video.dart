import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/channel_model.dart';
import '../services/api_service.dart';


class SingleScreen extends StatefulWidget {
  @override
  _SingleScreenState createState() => _SingleScreenState();
}

class _SingleScreenState extends State<SingleScreen> {
  Channel? _channel;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: 'UCp-k3mxuzR8StQiga5lu9Lg');
    setState(() {
      _channel = channel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _channel != null
          ? SingleChildScrollView(
        child: YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: _channel!.videos.first.id, // Show the first video
            flags: YoutubePlayerFlags(
              autoPlay: false,
            ),
          ),
          liveUIColor: Colors.amber,
        ),
      )
          : Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
