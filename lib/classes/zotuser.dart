//a Zotuser object contains basic information about a user that helps to streamline how a user's info is updated and gotten from the db

import 'package:cloud_firestore/cloud_firestore.dart';

class Zotuser
{
  //a user currently only has their email, username, and uid associated with them
  late String uid;
  late String email;
  late String username;

  Zotuser({required this.uid, required this.email, required this.username});


//for converting something from the db into an object that can be used
factory Zotuser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options,)
  {
    final data = snapshot.data();

    //uid is left empty since that needs to be gotten from the user object and is stored
    //as the document 'title'
    return Zotuser(uid: '', email: data?['email'], username: data?['username']);
  }

//for converting a Zotuser to something that can be uploaded to the db:
  Map<String, dynamic> toFirestore()
  {
    return {
      'email' : email,
      'username' : username
    };
  }
}