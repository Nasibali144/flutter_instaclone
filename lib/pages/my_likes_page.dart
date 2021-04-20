import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_instaclone/models/post_model.dart';
import 'package:flutter_instaclone/services/data_service.dart';
import 'package:flutter_instaclone/services/util_service.dart';

class MyLikesPage extends StatefulWidget {
  @override
  _MyLikesPageState createState() => _MyLikesPageState();
}

class _MyLikesPageState extends State<MyLikesPage> {
  List<Post> items = new List();
  bool isLoading = false;

  void _apiLoadLikes() {
    setState(() {
      isLoading = true;
    });
    DataService.loadLikes().then((value) => {
      _resLoadLikes(value)
    });
  }

  void _resLoadLikes(List<Post> posts) {
    if (this.mounted) setState(() {
      items = posts;
      isLoading = false;
    });
  }

  void _apiPostUnlike(Post post) {
    if (this.mounted) setState(() {
      isLoading = true;
      post.liked = false;
    });
    DataService.likePost(post, false).then((value) => {
      _apiLoadLikes()
    });
  }

  _actionRemovePost(Post post) async {
    var result = await Utils.dialogCommon(context, "Remove", "Do oyu want to remove this post?", false);

    if(result != null && result) {
      setState(() {
        isLoading = true;
      });
      DataService.removePost(post).then((value) => {
        _apiLoadLikes(),
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _apiLoadLikes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("Likes", style: TextStyle(color: Colors.black, fontSize: 30, fontFamily: "Billabong"),),
      ),
      body: Stack(
        children: [
          items.length > 0 ?
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              return _itemOfPost(items[index]);
            },
          )
          : Center(
            child: Text("No liked posts"),
          ),

          isLoading ? Center(
            child: CircularProgressIndicator(),
          )
              : SizedBox.shrink(),
        ],
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
                post.mine ? IconButton(onPressed: (){
                  _actionRemovePost(post);
                }, icon: Icon(SimpleLineIcons.options,),) : SizedBox.shrink(),
              ],
            ),
          ),

          // #image
          CachedNetworkImage(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            imageUrl: post.img_post,
            placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fit: BoxFit.cover,
          ),
          //#like #share
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if(post.liked) {
                    _apiPostUnlike(post);
                  }
                },
                icon: post.liked ? Icon(FontAwesome.heart, color: Colors.red,) : Icon(FontAwesome.heart_o,),
              ),
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
