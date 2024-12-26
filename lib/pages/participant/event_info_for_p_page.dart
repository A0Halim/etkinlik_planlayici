import 'package:etkinlik_planlayici/controllers/participant_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventInfoPage extends StatelessWidget {
  EventInfoPage({super.key});

  final ParticipantControl pservice = Get.find();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text("Etkinlik adı : ${pservice.chosenEvent!["event_name"]}"),
              const SizedBox(height: 10,),
              Text("Etkinlik düzenleyicisi : ${pservice.chosenEvent!["event_organizer_name"]}"),
              const SizedBox(height: 10,),
              Text("Etkinlik adresi : ${pservice.chosenEvent!["event_adress"]}"),
              const SizedBox(height: 10,),
              Text("Etkinlik tarihi : ${pservice.getDate()}"),
              const SizedBox(height: 10,),
              Text("Etkinlik açıklaması : ${pservice.chosenEvent!["event_description"]}"),
              const SizedBox(height: 10,),
              Text("Etkinlik katılımcıları : ${pservice.chosenEvent!["event_members"].values}"),
              const SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RawMaterialButton(
                    onPressed: () {
                      pservice.accept();
                      Get.back();
                    },
                    child: const Icon(Icons.check_circle_outline, size: 48,),
                  ),
                  RawMaterialButton(
                    onPressed: () {
                      pservice.reject();
                      Get.back();
                    },
                    child: const Icon(Icons.highlight_remove, size: 48,),
                  )
                ],
              )
            ]
          ),
        ),
      ),
    );
  }
}