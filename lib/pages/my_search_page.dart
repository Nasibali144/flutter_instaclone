import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_instaclone/models/user_model.dart';
import 'package:flutter_instaclone/services/data_service.dart';

class MySearchPage extends StatefulWidget {
  @override
  _MySearchPageState createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  var searchController = TextEditingController();
  List<User> items = new List();
  bool isLoading = false;


  void _apiSearchUsers(String keyword) {
    setState(() {
      isLoading = true;
    });
    DataService.searchUsers(keyword).then((users) => {
      _respSearchUsers(users)
    });
  }

  void _respSearchUsers(List<User> users) {
    if (this.mounted) {
      setState(() {
        isLoading = false;
        items = users;
      });
    }
  }

  void _apiFollowUser(User someone) async{
    setState(() {
      isLoading = true;
    });
    await DataService.followUser(someone);
    setState(() {
      someone.followed = true;
      isLoading = false;
    });
    DataService.storePostsToMyFeed(someone);
  }



  void _apiUnFollowUser(User someone) async{
    setState(() {
      isLoading = true;
    });
    await DataService.unFollowUser(someone);
    setState(() {
      someone.followed = false;
      isLoading = false;
    });
    DataService.removePostsFromMyFeed(someone);
  }

  @override
  void initState() {
    super.initState();
    _apiSearchUsers("");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Search", style: TextStyle(fontSize: 25, fontFamily: "Billabong", color: Colors.black),),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [

                // #searchuser
                Container(
                  height: 45,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: (input) {
                      print(input);
                      _apiSearchUsers(input);
                    },
                    style: TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15.0),
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.grey,),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return _itemOfUser(items[index]);
                    },
                  ),
                )
              ],
            ),
          ),

          isLoading ? Center(child: CircularProgressIndicator()) : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _itemOfUser(User user) {
    return Container(
      height: 90,
      child: Row(
        children: [

          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 1.5, color: Color.fromRGBO(193, 53, 132, 1),),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.5),
              child: user.img_url.isEmpty ? Image(
                image: AssetImage("assets/images/ic_person.webp"),
                height: 45,
                width: 45,
                fit: BoxFit.cover,
              ) : Image(
                image: NetworkImage(user.img_url),
                height: 45,
                width: 45,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(width: 15,),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.fullname, style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 3,),
              Text(user.email, style: TextStyle(color: Colors.black54),),
            ],
          ),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: (){
                    if(user.followed){
                      _apiUnFollowUser(user);
                    }else{
                      _apiFollowUser(user);
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Center(
                      child: user.followed ? Text("Following") : Text("Follow"),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
