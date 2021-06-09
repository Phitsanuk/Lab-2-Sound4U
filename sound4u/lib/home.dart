import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound4u/useratr.dart';
import 'booking.dart';
import 'calendar.dart';

class Home extends StatefulWidget {
  final User userattr;

  const Home({Key key, this.userattr}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double screenHeight, screenWidth;
  List itemList = [];
  String itemcenter = " ";
  String title;
  String email = "";
  int cartitem = 0;
  SharedPreferences prefs;

  TextEditingController _searchCtrl = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPref();
    /*_load();*/
    _loadItem(_searchCtrl.text);
    _searchItem(_searchCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Booking List'),
          centerTitle: true,
          backgroundColor: Colors.amber[600],
          actions: [
            TextButton.icon(
                onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            Calendar(userattr: widget.userattr),
                      ))
                    },
                icon: Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                ),
                label: Text(
                  cartitem.toString(),
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
        body: Center(
          child: Container(
            child: Column(
              children: [
                TextFormField(
                  controller: _searchCtrl,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Looking for Something?",
                    suffixIcon: IconButton(
                      onPressed: () => _searchItem(_searchCtrl.text),
                      icon: Icon(Icons.search),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.white24)),
                  ),
                ),
                itemList == null
                    ? Flexible(child: Center(child: Text(itemcenter)))
                    : Flexible(
                        child: Center(
                            child: ListView(
                                children:
                                    List.generate(itemList.length, (index) {
                        return Padding(
                          padding: EdgeInsets.all(5),
                          child: Card(
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Text(
                                  itemList[index]['items'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(itemList[index]['size']),
                                SizedBox(height: 5),
                                Text("Number of Speakers: " +
                                    itemList[index]['numspeaker']),
                                SizedBox(height: 5),
                                Text("DJ: " + itemList[index]['dj']),
                                SizedBox(height: 5),
                                Text(
                                  "Price:" +
                                      (double.parse(itemList[index]['price']))
                                          .toStringAsFixed(2),
                                ),
                                SizedBox(height: 10),
                                Container(
                                    child: ElevatedButton(
                                  onPressed: () {},
                                  child: Text("Booking"),
                                )),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        );
                      })))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loadItem(String text) {
    http.post(Uri.parse("http://crimsonwebs.com/s274004/sound4u/php/load.php"),
        body: {
          "items": text,
        }).then((response) {
      if (response.body == "failed") {
        itemcenter = "No items.";
        return;
      } else {
        var jsondata = json.decode(response.body);
        itemList = jsondata["Item"];
      }
      setState(() {});
    });
  }

  Future<void> _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    email = prefs.getString("email") ?? '';
    print(email);
    if (email == '') {
      /*_loademaildialog();*/
    } else {}
  }

  void _searchItem(String text) {
    http.post(
        Uri.parse("http://crimsonwebs.com/s274004/sound4u/php/search.php"),
        body: {
          "items": text,
        }).then((response) {
      if (response.body == "failed") {
        itemcenter = "No items.";
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        itemList = jsondata["Item"];
      }
      setState(() {});
    });
  }

/*  _addItem(int index) async {
    if (email == '') {
      _loademaildialog();
    } else {
      await Future.delayed(Duration(seconds: 1));
      String id = itemList[index]['id'];
      http.post(
          Uri.parse("http://crimsonwebs.com/s274004/sound4u/php/additem.php"),
          body: {"email": email, "id": id}).then((response) {
        print(response.body);
        if (response.body == "failed") {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          _load();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Booking(userattr: widget.userattr),
          ));
        }
      });
    }
  }

  void _loademaildialog() {
    TextEditingController _emailController = new TextEditingController();
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: new Text(
                  'Your Email',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: Colors.white24)),
                              )),
                          ElevatedButton(
                              onPressed: () async {
                                String _email =
                                    _emailController.text.toString();
                                prefs = await SharedPreferences.getInstance();
                                await prefs.setString("email", _email);
                                email = _email;
                                Fluttertoast.showToast(
                                    msg: "Email stored",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                        Color.fromRGBO(191, 30, 46, 50),
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                Navigator.of(context).pop();
                              },
                              child: Text("Proceed"))
                        ],
                      ),
                    ),
                  ),
                ]),
        context: context);
  }

  void _load() {
    print(email);
    http.post(
        Uri.parse("http://crimsonwebs.com/s274004/sound4u/php/booked.php"),
        body: {"email": email}).then((response) {
      setState(() {
        cartitem = int.parse(response.body);
        print(cartitem);
      });
    });
  }*/
}
