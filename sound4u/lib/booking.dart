import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sound4u/useratr.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Booking extends StatefulWidget {
  final User userattr;

  const Booking({Key key, this.userattr}) : super(key: key);
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  double screenHeight, screenWidth;
  List itemList = [];
  String itemcenter = " ";
  String title;
  String email = "";
  int cartitem = 0;

  @override
  void initState() {
    super.initState();
    _loadItem(" ");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Your Booking List'),
          centerTitle: true,
          backgroundColor: Colors.amber[600],
        ),
        body: Center(
          child: Container(
            child: Column(
              children: [
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

  void _loadItem(String items) {
    http.post(
        Uri.parse("http://crimsonwebs.com/s274004/sound4u/php/booked.php"),
        body: {
          "items": items,
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
}
