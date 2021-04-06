import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_instaclone/models/post_model.dart';

class MyFeedPage extends StatefulWidget {

  PageController pageController;
  MyFeedPage({this.pageController});

  @override
  _MyFeedPageState createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Instagram", style: TextStyle(color: Colors.black, fontSize: 30, fontFamily: "Billabong"),),
        actions: [
          IconButton(
            icon: Icon(Icons.camera_alt, color: Color.fromRGBO(193, 53, 132, 1),),
            onPressed: () {
              widget.pageController.animateToPage(2, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (ctx, index) {
          return _itemOfPost(items[index]);
        },
      ),
    );
  }

  Widget _itemOfPost(Post post) {
    return Container(
      child: Column(
        children: [
          Divider(),

          // #userinfo
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.asset('assets/images/ic_person.webp', height: 40, width: 40, fit: BoxFit.cover,),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("User Name",  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                        Text("February 10, 20:00"),
                      ],
                    ),
                  ],
                ),
                IconButton(onPressed: (){}, icon: Icon(SimpleLineIcons.options,),),
              ],
            ),
          ),

          // #image
          CachedNetworkImage(
            imageUrl: post.img_post,
            fit: BoxFit.cover,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),

          //#like #share
          Row(
            children: [
              IconButton(onPressed: () {}, icon: Icon(FontAwesome.heart_o,),),
              IconButton(onPressed: () {}, icon: Icon(FontAwesome.send,),),
            ],
          ),

          // #caption
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10,),
            child: RichText(
              softWrap: true,
              overflow: TextOverflow.visible,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: " ${post.caption}",
                    style: TextStyle(color: Colors.black),
                  )
                ]
              ),
            ),
          )
        ],
      ),

    );
  }
}
