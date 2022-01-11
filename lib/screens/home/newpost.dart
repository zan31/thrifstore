import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:thrifstore/screens/home/home.dart';
import 'package:thrifstore/screens/home/myposts.dart';
import 'package:thrifstore/services/auth.dart';
import 'package:thrifstore/services/storage.dart';
import 'package:thrifstore/services/database.dart';
import 'package:thrifstore/shared/loading.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key, required this.userid}) : super(key: key);
  final String userid;

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  late String userid;
  UploadTask? task;
  File? file;
  final _formkey = GlobalKey<FormState>();
  String title = '';
  double price = 0.0;
  String desc = '';
  bool loading = false;
  final AuthService _auth = AuthService();
  String selectedValue = '';
  final List<String> categoryItems = [
    'Vehicles',
    'Sports',
    'Furniture',
    'Home appliances',
    'Technology'
  ];

  @override
  void initState() {
    selectedValue = '1';
    userid = widget.userid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? Path.basename(file!.path) : ' ';
    return loading
        ? const Loading()
        : Scaffold(
            drawer: SafeArea(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12.0), bottom: Radius.circular(12.0)),
                child: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      const DrawerHeader(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.only(bottom: 0),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(171, 255, 184, 1.0),
                            image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: AssetImage('assets/alt_logo.png'))),
                        child: null,
                      ),
                      ListTile(
                        leading: const Icon(
                          LineAwesomeIcons.home,
                          size: 35,
                        ),
                        title: const Text(
                          'Home',
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.65),
                              fontSize: 15),
                        ),
                        onTap: () => {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home(
                                  userid: userid,
                                ),
                              ))
                        },
                      ),
                      ListTile(
                        tileColor: Color.fromRGBO(171, 255, 184, 1.0),
                        leading: const Icon(
                          LineAwesomeIcons.plus_circle,
                          color: Color.fromRGBO(133, 96, 185, 1.0),
                          size: 35,
                        ),
                        title: const Text(
                          'New post',
                          style: TextStyle(
                              color: Color.fromRGBO(133, 96, 185, 1.0),
                              fontSize: 15),
                        ),
                        onTap: () => {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewPost(userid: userid),
                              ))
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          LineAwesomeIcons.folder,
                          size: 35,
                        ),
                        title: const Text(
                          'My posts',
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.65),
                              fontSize: 15),
                        ),
                        onTap: () => {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyPosts(
                                  userid: userid,
                                ),
                              ))
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            appBar: AppBar(
              shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              )),
              iconTheme:
                  IconThemeData(color: Color.fromRGBO(171, 255, 184, 1.0)),
              backgroundColor: const Color.fromRGBO(133, 96, 185, 1.0),
              elevation: 0.0,
              title: Image.asset(
                'assets/logomint.png',
                height: 40,
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () async {
                    await _auth.logOut();
                  },
                  icon: const Icon(
                    LineAwesomeIcons.alternate_sign_out,
                    color: Color.fromRGBO(171, 255, 184, 1.0),
                  ),
                  tooltip: 'Logout',
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height / 6,
                          child: const FittedBox(
                            child: Icon(
                              LineAwesomeIcons.plus_circle,
                              color: Color.fromRGBO(133, 96, 185, 1.0),
                            ),
                          )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Create a new post!",
                            style: TextStyle(
                              fontSize: 25,
                              color: Color.fromRGBO(133, 96, 185, 1.0),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Form(
                              key: _formkey,
                              child: Column(
                                children: [
                                  TextFormField(
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                          labelText: 'Title',
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          floatingLabelStyle: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      validator: (val) => val!.isEmpty
                                          ? 'Enter the product title'
                                          : null,
                                      onChanged: (val) {
                                        setState(() {
                                          title = val;
                                        });
                                      }),
                                  const SizedBox(height: 10.0),
                                  TextFormField(
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r'[,]')),
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9.]')),
                                      ],
                                      decoration: const InputDecoration(
                                          labelText: 'Price',
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          floatingLabelStyle: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      validator: (val) => val!.isEmpty
                                          ? 'Enter the product price'
                                          : null,
                                      onChanged: (val) {
                                        setState(() {
                                          price = double.parse(val);
                                        });
                                      }),
                                  const SizedBox(height: 10.0),
                                  TextFormField(
                                      keyboardType: TextInputType.text,
                                      decoration: const InputDecoration(
                                          labelText: 'Description',
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          floatingLabelStyle: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      validator: (val) => val!.isEmpty
                                          ? 'Enter the post description'
                                          : null,
                                      onChanged: (val) {
                                        setState(() {
                                          desc = val;
                                        });
                                      }),
                                  const SizedBox(height: 10.0),
                                  DropdownButtonFormField2(
                                    decoration: InputDecoration(
                                      //Add isDense true and zero Padding.
                                      //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      //Add more decoration as you want here
                                      //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                    ),
                                    isExpanded: true,
                                    hint: const Text(
                                      'Select a category',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black45,
                                    ),
                                    iconSize: 30,
                                    buttonHeight: 60,
                                    buttonPadding: const EdgeInsets.only(
                                        left: 20, right: 10),
                                    dropdownDecoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    items: categoryItems
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Please select a category.';
                                      }
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValue = value.toString();
                                      });
                                    },
                                    onSaved: (value) {
                                      setState(() {
                                        selectedValue = value.toString();
                                      });
                                    },
                                  ),
                                ],
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 30,
                              onPressed: () {
                                selectFile();
                              },
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Text(
                                "Attach image",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromRGBO(0, 0, 0, 0.75)),
                              ),
                            ),
                          ),
                          Text(
                            fileName,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromRGBO(0, 0, 0, 0.55)),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 3, left: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              height: 50,
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                  uploadFile();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyPosts(
                                          userid: userid,
                                        ),
                                      ));
                                }
                              },
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                  borderRadius: BorderRadius.circular(40)),
                              child: const Text(
                                "Create",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  Future selectFile() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (result == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialognew(context),
      );
    } else {
      final path = result.files.single.path!;
      setState(() => file = File(path));
    }
  }

  Future uploadFile() async {
    if (file == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildPopupDialognew(context),
      );
    } else {
      final fileName = Path.basename(file!.path);
      final destination = 'uploads/$fileName';

      task = StorageFirebase.uploadFile(destination, file!);

      DatabaseService(uid: userid)
          .insertPost(title, price, desc, fileName, selectedValue);
      setState(() {});
      if (task == null) return;
    }
  }

  Widget _buildPopupDialognew(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(248, 215, 218, 1.0),
      title: const Icon(LineAwesomeIcons.exclamation_circle,
          color: Color.fromRGBO(132, 32, 41, 1.0), size: 40),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            "Oops, something went wrong or you didnt't add an image!",
            style: TextStyle(
              color: Color.fromRGBO(132, 32, 41, 1.0),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Close',
            style: TextStyle(color: Color.fromRGBO(132, 32, 41, 1.0)),
          ),
        ),
      ],
    );
  }
}
