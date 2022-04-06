import 'package:cloud_firestore/cloud_firestore.dart';

class Merchant {
  final String email;
  final String uid;
  final String photoUrl;
  final String merchantname;
  final String description;
  final String longitude;
  final String latitude;

  const Merchant(
      {required this.email,
      required this.uid,
      required this.photoUrl,
      required this.merchantname,
      required this.description,
      required this.latitude,
      required this.longitude});

  static Merchant fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Merchant(
        merchantname: snapshot["username"],
        uid: snapshot["uid"],
        email: snapshot["email"],
        photoUrl: snapshot["photoUrl"],
        description: snapshot["description"],
        latitude: snapshot["latitude"],
        longitude: snapshot['longitude']);
  }

  Map<String, dynamic> toJson() => {
        "username": merchantname,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "description": description,
        "latitude": latitude,
        "longitude": longitude
      };
}
