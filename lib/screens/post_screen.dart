import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/components/premiumbanner.dart';
import 'package:flutter_app/constant.dart';
import 'package:flutter_app/models/api_response.dart';
import 'package:flutter_app/models/post.dart';
import 'package:flutter_app/services/post_service.dart';
import 'package:flutter_app/services/user_service.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'notifications.dart';
import 'package:flutter_app/components/colors.dart';
import 'login.dart';
import 'post_form.dart';
import 'herodialogroute.dart';

const String _heroAddTodo = 'add-todo-hero';
class ExpandedPostPage extends StatelessWidget {
  final String? postBody;
  final String? postTitle;
  final String? postImage;
  final String? poster;
  final DateTime time;
  final String? posterImage;

  ExpandedPostPage({required this.postBody,
    required this.postTitle,
    required this.postImage,
    required this.poster,
    required this.time,
    required this.posterImage});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 40, 5, 20),
          child: Material(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(7.5),
                        topRight: Radius.circular(7.5),
                      ),
                      child: Container(
                        height: 66,
                        color: tuDarkBlue,
                        padding: const EdgeInsets.fromLTRB(5, 11, 11, 0),
                        child: SingleChildScrollView(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 11),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,

                                  children: [

                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        image: posterImage != null
                                            ? DecorationImage(
                                            image: NetworkImage(
                                                '$posterImage'))
                                            : null,
                                        borderRadius:
                                        BorderRadius.circular(25),
                                        border: Border.all(
                                          color: tuLightBlue, // Border color
                                          width: 1, // Border width
                                        ),
                                      ),

                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${poster}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18),
                                          ),
                                          Text(
                                            DateFormat('HH:mm, dd/MM/yy').format(time),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ]
                                    )

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 3,
                      right: 0,
                      child: IconButton(
                        color: Colors.white,
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        postImage != null
                            ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: 400,
                          margin: const EdgeInsets.only(top: 0),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                  NetworkImage('${postImage}'),
                                  fit: BoxFit.cover)),
                        )
                            : SizedBox(
                          height: postImage != null ? 0 : 10,
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: Text(
                            postBody!,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
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


class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final PremiumMembershipController premiumMembershipController =
  Get.find<PremiumMembershipController>();
  List<dynamic> _postList = [];
  int userId = 0;
  bool _loading = true;

  // get all posts
  Future<void> retrievePosts() async {
    userId = await getUserId();
    ApiResponse response = await getPosts();
    // premiumMembershipController.reinitialize();
    if (response.error == null) {
      setState(() {
        _postList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  void _handleDeletePost(int postId) async {
    ApiResponse response = await deletePost(postId);
    if (response.error == null) {
      retrievePosts();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // post like dislik
  void _handlePostLikeDislike(int postId) async {
    ApiResponse response = await likeUnlikePost(postId);

    if (response.error == null) {
      retrievePosts();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _handlePostSaveUnsave(int postId) async {
    ApiResponse response = await saveUnsavedPost(postId);

    if (response.error == null) {
      retrievePosts();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // void showExpandedTextDialog(String? postBody, BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return BackdropFilter(
  //         filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Adjust the blur intensity
  //         child: Dialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: CustomScrollView(
  //             slivers: [
  //               SliverAppBar(
  //                 automaticallyImplyLeading: false, // Remove the back button
  //                 expandedHeight: 100.0, // Adjust the height as needed
  //                 pinned: true,
  //                 flexibleSpace: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Text('Expanded Post', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  //                     IconButton(
  //                       icon: Icon(Icons.close),
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               SliverList(
  //                 delegate: SliverChildListDelegate(
  //                   [
  //                     Container(
  //                       width: 800, // Set the width to your desired value
  //                       padding: EdgeInsets.all(16),
  //                       child: Text(
  //                         postBody!,
  //                         style: TextStyle(fontSize: 18),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }





  void showExpandedTextDialog(String? postBody, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Adjust the blur intensity
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              width: 800,
              height: 1000, // Set the width to 600 pixels
              child: Stack(
                children: <Widget>[
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    child: Container(
                      width: 300, // Set the width as needed
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        postBody!,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10, // Adjust the top position as needed
                    right: 10, // Adjust the right position as needed
                    child: IconButton(
                      icon: const Icon(Icons.close), // Use the "close" icon or any other icon you prefer
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }








  @override
  void initState() {
    retrievePosts();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
      onRefresh: () {
        return retrievePosts();
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: tuDarkBlue,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PostForm(
                  title: 'Add new post',
                )));
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation:
        FloatingActionButtonLocation.endFloat,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: StickyHeaderDelegate(
                child: PremiumMembershipAd(),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  // Your existing code for building post cards
                  Post post = _postList[index];
                  DateTime serverDateTime =
                  DateTime.parse("${post.created_at}");
                  DateTime localDateTime = serverDateTime.toLocal();

                  return Container(
                    width: double.infinity,
                    child: Card(
                        elevation: 0.6,
                        color: Colors.white,
                        margin: const EdgeInsets.fromLTRB(0, 7, 0, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: tuDarkBlue.withOpacity(0.5), // Set the background color with opacity, // Set the border color here
                            width: 1, // Set the border width here
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Positioned(
                            //   bottom: 0,
                            //   right: 0,
                            //   child: Image.asset(
                            //     'images/articlebg.png',
                            //     width: 100,
                            //     height: 100,
                            //     fit: BoxFit.cover,
                            //   ),
                            // ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 11),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,

                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              image: post.user!.image != null
                                                  ? DecorationImage(
                                                image: NetworkImage('${post.user!.image}'),
                                                fit: BoxFit.cover, // Adjust the fit based on your design requirements
                                              )
                                                  : const DecorationImage(
                                                image: AssetImage('images/default.png'), // Provide the path to your default image
                                                fit: BoxFit.cover,
                                              ),
                                              borderRadius: BorderRadius.circular(25),
                                              border: Border.all(
                                                color: tuDarkBlue,
                                                width: 1,
                                              ),
                                            ),
                                          ),

                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${post.user!.name}',
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  DateFormat('HH:mm, dd/MM/yy').format(localDateTime),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ]
                                          )

                                        ],
                                      ),
                                    ),
                                    post.user!.id == userId
                                        ? PopupMenuButton(
                                      child: const Padding(
                                          padding:
                                          EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.more_vert,
                                            color: Colors.black,
                                          )),
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                            child: Text('Edit'),
                                            value: 'edit'),
                                        const PopupMenuItem(
                                            child: Text('Delete'),
                                            value: 'delete')
                                      ],
                                      onSelected: (val) {
                                        if (val == 'edit') {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PostForm(
                                                        title: 'Edit Post',
                                                        post: post,
                                                      )));
                                        } else {
                                          _handleDeletePost(post.id ?? 0);
                                        }
                                      },
                                    )
                                        : const SizedBox()
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    (post.title!.length > 200)
                                        ? InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                                          return ExpandedPostPage(postBody: post.title,
                                              postTitle: post.body,
                                              postImage: post.image,
                                              poster: post.user!.name,
                                              time: localDateTime,
                                              posterImage: post.user!.image);
                                        }));
                                      },
                                      // onTap: () {
                                      //   if (post.title!.length > 200) {
                                      //     Navigator.of(context).push(
                                      //       MaterialPageRoute(
                                      //         builder: (context) => ExpandedPostPage(postBody: post.title),
                                      //       ),
                                      //     );
                                      //   }
                                      // },
                                      // onTap: () {
                                      //   if (post.title!.length > 200) {
                                      //     showExpandedTextDialog(post.body, context);
                                      //   }
                                      // },
                                      // onTap: () {
                                      //   Navigator.of(context).push(
                                      //     MaterialPageRoute(
                                      //       builder: (context) => NotificationsPage(),
                                      //     ),
                                      //   );
                                      // },
                                      child: Hero(
                                        tag: _heroAddTodo,
                                        child: Container(
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(11, 4, 11, 7),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${post.body}",
                                                   // Center align the text
                                                  style: const TextStyle(
                                                     // Make the text bold
                                                    fontSize: 19.0,
                                                    fontWeight:FontWeight.w500,// Set the font size to 18
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                ReadMoreText(
                                                  '${post.title}  ',
                                                  colorClickableText: Colors.blueGrey,
                                                  trimLength: 200,
                                                  trimMode: TrimMode.Length,
                                                  trimCollapsedText: 'Read more',
                                                  trimExpandedText: 'Read less',
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                  ),
                                                  moreStyle: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  lessStyle: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                        : Container(
                                      width: double.infinity,
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(11, 4, 11, 7),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${post.body}",
                                                 // Center align the text
                                                style: const TextStyle(
                                                   // Make the text bold
                                                  fontSize: 19.0, // Set the font size to 18
                                                ),
                                              ),
                                              Text(
                                                '${post.title}',
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ],
                                          )
                                      ),
                                    ),
                                  ],
                                ),

                                // InkWell(
                                //   onTap: () {
                                //     Navigator.of(context).push(
                                //       MaterialPageRoute(
                                //         builder: (context) => NotificationsPage(),
                                //       ),
                                //     );
                                //   },
                                //   child: Container(
                                //     width: double.infinity,
                                //     child: Padding(
                                //       padding:
                                //           const EdgeInsets.fromLTRB(11, 4, 11, 7),
                                //       child: ReadMoreText(
                                //         '${post.body}  ',
                                //         colorClickableText: Colors.blueGrey,
                                //         trimLength: 200,
                                //         trimMode: TrimMode.Length,
                                //         trimCollapsedText: 'Read more',
                                //         trimExpandedText: 'Read less',
                                //         style: TextStyle(
                                //             fontSize: 16,
                                //         ),
                                //         moreStyle: TextStyle(
                                //             fontSize: 16,
                                //             fontWeight: FontWeight.bold),
                                //         lessStyle: TextStyle(
                                //             fontSize: 16,
                                //             fontWeight: FontWeight.bold),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                post.image != null
                                    ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 400,
                                  margin: const EdgeInsets.only(top: 0),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image:
                                          NetworkImage('${post.image}'),
                                          fit: BoxFit.cover)),
                                )
                                    : SizedBox(
                                  height: post.image != null ? 0 : 10,
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.start,
                                  children: [
                                    kLikeAndComment(
                                        post.likesCount ?? 0,
                                        post.selfLiked == true
                                            ? Icons.favorite
                                            : Icons.favorite_outline,
                                        post.selfLiked == true
                                            ? Colors.red
                                            : Colors.black54, () {
                                      _handlePostLikeDislike(post.id ?? 0);
                                    }),
                                    Container(
                                      height: 26,
                                      width: 0.7,
                                      color: Colors.black38,
                                    ),
                                    save(
                                        post.likesCount ?? 0,
                                        post.selfSaved == true ? Icons.bookmark_added: Icons.bookmark_outline,
                                        post.selfSaved == true ? Colors.black87 : Colors.black54, () {
                                      _handlePostSaveUnsave(post.id ?? 0);
                                    }),

                                    // kLikeAndComment(post.commentsCount ?? 0,
                                    //     Icons.bookmark, Colors.black54, () {
                                    //   Navigator.of(context).push(MaterialPageRoute(
                                    //       builder: (context) => CommentScreen(
                                    //             postId: post.id,
                                    //           )));
                                    // }),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )),
                  );
                },
                childCount: _postList.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final PremiumMembershipController premiumMembershipController =
  Get.find<PremiumMembershipController>();
  final Widget child;

  StickyHeaderDelegate({required this.child});

  // @override
  // double get maxExtent => 100.0; // Adjust the max extent as needed
  //
  // @override
  // double get minExtent => 100.0; // Adjust the min extent as needed



  @override
  double get maxExtent => premiumMembershipController.isBannerVisible.isTrue ? 100.0 : 0.0;

  @override
  double get minExtent => premiumMembershipController.isBannerVisible.isTrue ? 100.0 : 0.0;
  // Adjust the min extent as needed

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}