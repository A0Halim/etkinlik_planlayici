import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etkinlik_planlayici/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrganizerControl extends GetxController{
  
  final UserControl _service = Get.find();

  RxList<DocumentSnapshot> events = <DocumentSnapshot>[].obs;

  RxList<DocumentSnapshot> members = <DocumentSnapshot>[].obs;
  RxList<DocumentSnapshot> memberPageHistory = <DocumentSnapshot>[].obs;
  RxList<DocumentSnapshot> memberData = <DocumentSnapshot>[].obs;
  RxMap<String, bool?> eventMemberState = <String, bool?>{}.obs;
  DocumentSnapshot? chosenEvent;
  RxBool isHasNext = true.obs;

  singOut() => _service.singOut();

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
    fetchMembers();
  }

  fetchEvents() async {
    QuerySnapshot querySnapshot = await _service.fireStore.collection("users").doc(_service.user!.uid).collection("events").where('event_date', isGreaterThan: DateTime.now()).orderBy('event_date', descending: true).get();
    events.value = querySnapshot.docs;
  }

  fetchMembers({bool back = false}) async {
    if (isHasNext.value && memberData.isNotEmpty && !back) {
      memberPageHistory.add(memberData.last);
    }
    DocumentSnapshot? startAfter;
    if (memberPageHistory.isNotEmpty) {
      if (back) {
        memberPageHistory.removeLast();
      }
      if (memberPageHistory.isNotEmpty) {
        startAfter = memberPageHistory.last;
      }
    }
    Query query = _service.fireStore.collection("users").where("role", isEqualTo: "katilimci");
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    QuerySnapshot querySnapshot = await query.limit(3).get();
    memberData.value = querySnapshot.docs;
    isHasNext.value = true;
    if (querySnapshot.docs.length != 3 && !back) {
      isHasNext.value = false;
    }
  }

  addNewEvent({required String eventName, required String eventDescription, required String eventAdress, required DateTime startDate, required TimeOfDay startTime}) async {
    Map<String, dynamic> eventData = {
        "event_organizer_name" : _service.userName.value,
        "event_name" : eventName,
        "event_adress" : eventAdress,
        "event_description" : eventDescription,
        "event_date" : DateTime(startDate.year, startDate.month, startDate.day, startTime.hour, startTime.minute),
        "event_state" : "continue",
        "event_members" : { for (DocumentSnapshot element in members) element.id : element["user_name"] }
    };
    DocumentReference event = await _service.fireStore.collection("users").doc(_service.user!.uid).collection("events").add(eventData);
    _sendInv(members, eventData, event.id);
    fetchEvents();
  }

  _sendInv(RxList<DocumentSnapshot> invList, Map<String, dynamic> eventData, String eventId) async {
    for (DocumentSnapshot invers in invList) {
      _service.fireStore.collection("users").doc(invers.id).collection("invitations").doc(eventId).set(eventData);
    }
  }

  deleteEvent(int eventIndex) async {
    await _service.fireStore.collection("users").doc(_service.user!.uid).collection("events").doc(events[eventIndex].id).delete();
    events.remove(events[eventIndex]);
  }

  addMember(DocumentSnapshot doc) async {
    if (!members.contains(doc)) {
      members.add(doc);    
    }
  }

  removeMember(DocumentSnapshot doc) {
    if (members.contains(doc)) {
      members.remove(doc);
    }
  }

  String getDate(){
    DateTime date = chosenEvent!["event_date"].toDate();
    return "${date.year} - ${date.month} - ${date.day} / ${date.hour} : ${date.minute}";
  }

  getEventMemeberState() {
    Map<String, dynamic> ids = chosenEvent!["event_members"];
    ids.forEach((key, value) async {
      DocumentSnapshot ds = await _service.fireStore.collection("users").doc(key).collection("invitations").doc(chosenEvent!.id).get();
      bool? state;
      switch (ds["event_state"]) {
        case "accepted":
          state = true;
          break;
        case "rejected":
          state = false;
        default:
      }
      eventMemberState[value] = state;
    });
  }
}