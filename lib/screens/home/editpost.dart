import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:thrifstore/services/auth.dart';
import 'package:thrifstore/services/database.dart';
import 'package:thrifstore/services/storage.dart';
import 'package:thrifstore/shared/loading.dart';
import 'package:path/path.dart' as Path;

class EditPost extends StatefulWidget {
  EditPost(
      {Key? key,
      required this.postid,
      required this.userid,
      required this.category,
      required this.title,
      required this.desc,
      required this.price})
      : super(key: key);
  String postid;
  String userid;
  String category;
  String title;
  String desc;
  double price;

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  late TextEditingController titlec;
  late TextEditingController pricec;
  late TextEditingController descc;
  final AuthService _auth = AuthService();
  UploadTask? task;
  File? file;
  final _formkey = GlobalKey<FormState>();
  late String title;
  late double price;
  late String desc;
  late String category;
  bool loading = false;
  String selectedValue = '1';
  final List<String> categoryItems = [
    'Vehicles',
    'Sports',
    'Furniture',
    'Home appliances',
    'Technology'
  ];
  late String postid;
  late String userid;
  @override
  void initState() {
    postid = widget.postid;
    userid = widget.userid;
    title = widget.title;
    price = widget.price;
    desc = widget.desc;
    category = widget.category;
    titlec = TextEditingController(text: title);
    pricec = TextEditingController(text: price.toString());
    descc = TextEditingController(text: desc);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(postid)
            .snapshots(includeMetadataChanges: true),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Loading();
          }
          if (snapshot.hasData) {
            var doc = snapshot.data!.data();
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
                      "Oops, something went wrong!",
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

            Future selectFile() async {
              final result = await FilePicker.platform
                  .pickFiles(allowMultiple: false, type: FileType.image);

              if (result == null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupDialognew(context),
                );
              } else {
                final path = result.files.single.path!;
                setState(() => file = File(path));
              }
            }

            Future uploadFile() async {
              if (selectedValue == '1') {
                selectedValue = category;
              }
              if (file == null) {
                DatabaseService(uid: userid).updatePost(
                    titlec.text,
                    double.parse(pricec.text),
                    descc.text,
                    doc!['imgurl'],
                    selectedValue,
                    postid);
              } else {
                final fileName = Path.basename(file!.path);
                final destination = 'uploads/$fileName';

                task = StorageFirebase.uploadFile(destination, file!);

                DatabaseService(uid: userid).updatePost(
                    title, price, desc, fileName, selectedValue, postid);
                setState(() {});
                if (task == null) return;
              }
            }

            final fileName =
                file != null ? Path.basename(file!.path) : doc!['imgurl'];

            return loading
                ? const Loading()
                : Scaffold(
                    appBar: AppBar(
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                      iconTheme: const IconThemeData(
                          color: Color.fromRGBO(171, 255, 184, 1.0)),
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
                                  height:
                                      MediaQuery.of(context).size.height / 6,
                                  child: const FittedBox(
                                    child: Icon(
                                      LineAwesomeIcons.upload,
                                      color: Color.fromRGBO(133, 96, 185, 1.0),
                                    ),
                                  )),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Update your post!",
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
                                            controller: titlec,
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                                labelText: 'Title',
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.auto,
                                                floatingLabelStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            validator: (val) => val!.isEmpty
                                                ? 'Enter the product title'
                                                : null,
                                          ),
                                          const SizedBox(height: 10.0),
                                          TextFormField(
                                            controller: pricec,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
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
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            validator: (val) => val!.isEmpty
                                                ? 'Enter the product price'
                                                : null,
                                          ),
                                          const SizedBox(height: 10.0),
                                          TextFormField(
                                            controller: descc,
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                                labelText: 'Description',
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.auto,
                                                floatingLabelStyle: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            validator: (val) => val!.isEmpty
                                                ? 'Enter the post description'
                                                : null,
                                          ),
                                          const SizedBox(height: 10.0),
                                          DropdownButtonFormField2(
                                            value: doc!['category_id'],
                                            decoration: InputDecoration(
                                              //Add isDense true and zero Padding.
                                              //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
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
                                            buttonPadding:
                                                const EdgeInsets.only(
                                                    left: 20, right: 10),
                                            dropdownDecoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            items: categoryItems
                                                .map((item) =>
                                                    DropdownMenuItem<String>(
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
                                                selectedValue =
                                                    value.toString();
                                              });
                                            },
                                            onSaved: (value) {
                                              setState(() {
                                                selectedValue =
                                                    value.toString();
                                              });
                                            },
                                          ),
                                        ],
                                      )),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
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
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: const Text(
                                        "Attach image",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.75)),
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
                                    padding:
                                        const EdgeInsets.only(top: 3, left: 3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: MaterialButton(
                                      minWidth: double.infinity,
                                      height: 50,
                                      onPressed: () {
                                        if (_formkey.currentState!.validate()) {
                                          uploadFile();
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      color: Theme.of(context).primaryColor,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(40)),
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

          return const Loading();
        });
  }
}
