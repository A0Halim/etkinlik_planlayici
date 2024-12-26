import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

//KullaniciKontrolServisi
class UserControl extends GetxController{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  User? user;
  RxString userName = "".obs;
  RxString userRole = "".obs;
  RxString hataMesaji = "".obs;

  /// role kımı true ise katılımcı false ise düzenleyici olur
  Future<bool> registerWithMail({required String email, required String password, required bool role, required userName}) async {
    try {
      hataMesaji.value = "istek alındi";
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
      await fireStore.collection("users").doc(user!.uid).set({
        'email' : email,
        'role' : role ? "katilimci" : "duzenleyici",
        'password' : password,
        'user_name' : userName
      });
      user = null;
      hataMesaji.value = "";
      return true;
    } on FirebaseAuthException catch(e) {
      if (e.code == "weak-password") {
        hataMesaji.value = "zayıf şifre";
      } else if (e.code == "email-alread-in-use") {
        hataMesaji.value = "bu mail kullanılıyor";
      }
    } catch (e) {
      hataMesaji.value = "bilinmeyen durum $e";
    }
    return false;
  }

  Future<bool> loginWithMail({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user;
      await _getUserData(user!.uid);
      return  user != null && userRole.value != "";
    } catch (e) {
      hataMesaji.value = "Hata $e";
      return false;
    }
  }

  resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }

  _getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await fireStore.collection('users').doc(uid).get();
      if(doc.exists) {
        userName.value = doc["user_name"];
        userRole.value = doc["role"];
      } else {
        hataMesaji.value = "Kullancıcı bulunamadı";
      }
    } catch (e) {
      hataMesaji.value = "Hata: $e";
    }
  }

  singOut() async{
    user = null;
    userName.value = "";
    userRole.value = "";
    await _auth.signOut();
  }
}