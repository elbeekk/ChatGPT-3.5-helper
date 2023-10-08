import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app/app_constants.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            splashRadius: 25,
            color: Constants.mainColor,
            highlightColor: Constants.mainColor,
            icon: Icon(
              Icons.arrow_back_ios,
              color: Constants.mainColor,
            )),
        backgroundColor: Constants.backColor,
        elevation: 0,
        title: Text('Info',style: GoogleFonts.openSans(color: Constants.mainColor,fontSize: 20,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
    );
  }
}
