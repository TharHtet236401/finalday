import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/savedPosts.dart';
import 'package:flutter_app/screens/watched_list_course.dart';

import '../components/colors.dart';
import 'courses.dart';

class WatchList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: null, // Set the AppBar to null
        body: Column(
          children: [
            Container(
              color: tuDarkBlue, // Set the background color
              child: const TabBar(
                tabs: [
                  Tab(
                    text: 'Saved Articles',
                  ),
                  Tab(
                    text: 'Recently Watched',
                  ),
                ],
                labelColor: Colors.white, // Text color of the selected tab
                unselectedLabelColor:
                Colors.black, // Text color of unselected tabs
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Article tab content (blank for now)
                  PostScreenSaved(),
// Course tab content
                  WatchedList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
