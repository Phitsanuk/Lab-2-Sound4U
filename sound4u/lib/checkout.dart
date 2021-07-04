import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sound4u/delivery.dart';
import 'package:sound4u/pay.dart';
import 'package:sound4u/paydetail.dart';
import 'map.dart';

class CheckOut extends StatefulWidget {
  final String email;
  final double amount;

  const CheckOut({Key key, this.email, this.amount}) : super(key: key);

  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  String name = "Click to set";
  TextEditingController nameController = new TextEditingController();
  TextEditingController _userlocctrl = new TextEditingController();
  String address = "";
  double screenHeight, screenWidth;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();

    _loadPref();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Checkout'),
        centerTitle: true,
        backgroundColor: Colors.amber[600],
      ),
      body: Column(
        children: [
          SizedBox(height: 5),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          Expanded(
            flex: 7,
            child: ListView(
              padding: EdgeInsets.only(top: 0),
              children: [
                Container(
                  margin: EdgeInsets.all(2),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "CUSTOMER DETAILS",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(flex: 3, child: Text("Email:")),
                            Container(
                                height: 20,
                                child: VerticalDivider(color: Colors.grey)),
                            Expanded(
                              flex: 7,
                              child: Text(widget.email),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: Text("Name:")),
                            Container(
                                height: 20,
                                child: VerticalDivider(color: Colors.grey)),
                            Expanded(
                              flex: 7,
                              child: GestureDetector(
                                  onTap: () => {nameDialog()},
                                  child: Text(name)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 2,
                ),
                Container(
                  margin: EdgeInsets.all(2),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                    child: Column(
                      children: [
                        Text(
                          "DELIVERY ADDRESS",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                                flex: 6,
                                child: Column(
                                  children: [
                                    TextField(
                                      controller: _userlocctrl,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: 'Search/Enter address'),
                                      keyboardType: TextInputType.multiline,
                                      minLines: 4,
                                      maxLines: 4,
                                    ),
                                  ],
                                )),
                            Container(
                                height: 120,
                                child: VerticalDivider(color: Colors.grey)),
                            Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 150,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          Delivery _del =
                                              await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => Map(),
                                            ),
                                          );
                                          print(address);
                                          setState(() {
                                            _userlocctrl.text = _del.address;
                                          });
                                        },
                                        child: Text("Map"),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  height: 2,
                ),
                SizedBox(height: 10),
                Container(
                    child: Column(
                  children: [
                    Text(
                      "amount amount PAYABLE",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "RM " + widget.amount.toStringAsFixed(2),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                    Container(
                      width: screenWidth / 2.5,
                      child: ElevatedButton(
                        onPressed: () {
                          _paynowDialog();
                        },
                        child: Text("PAY NOW"),
                      ),
                    )
                  ],
                ))
              ],
            ),
          )
        ],
      ),
    );
  }

  void nameDialog() {
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Your Name?',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  TextField(
                    controller: nameController,
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Enter Name'),
                    keyboardType: TextInputType.name,
                  ),
                  TextButton(
                    child: Text("Ok"),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      name = nameController.text;
                      prefs = await SharedPreferences.getInstance();
                      await prefs.setString("name", name);
                      setState(() {});
                    },
                  ),
                ]),
        context: context);
  }

  Future<void> _loadPref() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString("name") ?? 'Click to set';

    setState(() {});
  }

  void _paynowDialog() {
    showDialog(
        builder: (context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                title: new Text(
                  'Pay RM ' + widget.amount.toStringAsFixed(2) + "?",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("Yes"),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      Detail detail = new Detail(
                          widget.email, name, widget.amount.toString());
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Pay(detail: detail),
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
