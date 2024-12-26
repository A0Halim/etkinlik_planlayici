import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeController extends GetxController {

  Rx<DateTime> eventStartDate = DateTime.now().obs;
  Rx<TimeOfDay> eventStartTime = TimeOfDay.now().obs;
  
  getDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      eventStartDate.value = pickedDate;
    }
  }

  getTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: eventStartTime.value,
    );

    if (pickedTime != null) {
      eventStartTime.value = pickedTime;
    }
  }
}