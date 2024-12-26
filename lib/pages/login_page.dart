import 'package:etkinlik_planlayici/pages/organizer/home_page_for_o.dart';
import 'package:etkinlik_planlayici/pages/participant/home_page_for_p.dart';
import 'package:etkinlik_planlayici/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'register_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final UserControl services = Get.put(UserControl());

  @override
  Widget build(BuildContext context) {

    String? email;
    String? password;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const FlutterLogo(
              size: 200,
              style: FlutterLogoStyle.stacked,
              textColor: Colors.blue,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.mail_outline),
              ),
              onChanged: (value) { // TextFieldda olan değişiklikleri yakalayıp 
                email = value;    // global bir değişkene aktaralım.
              },
            ),                
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Parola",
                prefixIcon: Icon(Icons.lock)
              ),
              onChanged: (parola) {
                password = parola;
              },
            ),
            SizedBox(
              width: double.infinity,
              child: RawMaterialButton(
                fillColor: Colors.blue,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onPressed: () async {
                  if (email != null && password != null) {
                    bool canLogin = await services.loginWithMail(email: email!, password: password!);
                    if (canLogin) {
                      if (services.userRole.value == "katilimci") {
                        Get.off(HomePageForParticipant());
                      } else if(services.userRole.value == "duzenleyici") {
                        Get.off(HomePageForOrganizer());
                      }
                    }
                  }
                },
                child: const SizedBox(
                  child: Text("Giriş", style: TextStyle(color: Colors.white, fontSize: 18),),
                ),
              ),
            ),
            TextButton(
              child: const Text("Şifremi unuttum", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onPressed: () => Get.bottomSheet(
                Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom, // Klavye için boşluk
                    left: 16,
                    right: 16,
                    top: 16,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                        TextButton(
                          onPressed: () {
                            if (email != null) {
                              services.resetPassword(email: email!);
                            }
                          },
                          child: Text("Resetleme e postası gönder", style: TextStyle(color: Colors.indigo[900],fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  )
                ),
                isScrollControlled: true
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Hesabın yok mu?", style: TextStyle(fontSize: 18),),
                TextButton(
                  child: const Text("Kaydol", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  onPressed: () => Get.to(RegisterPage())
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}