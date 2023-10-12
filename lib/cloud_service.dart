import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_drag_drop/user.dart';
import 'package:flutter_drag_drop/user_page.dart';

class CloudService {

  static bool usersRead = false;

  // Add user
  static void add(MyUser usr) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(usr.uid).set({
      'uid': usr.uid,
      'username': usr.displayName,
      'email': usr.email,
      'password': usr.password,
      'shapes': usr.shapeMap,
    });
  }
    
  // Update user
  static void update(MyUser usr) {
    Map<String,String?> map = {};
    
    for (var k in usr.shapeMap.keys) {
      map[k.toString()] = usr.shapeMap[k]?.id;
    }

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(usr.uid).update({
      'shapes': map,
    });
  }
  
  // Retrieve all registered users
  static Future<String?> getAllRegistered() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // Make query
    users.get().then(
          (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          var data = docSnapshot.data() as Map<String,dynamic>;
          var usr = MyUser(
            data['uid'] ?? '',
            data['email'] ?? '',
            data['password'] ?? '',
            data['username'] ?? '',
          );
          var userMap = data['shapes'];
          if (userMap != null) {
            for (var k in userMap.keys) {
              usr.shapeMap[int.parse(k)] = userMap[k] != null ?
                  ShapeItem(id: userMap[k]!, position: int.parse(k)) :
                  null;
            }
          }
          // Populate user list
          userList.add(usr);
        }
        usersRead = true;
      },
      onError: (e) {
        return '$e';
      }
    );
    return null;
  }
}