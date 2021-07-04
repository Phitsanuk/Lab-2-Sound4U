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
  String items = "";
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
            IconButton(
              onPressed: () => {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Calendar(userattr: widget.userattr),
                ))
              },
              icon: Icon(
                Icons.calendar_today,
                color: Colors.white,
              ),
            ),
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
                                Text("Size: " + itemList[index]['size']),
                                SizedBox(height: 5),
                                Text("Number of Speakers: " +
                                    itemList[index]['numspeaker']),
                                SizedBox(height: 5),
                                Text("DJ: " + itemList[index]['dj']),
                                SizedBox(height: 5),
                                Text(
                                  "Price Per Hour: RM" +
                                      (double.parse(itemList[index]['price']))
                                          .toStringAsFixed(2),
                                ),
                                SizedBox(height: 10),
                                Container(
                                    child: ElevatedButton(
                                  onPressed: () {
                                    _addbooking(index);
                                  },
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

  _addbooking(int index) async {
    String id = itemList[index]['id'];
    String items = itemList[index]['items'];
    String size = itemList[index]['size'];
    String numspeaker = itemList[index]['numspeaker'];
    String dj = itemList[index]['dj'];

    String price = itemList[index]['price'];

    http.post(
        Uri.parse("http://crimsonwebs.com/s274004/sound4u/php/additem.php"),
        body: {
          "email": email,
          "id": id,
          "items": items,
          "size": size,
          "numspeaker": numspeaker,
          "dj": dj,
          "price": price
        }).then((response) {
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

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Booking(userattr: widget.userattr),
        ));
      }
    });
  }
}
