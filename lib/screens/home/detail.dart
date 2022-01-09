import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:thrifstore/shared/loading.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPost extends StatefulWidget {
  DetailPost({Key? key, required this.postId, required this.userId})
      : super(key: key);
  final String postId;
  final String userId;

  @override
  _DetailPostState createState() => _DetailPostState();
}

class _DetailPostState extends State<DetailPost> {
  late String postId;
  late String userId;
  String name = '';
  String email = '';
  String phone = '';
  String adress = '';
  late Future<void> _launched;

  Future<void> _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future getUser(String user) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot = await collection.doc(user).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      setState(() {
        name = data?['name'];
        email = data?['email'];
        phone = data?['phone'];
        adress = data?['adress'];
      });
    }
  }

  @override
  void initState() {
    postId = widget.postId;
    userId = widget.userId;
    getUser(userId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .snapshots(includeMetadataChanges: true),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
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
                            'gs://thrifstore-843c3.appspot.com/' +
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
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _launched = _openUrl('mailto:${email}');
                                });
                              },
                              child: Text(
                                email,
                                style: const TextStyle(
                                    color: Color.fromRGBO(254, 255, 238, 1.0),
                                    fontSize: 15),
                              )),
                        )),
                    Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _launched = _openUrl('tel:${phone}');
                                });
                              },
                              child: Text(
                                phone,
                                style: const TextStyle(
                                    color: Color.fromRGBO(254, 255, 238, 1.0),
                                    fontSize: 15),
                              )),
                        )),
                    Expanded(flex: 2, child: postCategory)
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
                  top: 65.0,
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
              child: Text(
                doc['desc'],
                style: const TextStyle(
                    fontSize: 18.0, color: Color.fromRGBO(0, 0, 0, 0.65)),
                textAlign: TextAlign.justify,
              ),
            );
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
}
