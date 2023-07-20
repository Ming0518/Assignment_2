import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:barterlt/user.dart';
import 'package:http/http.dart' as http;
import 'package:barterlt/myconfig.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  final Function(User) onUpdateProfile;

  const EditProfileScreen(
      {Key? key, required this.user, required this.onUpdateProfile})
      : super(key: key);

  @override
  State<EditProfileScreen> createState() => _MessageTabScreenState();
}

class _MessageTabScreenState extends State<EditProfileScreen> {
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameEditingController.text = widget.user.name.toString();
    _phoneEditingController.text = widget.user.phone.toString();
    _passwordEditingController.text = "";
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Edit Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty || (val.length < 3)
                            ? "Name must be longer than 3"
                            : null,
                        onFieldSubmitted: (v) {},
                        controller: _nameEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  validator: (val) =>
                      val!.isEmpty ? "Phone must be longer than 10" : null,
                  onFieldSubmitted: (v) {},
                  controller: _phoneEditingController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    alignLabelWithHint: true,
                    labelStyle: TextStyle(),
                    icon: Icon(
                      Icons.phone,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: screenWidth / 1.2,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      udpateDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    child: const Text("Update Profile"),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 5,
                      child: TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) =>
                            val!.isEmpty ? "Password must contain value" : null,
                        onFieldSubmitted: (v) {},
                        obscureText: true,
                        controller: _passwordEditingController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'New Password',
                          labelStyle: TextStyle(),
                          icon: Icon(Icons.lock),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 2.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: screenWidth / 1.2,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      udpatePass();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                    child: const Text("Change Password"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void udpateDialog() {
    String name = _nameEditingController.text;
    String phone = _phoneEditingController.text;
    //String password = _passwordEditingController.text;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Are you sure you want to update your profile?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                performProfileUpdate(name, phone);
              },
              child: const Text("Update", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void performProfileUpdate(String name, String phone) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/update_profile.php"),
        body: {
          "id": widget.user.id,
          "name": name,
          "phone": phone,
          //"password": password,
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Success")));

          User updatedUser = User(
            id: widget.user.id,
            name: name,
            phone: phone,
            // password: password,
          );

          widget.onUpdateProfile(updatedUser);

          Navigator.pop(
              context, updatedUser); // Pass the updated user as the result
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed")));
        Navigator.pop(context);
      }
    });
  }

  void udpatePass() {
    String password = _passwordEditingController.text;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Are you sure you want to update your password?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                performPassUpdate(password);
              },
              child: const Text("Update", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void performPassUpdate(String password) {
    String name = _nameEditingController.text;
    String phone = _phoneEditingController.text;
    http.post(Uri.parse("${MyConfig().SERVER}/barterlt/php/update_pass.php"),
        body: {
          "id": widget.user.id,
          "password": password,
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Success")));

          User updatedUser = User(
            id: widget.user.id,
            name: name,
            phone: phone,
          );

          widget.onUpdateProfile(updatedUser);

          Navigator.pop(
              context, updatedUser); // Pass the updated user as the result
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Update Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Update Failed")));
        Navigator.pop(context);
      }
    });
  }
}
