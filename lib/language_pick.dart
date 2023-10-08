import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/app_constants.dart';
import 'package:test_app/signin_page.dart';

class LanguagePick extends StatefulWidget {
  LanguagePick({super.key});

  @override
  State<LanguagePick> createState() => _LanguagePickState();
}

class _LanguagePickState extends State<LanguagePick> {
  FToast fToast = FToast();
  List list = [
    ['assets/uzbek.json','Uzbek',false],
    ['assets/russian.json','Russian',false],
    ['assets/english.json','English',false],
  ];
  @override
  void initState() {
    fToast.init(context);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          Constants.appName,
          style:
              GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              backgroundColor: Constants.backColor),
          onPressed: () async {
            SharedPreferences preferences = await SharedPreferences.getInstance();
            preferences.setString('lang', list[0][2] ? 'uz':list[1][2] ? 'ru':'en').whenComplete(() => log(preferences.getString('lang')??''));
            if(list[0][2] ||list[1][2] ||list[2][2] ){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInPage(),), (route) => false);
            }else{
              fToast.showToast(
                  gravity: ToastGravity.TOP,
                  child: Container(
                decoration: BoxDecoration(color: Constants.errorColor,borderRadius: BorderRadius.circular(25)),
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Text('Please pick a language',style: GoogleFonts.openSans(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 18),),
              ));
            }
          },
          icon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Text(
              'Continue',
              style: GoogleFonts.openSans(
                  color: Constants.mainColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          label: Icon(
            Icons.arrow_forward_ios,
            color: Constants.mainColor,
          )),
      backgroundColor: Constants.mainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: list.map((e) {
          return Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: SizedBox(
          height: h * 0.09,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: e[2] ? 5 : 0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 3,
                      color:  e[2]? Colors.green : Constants.backColor,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: Constants.backColor),
              onPressed: () {
                switch(e[1]){
                  case('Uzbek'):{
                    setState(() {
                      list[0][2]=true;
                      list[1][2]=false;
                      list[2][2]=false;
                    });
                  }case('Russian'):{
                    setState(() {
                      list[0][2]=false;
                      list[1][2]=true;
                      list[2][2]=false;
                    });
                  }case('English'):{
                    setState(() {
                      list[0][2]=false;
                      list[1][2]=false;
                      list[2][2]=true;
                    });
                  }
                }
              },
              child: Row(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        e[0]
                      ),
                      SizedBox(
                        height: h * 0.04,
                        child: VerticalDivider(
                          color: Constants.mainColor,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      e[1],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.openSans(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Constants.mainColor),
                    ),
                  ),
                ],
              )),
        ),
      );
        }).toList(),
      ),
    );
  }
}

