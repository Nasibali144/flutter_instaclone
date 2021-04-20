import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_instaclone/models/post_model.dart';
import 'package:flutter_instaclone/services/data_service.dart';
import 'package:flutter_instaclone/services/util_service.dart';

class MyFeedPage extends StatefulWidget {

  PageController pageController;
  MyFeedPage({this.pageController});

  @override
  _MyFeedPageState createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  bool isLoading = false;
  List<Post> items = new List();

  void _apiLoadFeeds() {
    setState(() {
      isLoading = true;
    });
    DataService.loadFeeds().then((value) => {
      _resLoadFeeds(value)
    });
  }

  void _resLoadFeeds(List<Post> posts) {
    setState(() {
      items = posts;
      isLoading = false;
    });
  }

  void _apiPostLike(Post post) async {
    setState(() {
      isLoading = true;
    });

    await DataService.likePost(post, true);
    setState(() {
      isLoading = false;
      post.liked = true;
    });
  }

  void _apiPostUnLike(Post post) async {
    setState(() {
      isLoading = true;
    });

    await DataService.likePost(post, false);
    setState(() {
      isLoading = false;
      post.liked = false;
    });
  }

  _actionRemovePost(Post post) async {
    var result = await Utils.dialogCommon(context, "Remove", "Do oyu want to remove this post?", false);

    if(result != null && result) {
      setState(() {
        isLoading = true;
      });
      DataService.removePost(post).then((value) => {
        _apiLoadFeeds(),
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _apiLoadFeeds();
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
      body: Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              return _itemOfPost(items[index]);
            },
          ),

          isLoading ? Center(child: CircularProgressIndicator(),) : SizedBox.shrink(),
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
                        Text(post.fullname,  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                        Text(post.date),
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
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),

          //#like #share
          Row(
            children: [
              IconButton(onPressed: () {
                if(!post.liked) {
                  _apiPostLike(post);
                } else {
                  _apiPostUnLike(post);
                }
              },
                icon: post.liked ? Icon(FontAwesome.heart, color: Colors.red,) : Icon(FontAwesome.heart_o,),
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.share_outlined,),),
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
