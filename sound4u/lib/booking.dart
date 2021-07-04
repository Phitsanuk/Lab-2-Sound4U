import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sound4u/home.dart';
import 'package:sound4u/useratr.dart';

import 'checkout.dart';

class Booking extends StatefulWidget {
  final User userattr;
  const Booking({Key key, this.userattr}) : super(key: key);

  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  List itemList = [];
  double amount = 0.0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
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
              margin: const EdgeInsets.fromLTRB(30, 20, 30, 10),
              child: Column(
                children: [
                  itemList == null
                      ? Flexible(child: Center(child: Text("Empty")))
                      : Flexible(
                          child: Center(
                            child: ListView(
                              children: List.generate(itemList.length, (index) {
                                return Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    color: Colors.white70,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10),
                                        Text(itemList[index]['items']),
                                        SizedBox(height: 5),
                                        Text(
                                            "Size: " + itemList[index]['size']),
                                        SizedBox(height: 5),
                                        Text("Number of Speakers: " +
                                            itemList[index]['numspeaker']),
                                        SizedBox(height: 5),
                                        Text("DJ: " + itemList[index]['dj']),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.remove),
                                              onPressed: () {
                                                _modHour(index, "remove");
                                              },
                                            ),
                                            Text(itemList[index]['hour'] +
                                                " hours"),
                                            IconButton(
                                              icon: Icon(Icons.add),
                                              onPressed: () {
                                                _modHour(index, "add");
                                              },
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "RM " +
                                              (int.parse(itemList[index]
                                                          ['hour']) *
                                                      double.parse(
                                                          itemList[index]
                                                              ['price']))
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                            child: ElevatedButton(
                                          onPressed: () {
                                            _delete(index);
                                          },
                                          child: Text("Cancel"),
                                        )),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(height: 5),
                        Divider(
                          color: Colors.red,
                          height: 1,
                          thickness: 10.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _checkOut();
                          },
                          child: Text("CHECKOUT"),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  _load() {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s274004/sound4u/php/loadbooking.php"),
        body: {"email": widget.userattr.email}).then((response) {
      print(response.body);

      if (response.body == "failed") {
        Text("No item added.");
        itemList = [];
        return;
      } else {
        var jsondata = json.decode(response.body);
        print(jsondata);
        itemList = jsondata["cart"];
        amount = 0.0;
        for (int i = 0; i < itemList.length; i++) {
          amount = amount +
              int.parse(itemList[i]['hour']) *
                  double.parse(itemList[i]['price']);
        }
      }
      setState(() {});
    });
  }

  void _checkOut() {
    if (amount == 0.0) {
      Fluttertoast.showToast(
          msg: "amount not payable",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    } else {
      showDialog(
          builder: (context) => new AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  title: new Text(
                    'Proceed with checkout?',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text("Yes"),
                      onPressed: () async {
                        _toDisplay(0);
                        Navigator.of(context).pop();
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CheckOut(
                                email: widget.userattr.email, amount: amount),
                          ),
                        );
                      },
                    ),
                    TextButton(
                        child: Text("No"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ]),
          context: context);
    }
  }

  void _delete(int index) async {
    http.post(
        Uri.parse("http://crimsonwebs.com/s274004/sound4u/php/delete.php"),
        body: {
          "email": widget.userattr.email,
          "id": itemList[index]["id"],
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Booking Aborted",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        _load();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Home(userattr: widget.userattr),
        ));
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  void _modHour(int index, String s) {
    http.post(
        Uri.parse("http://crimsonwebs.com/s274004/sound4u/php/update.php"),
        body: {
          "email": widget.userattr.email,
          "op": s,
          "id": itemList[index]['id'],
          "hour": itemList[index]['hour']
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        _load();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  void _toDisplay(int index) {
    String id = itemList[index]['id'];
    String items = itemList[index]['items'];
    String size = itemList[index]['size'];
    String numspeaker = itemList[index]['numspeaker'];
    String dj = itemList[index]['dj'];

    http.post(
        Uri.parse("http://crimsonwebs.com/s274004/sound4u/php/adddisplay.php"),
        body: {
          "email": widget.userattr.email,
          "id": id,
          "items": items,
          "size": size,
          "numspeaker": numspeaker,
          "dj": dj,
        }).then((response) {
      print(response.body);
      if (response.body == "failed") {
        Fluttertoast.showToast(
            msg: "failed",
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
      }
    });
  }
}
