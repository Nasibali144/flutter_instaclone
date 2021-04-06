import 'package:flutter/material.dart';
import 'package:flutter_instaclone/models/user_model.dart';

class MySearchPage extends StatefulWidget {
  @override
  _MySearchPageState createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  var searchController = TextEditingController();
  List<User> users = new List();


  @override
  void initState() {
    super.initState();
    users.add(User(fullname: "Nasibali", email: "abdiyevnasibali@gmail.com"));
    users.add(User(fullname: "Nasibali", email: "abdiyevnasibali@gmail.com"));
    users.add(User(fullname: "Nasibali", email: "abdiyevnasibali@gmail.com"));
    users.add(User(fullname: "Nasibali", email: "abdiyevnasibali@gmail.com"));
    users.add(User(fullname: "Nasibali", email: "abdiyevnasibali@gmail.com"));
    users.add(User(fullname: "Nasibali", email: "abdiyevnasibali@gmail.com"));
    users.add(User(fullname: "Nasibali", email: "abdiyevnasibali@gmail.com"));
    users.add(User(fullname: "Nasibali", email: "abdiyevnasibali@gmail.com"));
    users.add(User(fullname: "Nasibali", email: "abdiyevnasibali@gmail.com"));
    users.add(User(fullname: "Nasibali", email: "abdiyevnasibali@gmail.com"));
    users.add(User(fullname: "Nasibali", email: "abdiyevnasibali@gmail.com"));
    users.add(User(fullname: "Nasibali", email: "abdiyevnasibali@gmail.com"));
    users.add(User(fullname: "Nasibali", email: "abdiyevnasibali@gmail.com"));
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
      body: Container(
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
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return _itemOfUser(users[index]);
                },
              ),
            )
          ],
        ),
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
              child: Image(
                image: AssetImage("assets/images/ic_person.webp"),
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
                Container(
                  height: 30,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Center(
                    child: Text("Follow"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
