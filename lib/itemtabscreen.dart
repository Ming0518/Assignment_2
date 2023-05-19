import 'package:flutter/material.dart';
import 'package:barterlt/user.dart';

class ItemTabScreen extends StatefulWidget {
  final User user;
  const ItemTabScreen({super.key, required this.user});

  @override
  State<ItemTabScreen> createState() => _ItemTabScreenState();
}

class _ItemTabScreenState extends State<ItemTabScreen> {
  String maintitle = "Item listing";

  @override
  void initState() {
    super.initState();
    print("Item listing");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.user.email.toString()),
    );
  }
}
