import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:thrifstore/screens/home/detail.dart';
import 'package:thrifstore/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:thrifstore/shared/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String url = '';
  String picurl = '';
  final AuthService _auth = AuthService();
  final Stream<QuerySnapshot> _postsStream = FirebaseFirestore.instance
      .collection('posts')
      .snapshots(includeMetadataChanges: true);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _postsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading();
        }

        return Scaffold(
          appBar: AppBar(
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
                              'gs://thrifstore-843c3.appspot.com/' +
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
                                  builder: (context) => DetailPost(
                                        postId: data['docId'],
                                        userId: data['user_id'],
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
