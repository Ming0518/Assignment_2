import 'package:flutter/material.dart';
import 'package:barterlt/user.dart';
import 'cartpage.dart';
import 'orderpage.dart';

class MessageTabScreen extends StatefulWidget {
  final User user;
  const MessageTabScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MessageTabScreen> createState() => _MessageTabScreenState();
}

class _MessageTabScreenState extends State<MessageTabScreen> {
  String maintitle = "Message";

  @override
  void initState() {
    super.initState();
    print("Message");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Track", style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        color: Colors.grey.shade200,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/images/track.png',
                  width: 125,
                  height: 125,
                ),
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: widget.user.id == "na",
                child: const Text(
                  "Please log in first to view this page",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Visibility(
                visible: widget.user.id != "na",
                child: Column(
                  children: [
                    SizedBox(
                      width: 325,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BuyerCartScreen(user: widget.user),
                            ),
                          );
                        },
                        child: const Card(
                          child: ListTile(
                            leading: Icon(Icons.shopping_cart),
                            title: Text('Cart'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 325,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderScreen(user: widget.user),
                            ),
                          );
                        },
                        child: const Card(
                          child: ListTile(
                            leading: Icon(Icons.shopping_bag),
                            title: Text('Orders'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: 325,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderScreen(user: widget.user),
                            ),
                          );
                        },
                        child: const Card(
                          child: ListTile(
                            leading: Icon(Icons.handshake),
                            title: Text('Agrrement'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
