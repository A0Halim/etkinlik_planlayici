import 'package:etkinlik_planlayici/controllers/organizer_controller.dart';
import 'package:etkinlik_planlayici/controllers/time_controller.dart';
import 'package:etkinlik_planlayici/pages/organizer/add_participant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventCreatePage extends StatelessWidget {
  EventCreatePage({super.key});

  final OrganizerControl oservices = Get.find();
  final TimeController timeController = Get.find();

  @override
  Widget build(BuildContext context) {
    String? eventName;
    String? eventDescription;
    String? eventAdress;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Etkinlik adı",
                  ),
                  onChanged: (name) { 
                    eventName = name;
                  },
                ),
                const SizedBox(height: 10,),
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Etkinlik Adresi",
                  ),
                  onChanged: (adres) { 
                    eventAdress = adres;
                  },
                ),
                const SizedBox(height: 10,),
                ConstrainedBox (
                  constraints: const BoxConstraints(
                    minHeight: 32,
                    maxHeight: 128
                  ),
                  child: TextFormField(
                    expands: true,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      hintText: "Etkinlik Açıklaması",
                    ),
                    onChanged: (description) {
                      eventDescription = description;
                    },
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      style: BorderStyle.solid,
                      width: 1
                    ),
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text("Tarih : "),
                      RawMaterialButton(
                        onPressed: () => timeController.getDate(context),
                        child: Obx(() => Text("${timeController.eventStartDate.value.toLocal()}".split(' ')[0])),
                      ),
                      const Text("Saat : "),
                      RawMaterialButton(
                        onPressed: () => timeController.getTime(context),
                        child: Obx(() => Text("${timeController.eventStartTime.value.hour} : ${timeController.eventStartTime.value.minute}")),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      style: BorderStyle.solid,
                      width: 1
                    ),
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: RawMaterialButton(
                    onPressed: () => Get.to(AddParticipant()),
                    child: const Text("Katılımcı Ekle"),
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      style: BorderStyle.solid,
                      width: 1
                    ),
                    borderRadius: BorderRadius.circular(16)
                  ),
                  child: RawMaterialButton(
                    onPressed: () {
                      if (eventName != null && eventDescription != null && eventAdress != null) {
                        oservices.addNewEvent(eventName: eventName!, eventAdress: eventAdress!, eventDescription: eventDescription!, startDate: timeController.eventStartDate.value, startTime: timeController.eventStartTime.value);
                        Get.back();
                      }
                    },
                    child: const Text("Yeni etkinlik oluştur"),
                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}