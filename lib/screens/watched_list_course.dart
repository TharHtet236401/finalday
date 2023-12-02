// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app/screens/courses.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';
//
// class WatchedList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         WatchedItem(
//           imageAssetPath: 'images/CourseIntro0.jpg',
//           text: 'Course 0',
//           percent: 90,
//           imageUrl: '',
//           height: 100,
//         ),
//         WatchedItem(
//           imageAssetPath: 'images/CourseIntro1.jpg',
//           text: 'Course 1',
//           percent: 75,
//           imageUrl: '',
//           height: 100,
//         ),
//         WatchedItem(
//           imageAssetPath: 'images/CourseIntro2.jpg',
//           text: 'Course 2',
//           percent: 50,
//           imageUrl: '',
//           height: 100,
//         ),
//         WatchedItem(
//           imageAssetPath: 'images/CourseIntro3.jpg',
//           text: 'Course 3',
//           percent: 90,
//           imageUrl: '',
//           height: 100,
//         ),
//         WatchedItem(
//           imageAssetPath: 'images/CourseIntro4.jpg',
//           text: 'Course 4',
//           percent: 90,
//           imageUrl: '',
//           height: 100,
//         ),
//         WatchedItem(
//           imageAssetPath: 'images/CourseIntro5.jpg',
//           text: 'Course 5',
//           percent: 90,
//           imageUrl: '',
//           height: 100,
//         ),
//       ],
//     );
//   }
// }
//
// class WatchedItem extends StatelessWidget {
//   final String imageUrl;
//   final String text;
//   final int percent;
//   final String imageAssetPath;
//   final double height;
//
//   WatchedItem({
//     required this.imageUrl,
//     required this.text,
//     required this.percent,
//     required this.imageAssetPath,
//     required this.height,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         // Navigate to another page here, you can use Navigator.push
//         // For example, pushing a MaterialPageRoute to a new page
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => CourseDetailScreen(title: text, courseTitle: '',), // Pass data to the new page if needed
//           ),
//         );
//       },
//       child: SizedBox(
//         height: height,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border.all(color: Colors.white, width: 1),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 2,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Image.asset(
//                       imageAssetPath,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   flex: 5,
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           text,
//                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(height: 8),
//                         Text('Watched: $percent%'),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     height: 45,
//                     width: 45,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: CircularProgressIndicator(
//                         value: percent / 100,
//                         strokeWidth: 5,
//
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/courses.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class WatchedList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        WatchedItem(
          imageAssetPath: 'images/CourseIntro0.jpg',
          text: 'Python Basics',
          percent: 90,
          imageUrl: '',
          height: 100,
        ),
        WatchedItem(
          imageAssetPath: 'images/CourseIntro1.jpg',
          text: 'Teaching Strategies',
          percent: 75,
          imageUrl: '',
          height: 100,
        ),
        WatchedItem(
          imageAssetPath: 'images/CourseIntro2.jpg',
          text: 'Java Fundamentals',
          percent: 50,
          imageUrl: '',
          height: 100,
        ),
        WatchedItem(
          imageAssetPath: 'images/CourseIntro3.jpg',
          text: 'JavaScript Mastery',
          percent: 30,
          imageUrl: '',
          height: 100,
        ),
        WatchedItem(
          imageAssetPath: 'images/CourseIntro4.jpg',
          text: 'Vue.js Essentials',
          percent: 10,
          imageUrl: '',
          height: 100,
        ),
        WatchedItem(
          imageAssetPath: 'images/CourseIntro5.jpg',
          text: 'HTML 5 Fundamentals',
          percent: 100,
          imageUrl: '',
          height: 100,
        ),
      ],
    );
  }
}

class WatchedItem extends StatelessWidget {
  final String imageUrl;
  final String text;
  final int percent;
  final String imageAssetPath;
  final double height;

  WatchedItem({
    required this.imageUrl,
    required this.text,
    required this.percent,
    required this.imageAssetPath,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailScreen(title: text, courseTitle: ''),
          ),
        );
      },
      child: SizedBox(
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      imageAssetPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text,
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,color: Color(0xFF216CAF)),
                        ),
                        SizedBox(height: 8),
                        Text('Watched: $percent%'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Expanded(
                    child: Center(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: SfRadialGauge(
                          axes: <RadialAxis>[
                            RadialAxis(
                              minimum: 0,
                              maximum: 100,
                              showLabels: false,
                              showTicks: false,
                              startAngle: 270,
                              endAngle: 270,
                              axisLineStyle: AxisLineStyle(
                                thickness: 1,
                                //color: const  Color.fromARGB(255, 0, 169, 181),
                                color:  Color(0xFF6b86f7),
                                thicknessUnit: GaugeSizeUnit.factor,
                              ),
                              pointers: <GaugePointer>[
                                RangePointer(
                                  value: percent.toDouble(),
                                  width: 0.15,
                                  color: Colors.white,
                                  pointerOffset: 0.1,
                                  cornerStyle: CornerStyle.bothCurve,
                                  sizeUnit: GaugeSizeUnit.factor,
                                ),
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                  positionFactor: 0.5,
                                  angle: 90,
                                  widget: Text('$percent%', style: TextStyle(fontSize: 15, color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),


              ],
            ),

          ),
        ),
      ),
    );

  }
}
