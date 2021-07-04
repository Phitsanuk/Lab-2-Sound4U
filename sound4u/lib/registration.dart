import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool _isHidden = true;
  bool _eula = false;
  TextEditingController userController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordControllera = new TextEditingController();
  TextEditingController passwordControllerb = new TextEditingController();
  @override
  Widget build(BuildContext context) {
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
                Text('Please Register to Enjoy the Full Features',
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
                              labelText: 'User Name', icon: Icon(Icons.person)),
                        ),
                        TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              icon: Icon(Icons.mail_outline_sharp),
                            )),
                        TextField(
                          controller: passwordControllera,
                          decoration: InputDecoration(
                              labelText: 'Password',
                              suffix: InkWell(
                                onTap: _togglePasswordView,
                                child: Icon(
                                  _isHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                              icon: Icon(Icons.lock_open_outlined)),
                          obscureText: _isHidden,
                        ),
                        TextField(
                          controller: passwordControllerb,
                          decoration: InputDecoration(
                              labelText: 'Retype Password',
                              suffix: InkWell(
                                onTap: _togglePasswordView,
                                child: Icon(
                                  _isHidden
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                              icon: Icon(Icons.lock_outline_sharp)),
                          obscureText: _isHidden,
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Checkbox(
                                value: _eula,
                                onChanged: (bool value) {
                                  _onEULA(value);
                                }),
                            Text('Licenses and Agreements'),
                          ],
                        ),
                        Material(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 18,
                          color: Colors.amberAccent[700],
                          clipBehavior: Clip.antiAlias,
                          child: MaterialButton(
                            minWidth: 100,
                            height: 30,
                            color: Colors.amber[900],
                            child: Text('Register',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                            onPressed: _onRgt,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
                GestureDetector(
                  child: Text('Login', style: TextStyle(fontSize: 15)),
                  onTap: _userLgn,
                ),
              ],
            ),
          ),
        ),
      ),
      builder: EasyLoading.init(),
    );
  }

  void _onRgt() {
    String name = userController.text.toString();
    String email = emailController.text.toString();
    String passworda = passwordControllera.text.toString();
    String passwordb = passwordControllerb.text.toString();

    if (name.isEmpty ||
        email.isEmpty ||
        passworda.isEmpty ||
        passwordb.isEmpty) {
      EasyLoading.showError('Forget Something?');
      return;
    }
    if (passwordb != passworda) {
      EasyLoading.showError('I Think You Should Recheck Your Password');
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("One More Step"),
            content: Text("Are You Sure You Want To Proceed?"),
            actions: [
              TextButton(
                  child: Text("Yes"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    rgtUsers(name, email, passworda);
                  }),
              TextButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _userLgn() {
    Navigator.push(context, MaterialPageRoute(builder: (content) => Login()));
  }

  void rgtUsers(String name, String email, String password) {
    http.post(
        Uri.parse("http://crimsonwebs.com/s274004/sound4u/php/register.php"),
        body: {
          "name": name,
          "email": email,
          "password": password
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        EasyLoading.showSuccess('Great Registration Success.');
      } else {
        EasyLoading.showError('Sorry Failed to Register');
      }
    });
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _onEULA(bool value) {
    setState(() {
      _eula = value;
    });
  }
}
