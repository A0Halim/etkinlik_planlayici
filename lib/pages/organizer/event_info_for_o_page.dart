import 'package:etkinlik_planlayici/controllers/organizer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventInfoForOPage extends StatelessWidget {
  EventInfoForOPage({super.key});

  final OrganizerControl oservice = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text("Etkinlik adı : ${oservice.chosenEvent!["event_name"]}"),
              const SizedBox(height: 10,),
              Text("Etkinlik düzenleyicisi : ${oservice.chosenEvent!["event_organizer_name"]}"),
              const SizedBox(height: 10,),
              Text("Etkinlik adresi : ${oservice.chosenEvent!["event_adress"]}"),
              const SizedBox(height: 10,),
              Text("Etkinlik tarihi : ${oservice.getDate()}"),
              const SizedBox(height: 10,),
              Text("Etkinlik açıklaması : ${oservice.chosenEvent!["event_description"]}"),
              const SizedBox(height: 10,),
              const Text("Etkinlik katılımcıları"),
              const SizedBox(height: 10,),
              Obx(() => Column(
                children: oservice.eventMemberState.entries.map((nameState) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    alignment: Alignment.center,
                    width: double.infinity,
                    color: nameState.value == null ? Colors.white : nameState.value! ? Colors.green : Colors.red,
                    child: Text(nameState.key),
                  );
                }).toList(),
              ),)
            ]
          )
        )
      )
    );
  }
}