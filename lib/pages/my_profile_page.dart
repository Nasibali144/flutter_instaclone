import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instaclone/models/post_model.dart';
import 'package:flutter_instaclone/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

  int axisCount = 1;
  List<Post> items = new List();

  String post_img1 = "https://firebasestorage.googleapis.com/v0/b/koreanguideway.appspot.com/o/develop%2Fpost.png?alt=media&token=f0b1ba56-4bf4-4df2-9f43-6b8665cdc964";
  String post_img2 = "https://firebasestorage.googleapis.com/v0/b/koreanguideway.appspot.com/o/develop%2Fpost2.png?alt=media&token=ac0c131a-4e9e-40c0-a75a-88e586b28b72";

  @override
  void initState() {
    super.initState();
    items.add(Post(
      img_post: post_img1,
      caption: "Discover more great images on our sponsor's site",
    ));
    items.add(Post(
      img_post: post_img2,
      caption: "Discover more great images on our sponsor's site",
    ));
  }

  File _image;

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Profile", style: TextStyle(color: Colors.black, fontFamily: "Billabong", fontSize: 25),),
        actions: [
          IconButton(
            onPressed: (){
              AuthService.signOutUser(context);
            },
            icon: Icon(Icons.exit_to_app),
            color: Colors.black87,
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [

            //#myphoto
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    border: Border.all(color: Color.fromRGBO(193, 53, 132, 1), width: 1.5),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: _image == null ? Image(
                      image: AssetImage("assets/images/ic_person.webp"),
                      fit: BoxFit.cover,
                      height: 70,
                      width: 70,
                    ) : Image.file(_image, height: 70, width: 70, fit: BoxFit.cover,),
                  ),
                ),

                Container(
                  height: 80,
                  width: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          _showPicker(context);
                        },
                          child: Icon(Icons.add_circle, color: Colors.purple,),
                      ),
                    ],
                  ),
                )
              ],
            ),

            //#myinfos
            SizedBox(height: 10,),
            Text("Nasibali".toUpperCase(), style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
            SizedBox(height: 3,),
            Text("abdiyevnasibali@gmail.com", style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.normal),),

            //#mycounts
            Container(
              height: 80,
              child: Row(
                children: [

                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("635", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
                          SizedBox(height: 3,),
                          Text("POSTS", style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal),),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 20, width: 1, color: Colors.grey.withOpacity(0.5),),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("4,562", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
                          SizedBox(height: 3,),
                          Text("FOLLOWERS", style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal),),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 20, width: 1, color: Colors.grey.withOpacity(0.5),),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("897", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
                          SizedBox(height: 3,),
                          Text("FOLLOWING", style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.normal),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //#photoviews
            Container(
              child: Row(
                children: [

                  Expanded(
                    child: Center(
                      child: IconButton(
                        icon: Icon(Icons.list_alt,),
                        onPressed: () {
                          setState(() {
                            axisCount = 1;
                          });
                        },
                      )
                    ),
                  ),

                  Expanded(
                    child: Center(
                        child: IconButton(
                          icon: Icon(Icons.grid_view,),
                          onPressed: () {
                            setState(() {
                              axisCount = 2;
                            });
                          },
                        )
                    ),
                  ),
                ],
              ),
            ),

            //#postgrid
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: axisCount),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _itemOfPost(items[index]);
                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _itemOfPost(Post post) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          Expanded(
            child: CachedNetworkImage(
              width: double.infinity,
              imageUrl: post.img_post,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 3,),
          Text(post.caption, style: TextStyle(color: Colors.black87.withOpacity(0.7),), maxLines: 2,)
        ],
      ),
    );
  }
}
