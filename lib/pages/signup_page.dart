import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instaclone/pages/home_page.dart';
import 'package:flutter_instaclone/pages/signin_page.dart';
import 'package:flutter_instaclone/services/auth_service.dart';
import 'package:flutter_instaclone/services/prefs_service.dart';
import 'package:flutter_instaclone/services/util_service.dart';

class SignUpPage extends StatefulWidget {
  static final String id = "signup_page";

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var isLoading = false;

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var cpasswordController = TextEditingController();

  _doSignUp(){
    String name = nameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String cpassword = cpasswordController.text.toString().trim();
    if(name.isEmpty || email.isEmpty || password.isEmpty) return;
    if(password != cpassword) {
      Utils.fireToast("Password and confirm password does not match!");
      return;
    }
    
    setState(() {
      isLoading = true;
    });
    AuthService.signUpUser(context, name, email, password).then((firebaseUser) => {
      _getFirebaseUser(firebaseUser),
    });
  }

  _getFirebaseUser(FirebaseUser firebaseUser) async {
    setState(() {
      isLoading = false;
    });
    if (firebaseUser != null) {
      await Prefs.saveUserId(firebaseUser.uid);
      Navigator.pushReplacementNamed(context, HomePage.id);
    } else {
      Utils.fireToast("Check your informations");
    }
  }

  _callSignInPage() {
    Navigator.pushReplacementNamed(context, SignInPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width,
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

                        // #fullname
                        Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white54.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(7),
                              ),
                          child: TextField(
                            controller: nameController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: Colors.white54, fontSize: 17),
                              hintText: "Fullname",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
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
                              color: Colors.white54.withOpacity(0.2),
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

                        // #cpassword
                        Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(7),
                              ),
                          child: TextField(
                            controller: cpasswordController,
                            obscureText: true,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle:
                                  TextStyle(color: Colors.white54, fontSize: 17),
                              hintText: "Confirm Password",
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        // #signup
                        GestureDetector(
                          onTap: _doSignUp,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white54.withOpacity(0.2), width: 2),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(color: Colors.white),
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
                        "Already have an account?",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: _callSignInPage,
                        child: Text(
                          "Sign In",
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
