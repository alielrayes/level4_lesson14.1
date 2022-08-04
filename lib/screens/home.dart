// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_app/shared/colors.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final double widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor:
            widthScreen > 600 ? webBackgroundColor : mobileBackgroundColor,
        appBar: widthScreen > 600
            ? null
            : AppBar(
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.messenger_outline,
                      )),
                  IconButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                      icon: Icon(
                        Icons.logout,
                      )),
                ],
                backgroundColor: mobileBackgroundColor,
                title: SvgPicture.asset(
                  "assets/img/instagram.svg",
                  color: primaryColor,
                  height: 32,
                ),
              ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('postSSS').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
              ));
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Container(
                  decoration: BoxDecoration(
                      color: mobileBackgroundColor,
                      borderRadius: BorderRadius.circular(12)),
                  margin: EdgeInsets.symmetric(
                      vertical: 11,
                      horizontal: widthScreen > 600 ? widthScreen / 6 : 0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 13),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(125, 78, 91, 110),
                                  ),
                                  child: CircleAvatar(
                                    radius: 33,
                                    backgroundImage: NetworkImage(
                                        // widget.snap["profileImg"],
                                        // "https://i.pinimg.com/564x/94/df/a7/94dfa775f1bad7d81aa9898323f6f359.jpg"
                                        // "https://static-ai.asianetnews.com/images/01e42s5h7kpdte5t1q9d0ygvf7/1-jpeg.jpg"
                                        data["profileImg"]),
                                  ),
                                ),
                                SizedBox(
                                  width: 17,
                                ),
                                Text(
                                  data["username"],
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.more_vert)),
                          ],
                        ),
                      ),
                      Image.network(
                        // widget.snap["postUrl"],
                        // "https://cdn1-m.alittihad.ae/store/archive/image/2021/10/22/6266a092-72dd-4a2f-82a4-d22ed9d2cc59.jpg?width=1300",
                        data["imgPost"],
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.favorite_border),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.comment_outlined,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.send,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.bookmark_outline),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                          width: double.infinity,
                          child: Text(
                            "${data["likes"].length} ${data["likes"].length > 1 ? "Likes" : "Like"}      ",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(214, 157, 157, 165)),
                          )),
                      Row(
                        children: [
                          SizedBox(
                            width: 9,
                          ),
                          Text(
                            data["username"],
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 189, 196, 199)),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            // " ${widget.snap["description"]}",
                            data["description"],
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 189, 196, 199)),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                            margin: EdgeInsets.fromLTRB(10, 13, 9, 10),
                            width: double.infinity,
                            child: Text(
                              "view all 100 comments",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(214, 157, 157, 165)),
                              textAlign: TextAlign.start,
                            )),
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 9, 10),
                          width: double.infinity,
                          child: Text(
                            DateFormat('MMMM d, ' 'y')
                                .format(data["datePublished"].toDate()),
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(214, 157, 157, 165)),
                            textAlign: TextAlign.start,
                          )),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ));
  }
}
