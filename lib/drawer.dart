import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/app_constants.dart';
import 'package:test_app/info_page.dart';
import 'package:test_app/payments_page.dart';
import 'package:test_app/settings_page.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool? isUz = false;
  bool? isRu = false;
  Future<void> pickLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('lang', 'uz');
    final lang = preferences.getString('lang');
    if (lang == 'uz') {
      setState(() {
        isUz = true;
      });
    }
    if (lang == 'ru') {
      setState(() {
        isRu = true;
      });
    }
  }
  String pickText(
      {required String en1, required String ru2, required String uz3}) {
    if (isUz != null) {
      if (isUz!) {
        return uz3;
      } else {
        if (isRu!) {
          return ru2;
        } else {
          return en1;
        }
      }
    }
    return en1;
  }
  @override
  void initState() {
    pickLanguage();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    return Drawer(
      child: Center(
        child: Column(
          children: [
            Container(
              color: Constants.mainColor,
              height: h * 0.25,
              width: w,
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      width: h * 0.16,
                      child: Lottie.asset('assets/male.json'),
                    ),
                    SizedBox(
                      child: Text(
                        FirebaseAuth.instance.currentUser!.email!,
                        style: GoogleFonts.openSans(
                            color: Constants.backColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,

                        ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage(),));
                    },
                    leading: Icon(Icons.settings,color: Constants.mainColor,),
                    title: Text(pickText(en1: Constants.settings1, ru2: Constants.settings2, uz3: Constants.settings3),style: GoogleFonts.openSans(color: Constants.mainColor,fontWeight: FontWeight.w500,fontSize: 16),),
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentsPage(),));
                    },
                    leading: Icon(Icons.payment,color: Constants.mainColor,),
                    title: Text(pickText(en1: Constants.payments1, ru2: Constants.payments2, uz3: Constants.payments3),style: GoogleFonts.openSans(color: Constants.mainColor,fontWeight: FontWeight.w500,fontSize: 16),),
                  ),
                  ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const InfoPage(),));
                    },
                    leading: Icon(Icons.info_outline,color: Constants.mainColor,),
                    title: Text(pickText(en1: Constants.aboutApp1, ru2: Constants.aboutApp2, uz3: Constants.aboutApp3),style: GoogleFonts.openSans(color: Constants.mainColor,fontWeight: FontWeight.w500,fontSize: 16),),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
