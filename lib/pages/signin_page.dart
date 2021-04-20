import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instaclone/pages/home_page.dart';
import 'package:flutter_instaclone/pages/signup_page.dart';
import 'package:flutter_instaclone/services/auth_service.dart';
import 'package:flutter_instaclone/services/prefs_service.dart';
import 'package:flutter_instaclone/services/util_service.dart';

class SignInPage extends StatefulWidget {
  static final String id = "signin_page";

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var isLoading = false;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  _doSignIn() {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if(email.isEmpty || password.isEmpty) return;

    setState(() {
      isLoading = true;
    });
    AuthService.signInUser(context, email, password).then((value) => {
      _getFirebaseUser(value),
    });
  }

  _getFirebaseUser(Map<String, FirebaseUser> map) async {
    if(this.mounted){
      setState(() {
        isLoading = false;
      });
    }

    FirebaseUser firebaseUser;

    if(!map.containsKey('SUCCESS')) {
      if(map.containsKey('ERROR'))
        Utils.fireToast("Check email or password");
      return;
    }

    firebaseUser = map["SUCCESS"];
    if(firebaseUser == null) return;

    await Prefs.saveUserId(firebaseUser.uid);
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  _callSignUpPage() {
    Navigator.pushReplacementNamed(context, SignUpPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(193, 53, 132, 1),
                  Color.fromRGBO(131, 58, 180, 1),
                ]),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        // #instagram
                        Text(
                          "Instagram",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontFamily: "Billabong"),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        // #email
                        Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white54.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(7),
                              ),
                          child: TextField(
                            controller: emailController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: Colors.white54, fontSize: 17),
                              hintText: "Email",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        // #password
                        Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(7),
                              ),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: Colors.white54, fontSize: 17),
                              hintText: "Password",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        // #signin
                        GestureDetector(
                          onTap: _doSignIn,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white54.withOpacity(0.2), width: 2),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Center(
                              child: Text(
                                "Sign In",
                                style: TextStyle(color: Colors.white, fontSize: 17),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // #go to sign up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: _callSignUpPage,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),

              isLoading ?
              Center(
                child: CircularProgressIndicator(),
              ): SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
