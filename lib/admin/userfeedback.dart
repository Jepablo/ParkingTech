import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class UserFeedback extends StatefulWidget {
  const UserFeedback({Key? key}) : super(key: key);

  @override
  State<UserFeedback> createState() => _UserFeedbackState();
}

class _UserFeedbackState extends State<UserFeedback> {
  CollectionReference ref = FirebaseFirestore.instance.collection('Report');

  //DELETE
  Future<void> _deleteProduct(String productId) async {

    await ref.doc(productId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  FirebaseStorage storage = FirebaseStorage.instance;
    late Future future;

  Future<String> downloadedUrl(String imageName) async {
    String downloadedUrl =
    await storage.ref('Report/$imageName').getDownloadURL();
    return downloadedUrl;
  }

  Widget OneImage(String image)=> FutureBuilder( future: downloadedUrl(image),
      builder: (BuildContext context, AsyncSnapshot snapshot){
      if(snapshot.hasData){
        return Image.network(
          snapshot.data,
          fit: BoxFit.fitHeight,
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
      }
  );

  final appTitle = 'User Feedback';
  @override
  Widget build(BuildContext context)  {
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        drawer: Drawer(),
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: FutureBuilder(
          future: future,
          builder: (context , test) {
            print(test.data.toString());
            return StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Report').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        final DocumentSnapshot documentSnapshot = (snapshot.data!.docs[index]);
                        return Card(
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            leading: OneImage(documentSnapshot['imageURL']),
                            title: Text(documentSnapshot['feedback']),
                            // subtitle: Text(documentSnapshot['imageURL']),
                            trailing:
                             Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => _deleteProduct(documentSnapshot.id),
                                  // => _deleteProduct(documentSnapshot.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          }
        ),
      ),
    );
  }
}

