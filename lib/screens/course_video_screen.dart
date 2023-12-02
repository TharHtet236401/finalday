// import 'package:flutter/material.dart';
// import 'package:flutter_app/screens/courses.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
//
// import 'course_lesson_videos.dart';
//
// class VideoScreen extends StatefulWidget {
//   final String id;
//   final String title;
//
//   VideoScreen({required this.id, required this.title});
//
//   @override
//   _VideoScreenState createState() => _VideoScreenState();
// }
//
// class _VideoScreenState extends State<VideoScreen> {
//   late YoutubePlayerController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = YoutubePlayerController(
//       initialVideoId: widget.id,
//       flags: YoutubePlayerFlags(
//         mute: false,
//         autoPlay: true,
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.deepPurpleAccent,
//         title: Text(widget.title),
//
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: YoutubePlayer(
//               controller: _controller,
//               showVideoProgressIndicator: true,
//               onReady: () {
//                 print('Player is ready.');
//               },
//             ),
//           ),
//           SizedBox(height: 10.0),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15.0),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       "Author name - ",
//                       style: TextStyle(
//                         fontSize: 17.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       widget.title,
//                       style: TextStyle(
//                         fontSize: 17.0,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Building Web Applications - Intermediate Level',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 20,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       Text('Learn how to build a secure ecommerce application'),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 10.0),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 15.0),
//             child: Container(
//               height: 450,
//               child: CourseLessonScreen(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_app/components/colors.dart';
import 'package:flutter_app/screens/courses.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'course_lesson_videos.dart';

class VideoScreen extends StatefulWidget {
  final String id;
  final String title;

  VideoScreen({required this.id, required this.title});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;





  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
      ),
    );
  }

  void popMultiple(BuildContext context, int timesToPop) {
    for (int i = 0; i < timesToPop; i++) {
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tuDarkBlue,
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () { Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetailScreen(
                courseTitle: widget.title, title: '',
              ),
            ),
          ); },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              onReady: () {
                print('Player is ready.');
              },
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Author name - ",
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Building Web Applications - Intermediate Level',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Learn how to build a secure ecommerce application'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              height: 450,
              child: CourseLessonScreen(),
            ),
          ),
        ],
      ),
    );
  }
}

