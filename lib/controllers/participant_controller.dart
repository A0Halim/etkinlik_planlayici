import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_planlayici/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParticipantControl extends GetxController {

  final UserControl _services = Get.find();
  RxList<DocumentSnapshot> invs = <DocumentSnapshot>[].obs;
  DocumentSnapshot? chosenEvent;

  singOut() => _services.singOut();

  @override
  void onInit() {
    super.onInit();
    fetchInv();
  }

  fetchInv() async {
    QuerySnapshot qs = await _services.fireStore.collection("users").doc(_services.user!.uid).collection("invitations").where("event_date", isGreaterThan: DateTime.now()).get();
    invs.value = qs.docs;
  }

  reject() async {
    if (chosenEvent!["event_state"] != "rejected") {
      await _services.fireStore.collection("users").doc(_services.user!.uid).collection("invitations").doc(chosenEvent!.id).update({
        "event_state" : "rejected"
      });
      fetchInv();
    }
  }

  accept() async {
    if (chosenEvent!["event_state"] != "accepted") {
      await _services.fireStore.collection("users").doc(_services.user!.uid).collection("invitations").doc(chosenEvent!.id).update({
        "event_state" : "accepted"
      });
      fetchInv();
    }
  }
  getStateColor(DocumentSnapshot event) {
    switch (event["event_state"]) {
      case "continue":
        return Colors.white;
      case "rejected":
        return Colors.red[300];
      case "accepted":
        return Colors.green;
      default:
    }
  }
  String getDate(){
    DateTime date = chosenEvent!["event_date"].toDate();
    return "${date.year} - ${date.month} - ${date.day} / ${date.hour} : ${date.minute}";
  }
}