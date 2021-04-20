import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_instaclone/models/post_model.dart';
import 'package:flutter_instaclone/services/data_service.dart';
import 'package:flutter_instaclone/services/file_service.dart';
import 'package:image_picker/image_picker.dart';

class MyUploadPage extends StatefulWidget {

  final PageController pageController;
  MyUploadPage({this.pageController});

  @override
  _MyUploadPageState createState() => _MyUploadPageState();
}

class _MyUploadPageState extends State<MyUploadPage> {
  var captionController = TextEditingController();
  File _image;
  bool isLoading = false;

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Pick Photo'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Take Photo'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  _uploadNewPost() {
    String caption = captionController.text.toString().trim();
    if (caption.isEmpty) return;
    if (_image == null) return;

    _apiPostImage();
  }

  void _apiPostImage() {
    setState(() {
      isLoading = true;
    });

    FileService.uploadPostImage(_image).then((downloadUrl) => {
      _resPostImage(downloadUrl)
    });
  }

  void _resPostImage(String downloadUrl) {
    String caption = captionController.text.toString().trim();

    Post post = Post(img_post: downloadUrl, caption: caption);
    _apiStorePost(post);
  }

  void _apiStorePost(Post post) async{
    //Post to posts
    Post posted = await DataService.storePost(post);

    //Post to feeds
    DataService.storeFeed(posted).then((value) => {
      _moveToFeed()
    });
  }

  void _moveToFeed() {
    setState(() {
      isLoading = false;
    });

    captionController.text = "";
    _image = null;

    widget.pageController.animateToPage(0,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Upload",
          style: TextStyle(
              color: Colors.black, fontFamily: "Billabong", fontSize: 25),
        ),
        actions: [
          IconButton(
            onPressed: _uploadNewPost,
            icon: Icon(
              Icons.drive_folder_upload,
              color: Color.fromRGBO(193, 53, 132, 1),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.width,
                        color: Colors.grey.withOpacity(0.4),
                        child: _image == null ? Center(
                          child: Icon(Icons.add_a_photo, color: Colors.grey, size: 60,),
                        ) : Stack(
                          children: [
                            Image.file(
                              _image,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              width: double.infinity,
                              color: Colors.black12,
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.topRight,
                              child: IconButton(
                                icon: Icon(Icons.highlight_off, color: Colors.white,),
                                onPressed: () {
                                  setState(() {
                                    _image = null;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: captionController,
                        keyboardType: TextInputType.multiline,
                        style: TextStyle(color: Colors.black),
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Caption",
                          hintStyle: TextStyle(
                            fontSize: 17,
                            color: Colors.black38
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          isLoading ? Center(child: CircularProgressIndicator()) : SizedBox.shrink(),
        ],
      ),
    );
  }
}

//access photo
