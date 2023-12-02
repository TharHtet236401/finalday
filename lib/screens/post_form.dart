import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/constant.dart';
import 'package:flutter_app/models/api_response.dart';
import 'package:flutter_app/models/post.dart';
import 'package:flutter_app/services/post_service.dart';
import 'package:flutter_app/services/user_service.dart';
import 'package:image_picker/image_picker.dart';
import '../components/colors.dart';

import 'login.dart';

class PostForm extends StatefulWidget {
  final Post? post;
  final String? title;

  PostForm({this.post, this.title});

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _txtControllerBody = TextEditingController();
  final TextEditingController _txtControllerTitle = TextEditingController();

  bool _loading = false;
  File? _imageFile;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _createPost() async {
    String? image = _imageFile == null ? null : getStringImage(_imageFile);
    ApiResponse response = await createPost(_txtControllerBody.text,_txtControllerTitle.text, image);

    if (response.error == null) {
      Navigator.of(context).pop();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  // edit post
  void _editPost(int postId) async {
    ApiResponse response = await editPost(postId, _txtControllerBody.text,_txtControllerTitle.text);
    if (response.error == null) {
      Navigator.of(context).pop();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  @override
  void initState() {
    if (widget.post != null) {
      _txtControllerBody.text = widget.post!.body ?? '';

      _txtControllerTitle.text = widget.post!.title ?? '';

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title}'),
        backgroundColor: tuDarkBlue,
      ),
      body: _loading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView(
        children: [

          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _txtControllerTitle,
                    validator: (val) => val!.isEmpty ? 'Title is required' : null,
                    decoration: InputDecoration(
                      hintText: "Post title...",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black38),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextFormField(
                    controller: _txtControllerBody,
                    keyboardType: TextInputType.multiline,
                    maxLines: 9,
                    validator: (val) => val!.isEmpty ? 'Post body is required' : null,
                    decoration: InputDecoration(
                      hintText: "Post body...",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black38),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 8),
            child: Card(
              elevation: 3,
              child: InkWell(
                onTap: () {
                  getImage();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Stack(
                    children: [
                      // Background Image
                      if (_imageFile != null)
                        Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        ),
                      // Add_a_photo Icon
                      Center(
                        child: _imageFile == null
                            ? Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.black38.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.white,
                              ),
                              Text(
                                'Pick Image',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        )
                            : SizedBox.shrink(), // Hide the icon when an image is selected
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),


          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: kTextButton('Post', () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _loading = !_loading;
                });
                if (widget.post == null) {
                  _createPost();
                } else {
                  _editPost(widget.post!.id ?? 0);
                }
              }
            }),
          )
        ],
      ),
    );
  }
}
