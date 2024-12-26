import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final UserControl services = Get.find();

  @override
  Widget build(BuildContext context) {

    RxBool katilimci = true.obs;

    String? userName;
    String? email;
    String? password;
    String? repeatPasword;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kaydol", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.white12,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_add, color: Colors.blue, size: 150),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Kullanıcı adı",
                prefixIcon: Icon(Icons.person)
              ),
              onChanged: (name) {
                userName = name;
              }
            ),
            const SizedBox(height: 10,),
            TextFormField(
              decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.mail_outline)
              ),
              onChanged: (mail) {
                email = mail;
              }
            ),
            const SizedBox(height: 10),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Parola",
                prefixIcon: Icon(Icons.lock),
              ),
              onChanged: (parola) {
                password = parola;
              },
            ),
            const SizedBox(height: 10,),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Parola Tekrarı",
                prefixIcon: Icon(Icons.lock),
              ),
              onChanged: (parola) {
                repeatPasword = parola;
              },
            ),
            const SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(16)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {katilimci.value = !katilimci.value;},
                    icon: const Icon(Icons.cached),
                  ),
                  Obx(() => Text(katilimci.value ? "Katilimci" : "Düzenleyici")),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            RawMaterialButton(
              fillColor: Colors.blue,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onPressed: () async {
                if (email != null && password != null && repeatPasword != null) {
                  if (password == repeatPasword && await services.registerWithMail(email: email!, password: password!, role: katilimci.value, userName: userName)) {
                    Get.back();
                  }
                }
              },
              child: const Text("Kaydol",style: TextStyle(color: Colors.white, fontSize: 18))
            ),
            Text(services.hataMesaji.value)
          ],
        ),
      ),
    );
  }
}