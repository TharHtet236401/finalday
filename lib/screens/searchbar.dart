import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/models/categorymodel.dart';
import 'package:flutter_app/screens/course_cat_detail.dart';
import 'package:flutter_app/screens/courses.dart';

import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const historyLength = 5;

  final List<String> _searchHistory = [];
  List<CategoryModel> categories = [];

  List<String>? filteredSearchHistory;

  String? selectedTerm;

  List<String> filterSearchTerms({
    @required String? filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  FloatingSearchBarController? controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  Future<List<CategoryModel>> _loadCategories() async {
    final jsonString = await rootBundle.loadString('assets/courses.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => CategoryModel.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CategoryModel>>(
        future: _loadCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            categories = snapshot.data ?? [];

            return Padding(
              padding: const EdgeInsets.only(top: 5, left: 6, right: 6),
              child: FloatingSearchBar(
                controller: controller,
                body: SearchResultsListView(
                  key: ValueKey(selectedTerm),
                  searchTerm: selectedTerm,
                  categories: categories,
                  onTap: (result) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CourseCatDetail(
                          selectedCategory: result,
                        ),
                      ),
                    );
                  },
                ),
                transition: SlideFadeFloatingSearchBarTransition(),
                physics: const BouncingScrollPhysics(),
                title: Text(
                  selectedTerm ?? 'Search Categories...',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                hint: 'Search and find out...',
                actions: [
                  FloatingSearchBarAction.searchToClear(),
                ],
                onQueryChanged: (query) {
                  filteredSearchHistory = filterSearchTerms(filter: query);
                },
                onSubmitted: (query) {
                  setState(() {
                    addSearchTerm(query);
                    selectedTerm = query;
                  });
                  controller!.close();
                },
                builder: (context, transition) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Material(
                      color: Colors.white,
                      elevation: 4,
                      child: Builder(
                        builder: (context) {
                          if (filteredSearchHistory!.isEmpty &&
                              controller!.query.isEmpty) {
                            return Container(
                              height: 56,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                'Start searching',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            );
                          } else if (filteredSearchHistory!.isEmpty) {
                            return ListTile(
                              title: Text(controller!.query),
                              leading: const Icon(Icons.search),
                              onTap: () {
                                setState(() {
                                  addSearchTerm(controller!.query);
                                  selectedTerm = controller!.query;
                                });
                                controller!.close();
                              },
                            );
                          } else {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: filteredSearchHistory!
                                  .map(
                                    (term) => ListTile(
                                  title: Text(
                                    term,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  leading: const Icon(Icons.history),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        deleteSearchTerm(term);
                                      });
                                    },
                                  ),
                                  onTap: () {
                                    setState(() {
                                      putSearchTermFirst(term);
                                      selectedTerm = term;
                                    });
                                    controller?.close();
                                  },
                                ),
                              )
                                  .toList(),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class SearchResultsListView extends StatelessWidget {
  final String? searchTerm;
  final List<CategoryModel> categories;
  final Function(String)? onTap;

  const SearchResultsListView({
    required Key key,
    required this.searchTerm,
    required this.categories,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (searchTerm == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
                    children: [
                      // Recommended Courses

                      const SizedBox(height: 82),
                      Row(
                        children: [
                          Text(
                            'Hot Searches',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // Handle "See All" button tap
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  // child: Text(
                                  //   'See All',
                                  //   style: TextStyle(
                                  //     color: Color(0xFF4d4dbf),
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 280,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(2.0, 2.0),
                                    blurRadius: 4.0,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: SizedBox(
                                  width: 180,
                                  height: 180,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CourseCard(
                                          courseTitle: index == 0
                                              ? 'Python Basics'
                                              : index == 1
                                              ? 'How to Teach'
                                              : index == 2
                                              ? 'Java Basics'
                                              : index == 3
                                              ? 'JavaScript Basics'
                                              : index == 4
                                              ? 'Vue.js Basics'
                                              : index == 5
                                              ? 'HTML 5 '
                                              : index == 6
                                              ? 'CSS Basics'
                                              : index == 7
                                              ? 'PHP Web Dev'
                                              : index ==
                                              8
                                              ? 'Ruby Basics'
                                              : index == 9
                                              ? 'React Basics'
                                              : 'Default Title',
                                          authorName: 'Author Name',
                                          imageAssetPath:
                                          'images/CourseIntro$index.jpg',
                                          description: index == 0
                                              ? 'Versatile and readable programming language'
                                              : index == 1
                                              ? 'Educational professional guiding student learning'
                                              : index == 2
                                              ? 'Object-oriented, platform-independent programming'
                                              : index == 3
                                              ? 'Dynamic scripting for web development'
                                              : index == 4
                                              ? 'Progressive JavaScript framework for UIs'
                                              : index == 5
                                              ? 'Latest standard for web content and structure'
                                              : index == 6
                                              ? 'Stylesheet language for web page design'
                                              : index == 7
                                              ? 'Server-side scripting for dynamic web pages'
                                              : index ==
                                              8
                                              ? 'Dynamic, object-oriented programming language'
                                              : index == 9
                                              ? 'JavaScript library for building UI components'
                                              : 'Default Description', // Default description if index is out of range
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Latest',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // Handle "See All" button tap
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  // child: Text(
                                  //   'See All',
                                  //   style: TextStyle(
                                  //     color: Color(0xFF4d4dbf),
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 280,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: EdgeInsets.only(right: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 4.0,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: SizedBox(
                                  width: 180,
                                  height: 180,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CourseCard(
                                          courseTitle: index == 0
                                              ? 'Python Basics'
                                              : index == 1
                                              ? 'How to Teach'
                                              : index == 2
                                              ? 'Java Basics'
                                              : index == 3
                                              ? 'JavaScript Basics'
                                              : index == 4
                                              ? 'Vue.js Basics'
                                              : index == 5
                                              ? 'HTML 5 '
                                              : index == 6
                                              ? 'CSS Basics'
                                              : index == 7
                                              ? 'PHP Web Dev'
                                              : index ==
                                              8
                                              ? 'Ruby Basics'
                                              : index == 9
                                              ? 'React Basics'
                                              : 'Default Title',
                                          authorName: 'Author Name',
                                          imageAssetPath:
                                          'images/CourseIntro$index.jpg',
                                          description: index == 0
                                              ? 'Versatile and readable programming language'
                                              : index == 1
                                              ? 'Educational professional guiding student learning'
                                              : index == 2
                                              ? 'Object-oriented, platform-independent programming'
                                              : index == 3
                                              ? 'Dynamic scripting for web development'
                                              : index == 4
                                              ? 'Progressive JavaScript framework for UIs'
                                              : index == 5
                                              ? 'Latest standard for web content and structure'
                                              : index == 6
                                              ? 'Stylesheet language for web page design'
                                              : index == 7
                                              ? 'Server-side scripting for dynamic web pages'
                                              : index ==
                                              8
                                              ? 'Dynamic, object-oriented programming language'
                                              : index == 9
                                              ? 'JavaScript library for building UI components'
                                              : 'Default Description', // Default description if index is out of range
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ])),
        ),
      );
    }

    final filteredCategories = categories
        .where((category) =>
        category.title.toLowerCase().contains(searchTerm!.toLowerCase()))
        .toList();

    return filteredCategories.isNotEmpty
        ? ListView(
      padding: const EdgeInsets.only(top: 80),
      children: List.generate(
        filteredCategories.length,
            (index) => ListTile(
          title: Text(filteredCategories[index].title),
          leading: Container(
              height: 50,
              width: 50,
              child: Image.network(filteredCategories[index].urlImage)),
          onTap: () {
            if (onTap != null) {
              onTap!(filteredCategories[index].title);
            }
          },
        ),
      ),
    )
        : Center(
      child: Text(
        'Not Found',
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}
