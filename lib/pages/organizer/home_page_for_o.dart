import 'package:etkinlik_planlayici/controllers/time_controller.dart';
import 'package:etkinlik_planlayici/pages/login_page.dart';
import 'package:etkinlik_planlayici/pages/organizer/event_create_page.dart';
import 'package:etkinlik_planlayici/controllers/organizer_controller.dart';
import 'package:etkinlik_planlayici/pages/organizer/event_info_for_o_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageForOrganizer extends StatelessWidget {
  HomePageForOrganizer({super.key});

  final OrganizerControl oservice = Get.put(OrganizerControl(), permanent: true); 
  final TimeController timeController = Get.put(TimeController(), permanent: true);

  @override
  Widget build(BuildContext context) {

    oservice.fetchEvents();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              oservice.singOut();
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
                  children: oservice.events.asMap().entries.map((event) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("${event.value["event_name"]}"),
                        IconButton(
                          onPressed: () {
                            oservice.chosenEvent = event.value;
                            oservice.getEventMemeberState();
                            Get.to(EventInfoForOPage());
                          },
                          icon: const Icon(Icons.info)
                        ),
                        IconButton(
                          onPressed: () => oservice.deleteEvent(event.key),
                          icon: const Icon(Icons.delete)
                        )
                      ],
                    );
                  }).toList(),
                );
              }),
              RawMaterialButton(
                onPressed: () {
                  oservice.members.clear();
                  Get.to(EventCreatePage());
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Yeni Etkinlik"),
                    SizedBox(width: 32,),
                    Icon(Icons.add),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}