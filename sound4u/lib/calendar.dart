import 'package:flutter/material.dart';
import 'package:sound4u/useratr.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Calendar extends StatefulWidget {
  final User userattr;

  const Calendar({Key key, this.userattr}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  double screenHeight, screenWidth;
  List itemList = [];
  String itemcenter = " ";
  String title;
  String email = "";

  TextEditingController _searchCtrl = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItem(_searchCtrl.text);
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
                                Text("Booked Date: " +
                                    itemList[index]['datebooked']),
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
    http.post(
        Uri.parse("http://crimsonwebs.com/s274004/sound4u/php/booked.php"),
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
}
