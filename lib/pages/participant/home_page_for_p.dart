import 'package:etkinlik_planlayici/pages/login_page.dart';
import 'package:etkinlik_planlayici/controllers/participant_controller.dart';
import 'package:etkinlik_planlayici/pages/participant/event_info_for_p_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageForParticipant extends StatelessWidget {
  HomePageForParticipant({super.key});
  
  final ParticipantControl pservice = Get.put(ParticipantControl(), permanent: true);

  @override
  Widget build(BuildContext context) {

    pservice.fetchInv();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              pservice.singOut();
              Get.offAll(LoginPage());
            },
            icon: const Icon(Icons.exit_to_app)
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() {
                return Column(
                  children: pservice.invs.isNotEmpty ? pservice.invs.map((event) {
                    return Container(
                      color : pservice.getStateColor(event),
                      child : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children : [
                          Text(event["event_name"]),
                          IconButton(
                            onPressed : () {
                              pservice.chosenEvent = event;
                              Get.to(EventInfoPage());
                            },
                            icon: const Icon(Icons.info)
                          )
                        ],
                      ),
                    );
                  }).toList() : [const Text("Seni bekleyen hiç bir etkinlik yok :(")]
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}