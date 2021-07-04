import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'home.dart';
import 'registration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'useratr.dart';

class Login extends StatefulWidget {
  final User userattr;

  const Login({Key key, this.userattr}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  bool _rmbMe = false;
  TextEditingController userController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  SharedPreferences shrPref;

  @override
  void initState() {
    ldPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var materialButton = MaterialButton(
      minWidth: 100,
      height: 30,
      color: Colors.amberAccent[700],
      child: Text('Login', style: TextStyle(fontSize: 20, color: Colors.white)),
      onPressed: _onLogin,
    );
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.amber[50],
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/images/sound4u.png', scale: 1),
                Text('Please Login to Enjoy the Full Features',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.brown[900],
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.amber),
                      color: Colors.amber[200],
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                          controller: userController,
                          decoration: InputDecoration(
                            labelText: 'User Name',
                            icon: Icon(Icons.person_outline_sharp),
                          ),
                        ),
                        TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              icon: Icon(Icons.mail_outline_sharp),
                            )),
                        TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              icon: Icon(Icons.lock_outline_sharp)),
                          obscureText: true,
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Checkbox(
                                value: _rmbMe,
                                onChanged: (bool value) {
                                  _onChanged(value);
                                }),
                            Text('Remember Me'),
                          ],
                        ),
                        Material(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 18,
                          color: Colors.amber[900],
                          clipBehavior: Clip.antiAlias,
                          child: materialButton,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  child: Text('Register New Account',
                      style: TextStyle(fontSize: 15)),
                  onTap: _rgtNewUser,
                ),
                SizedBox(height: 5),
                GestureDetector(
                  child:
                      Text('Forgot Password', style: TextStyle(fontSize: 15)),
                  onTap: _fgtPasswrd,
                ),
              ],
            ),
          ),
        ),
      ),
      builder: EasyLoading.init(),
    );
  }

  void _onLogin() {
    String user = userController.text.toString();
    String email = emailController.text.toString();
    String password = passwordController.text.toString();

    http.post(Uri.parse("http://crimsonwebs.com/s274004/sound4u/php/login.php"),
        body: {
          "user": user,
          "email": email,
          "password": password
        }).then((response) {
      print(response.body);
      if (user.isEmpty || email.isEmpty || password.isEmpty) {
        EasyLoading.showError('Forget Something?');
      } else if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Great you're in",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.blueAccent[700],
            textColor: Colors.white,
            fontSize: 16.0);
        User name = User(
          email: email,
          password: password,
        );
        Navigator.push(context,
            MaterialPageRoute(builder: (content) => Home(userattr: name)));
      } else {
        EasyLoading.showError(
            'Login fail! Make sure your email and password is correct');
      }
    });
  }

  void _onChanged(bool value) {
    String user = userController.text.toString();
    String email = emailController.text.toString();
    String password = passwordController.text.toString();

    if (user.isEmpty || email.isEmpty || password.isEmpty) {
      EasyLoading.showError('Forget Something?');
      return;
    }
    setState(() {
      _rmbMe = value;
      strPref(value, user, email, password);
    });
  }

  void _rgtNewUser() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => Registration()));
  }

  void _fgtPasswrd() {
    TextEditingController rcvEmail = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Forgot Your Password?"),
            content: new Container(
                height: 70,
                child: Column(
                  children: [
                    Text("Enter Your Email"),
                    TextField(
                      controller: rcvEmail,
                      decoration: InputDecoration(
                        icon: Icon(Icons.mail_outline_sharp),
                      ),
                    )
                  ],
                )),
            actions: [
              TextButton(
                  onPressed: () {
                    print(rcvEmail.text);
                    resetPassword(rcvEmail.text);
                    Navigator.of(context).pop();
                  },
                  child: Text("Confirm")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"))
            ],
          );
        });
  }

  Future<void> strPref(
      bool value, String user, String email, String password) async {
    shrPref = await SharedPreferences.getInstance();
    if (value) {
      await shrPref.setString('user', user);
      await shrPref.setString('email', email);
      await shrPref.setString('password', password);
      await shrPref.setBool('remember', value);
      EasyLoading.showSuccess(
          'Lazy? We already save your info for fast login.');
      return;
    } else {
      await shrPref.setString('user', '');
      await shrPref.setString('email', '');
      await shrPref.setString('password', '');
      await shrPref.setBool('remember', value);
      EasyLoading.showError('Blank space would not be remember.');

      setState(() {
        userController.text = '';
        emailController.text = '';
        passwordController.text = '';
        _rmbMe = false;
      });
      return;
    }
  }

  Future<void> ldPref() async {
    shrPref = await SharedPreferences.getInstance();
    String user = shrPref.getString("user") ?? '';
    String email = shrPref.getString("email") ?? '';
    String password = shrPref.getString("password") ?? '';
    _rmbMe = shrPref.getBool("remember") ?? false;

    setState(() {
      userController.text = user;
      emailController.text = email;
      passwordController.text = password;
    });
  }

  void resetPassword(String rstPassword) {
    http.post(Uri.parse("http://crimsonwebs.com/s274004/sound4u/php/reset.php"),
        body: {
          "email": rstPassword,
        }).then((response) {
      print(response.body);
      if (rstPassword.isEmpty) {
        EasyLoading.showError('Forget Something?');
      } else if (response.body == "success") {
        EasyLoading.showSuccess('Reset Password Success!');
      } else {
        EasyLoading.showError('Make sure your email is correct');
      }
    });
  }
}
