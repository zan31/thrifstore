import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:thrifstore/screens/home/detail.dart';
import 'package:thrifstore/screens/home/home.dart';
import 'package:thrifstore/screens/home/mydetail.dart';
import 'package:thrifstore/screens/home/newpost.dart';
import 'package:thrifstore/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:thrifstore/shared/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyPosts extends StatefulWidget {
  MyPosts({Key? key, required this.userid}) : super(key: key);
  String userid;

  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  late String userid;
  final AuthService _auth = AuthService();
  late Stream<QuerySnapshot> _postsStream;
  @override
  void initState() {
    userid = widget.userid;
    _postsStream = FirebaseFirestore.instance
        .collection('posts')
        .where("user_id", isEqualTo: userid)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _postsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Loading();
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        return Scaffold(
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
                            color: Color.fromRGBO(0, 0, 0, 0.65), fontSize: 15),
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
                      leading: const Icon(
                        LineAwesomeIcons.plus_circle,
                        size: 35,
                      ),
                      title: const Text(
                        'New post',
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.65), fontSize: 15),
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
                      tileColor: Color.fromRGBO(171, 255, 184, 1.0),
                      leading: const Icon(
                        LineAwesomeIcons.folder,
                        color: Color.fromRGBO(133, 96, 185, 1.0),
                        size: 35,
                      ),
                      title: const Text(
                        'My posts',
                        style: TextStyle(
                            color: Color.fromRGBO(133, 96, 185, 1.0),
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
            iconTheme: IconThemeData(color: Color.fromRGBO(171, 255, 184, 1.0)),
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
          body: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return Card(
                color: const Color(0xFFF6E6FF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                        color: Theme.of(context).primaryColor, width: 1.2)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 10.0, left: 6.0, right: 6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: Image(
                            image: FirebaseImage(
                              'gs://thrifstore-843c3.appspot.com/uploads/' +
                                  data['imgurl'],
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        trailing: const Icon(
                          LineAwesomeIcons.angle_right,
                        ),
                        title: Text(
                          data['title'],
                          style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.67059)),
                        ),
                        subtitle: Text(
                          data['price'].toString() + ' €',
                          style: const TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.49411)),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyDetail(
                                        postid: data['docId'],
                                        categoryid: data['category_id'],
                                        userid: userid,
                                      )));
                        },
                      ),
                    ],
                  ),
                ));
          }).toList()),
        );
      },
    );
  }
}
