import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:thrifstore/screens/home/editpost.dart';
import 'package:thrifstore/screens/home/myposts.dart';
import 'package:thrifstore/services/database.dart';
import 'package:thrifstore/shared/loading.dart';

class MyDetail extends StatefulWidget {
  MyDetail(
      {Key? key,
      required this.postid,
      required this.categoryid,
      required this.userid})
      : super(key: key);
  String postid;
  String categoryid;
  String userid;
  @override
  _MyDetailState createState() => _MyDetailState();
}

class _MyDetailState extends State<MyDetail> {
  late String postid;
  late String category;
  late String userid;

  @override
  void initState() {
    userid = widget.userid;
    postid = widget.postid;
    category = widget.categoryid;
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
            final postCategory = Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromRGBO(171, 255, 184, 1.0)),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                doc!['price'].toString() + ' €',
                textAlign: TextAlign.center,
                style:
                    const TextStyle(color: Color.fromRGBO(171, 255, 184, 1.0)),
              ),
            );

            final topContentText = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 50.0),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FirebaseImage(
                            'gs://thrifstore-843c3.appspot.com/uploads/' +
                                doc['imgurl'],
                          ),
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8.0)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  doc['title'],
                  style: const TextStyle(
                      color: Color.fromRGBO(254, 255, 238, 1.0),
                      fontSize: 45.0),
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            category,
                            style: const TextStyle(
                                color: Color.fromRGBO(254, 255, 238, 1.0),
                                fontSize: 15),
                          )),
                    ),
                    Expanded(flex: 4, child: postCategory)
                  ],
                ),
              ],
              mainAxisSize: MainAxisSize.min,
            );

            final topContent = Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  height: MediaQuery.of(context).size.height * 0.7,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  padding: const EdgeInsets.all(40.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(133, 96, 185, 1.0)),
                  child: Center(
                    child: topContentText,
                  ),
                ),
                Positioned(
                  left: 6.0,
                  top: 40.0,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(LineAwesomeIcons.angle_left,
                        color: Color.fromRGBO(171, 255, 184, 1.0), size: 30),
                  ),
                ),
              ],
            );

            final bottomContent = Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: MediaQuery.of(context).size.height / 12,
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPost(
                                  postid: postid,
                                  userid: userid,
                                  category: doc['category_id'],
                                  title: doc['title'],
                                  desc: doc['desc'],
                                  price: double.parse(doc['price']),
                                ),
                              ));
                        },
                        color: Color.fromRGBO(255, 202, 44, 1.0),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Theme.of(context).primaryColorDark,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "Edit",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Color.fromRGBO(117, 93, 20, 1.0)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: MediaQuery.of(context).size.height / 12,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialog(context),
                          );
                        },
                        color: Color.fromRGBO(187, 45, 59, 1.0),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: Color.fromRGBO(187, 45, 59, 1.0),
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ));
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[topContent, bottomContent],
                ),
              ),
            );
          }
          return Loading();
        });
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(248, 215, 218, 1.0),
      title: const Icon(LineAwesomeIcons.exclamation_circle,
          color: Color.fromRGBO(132, 32, 41, 1.0), size: 40),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            'Are you sure you want to delete this post?',
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
        TextButton(
          onPressed: () async {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyPosts(
                    userid: userid,
                  ),
                ));
            DatabaseService(uid: userid).deletePost(postid);
          },
          child: const Text(
            'Yes',
            style: TextStyle(color: Color.fromRGBO(132, 32, 41, 1.0)),
          ),
        ),
      ],
    );
  }
}
