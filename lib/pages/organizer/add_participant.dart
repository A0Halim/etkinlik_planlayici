import 'package:etkinlik_planlayici/controllers/organizer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddParticipant extends StatelessWidget {
  AddParticipant({super.key});

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
              Obx(() => Column(
                children: oservice.memberData.map((data) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(child: Text(data["user_name"])),
                      Expanded(
                        child: RawMaterialButton(
                          onPressed: () => oservice.addMember(data),
                          child: Icon(Icons.add, color: oservice.members.contains(data) ? Colors.grey : Colors.black),
                        ),
                      ),
                      Expanded(
                        child: RawMaterialButton(
                          onPressed: () => oservice.removeMember(data),
                          child: Icon(Icons.remove, color: oservice.members.contains(data) ? Colors.black : Colors.grey),
                        ),
                      )
                    ],
                  );
                }).toList()
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RawMaterialButton(
                    onPressed: () => oservice.fetchMembers(back: true),
                    child: Obx(() => Icon(Icons.arrow_left, size: 64, color: oservice.memberPageHistory.isEmpty ? Colors.grey : Colors.black,)),
                  ),
                  Obx(() => Text("Sayfa ${oservice.memberPageHistory.length + 1}")),
                  RawMaterialButton(
                    onPressed: () => oservice.fetchMembers(),
                    child: Obx(() => Icon(Icons.arrow_right, size: 64, color: oservice.isHasNext.value ? Colors.black : Colors.grey,)),
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}