import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_app/app_constants.dart';

class SignInPage extends StatefulWidget {
  SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  FToast fToast = FToast();

  bool? isSend;

  TextEditingController textEditingController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

  @override
  void initState() {
    fToast.init(context);
    // TODO: implement initState
    super.initState();
  }
  Future<void> sendLink() async {
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    Timer timer = Timer.periodic(const Duration(microseconds: 500), (timer) {
      if(FirebaseAuth.instance.currentUser!.emailVerified){
        log('-------VERIFIED------');
        setState(() {
          isSend=false;
        });
        timer.cancel();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Constants.mainColor,
        extendBodyBehindAppBar: true,
        floatingActionButton: SafeArea(
          child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  backgroundColor: Constants.backColor),
              onPressed: () {
                if(formKey.currentState!.validate() && textEditingController.text.isNotEmpty){
                    try{
                        FirebaseAuth.instance.signInWithEmailAndPassword(email: textEditingController.text.trim(), password: '123456');
                        sendLink();
                    }catch(error1){
                      fToast.showToast(
                          gravity: ToastGravity.TOP,
                          child: Container(
                            decoration: BoxDecoration(color: Constants.errorColor,borderRadius: BorderRadius.circular(25)),
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            child: Text(error1.toString(),style: GoogleFonts.openSans(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 18),),
                          ));
                    }
                    try{
                      FirebaseAuth.instance.createUserWithEmailAndPassword(email: textEditingController.text.trim(), password: '123456');
                      sendLink();
                     }catch(error2){
                      fToast.showToast(
                          gravity: ToastGravity.TOP,
                          child: Container(
                            decoration: BoxDecoration(color: Constants.errorColor,borderRadius: BorderRadius.circular(25)),
                            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            child: Text(error2.toString(),style: GoogleFonts.openSans(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 18),),
                          ));
                    }

                  setState(() {
                      isSend=true;
                    });
                }else{
                  fToast.showToast(
                      gravity: ToastGravity.TOP,
                      child: Container(
                        decoration: BoxDecoration(color: Constants.errorColor,borderRadius: BorderRadius.circular(25)),
                        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                        child: Text('Please enter your email',style: GoogleFonts.openSans(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 18),),
                      ));
                }
              },
              icon: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Text(
                  isSend == null ? 'Send Link' : isSend!? 'Link Sent' : 'Continue',
                  style: GoogleFonts.openSans(
                      color: Constants.mainColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              label: isSend == null
                  ? Icon(
                      Icons.link,
                      color: Constants.mainColor,
                    )
                  : isSend!
                      ? SizedBox(
                height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Constants.mainColor,
                            backgroundColor: Constants.backColor,
                          ),
                      )
                      : Icon(
                          Icons.arrow_forward_ios,
                          color: Constants.mainColor,
                        )),
        ),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Constants.mainColor,
          automaticallyImplyLeading: false,
          title: Text(
            Constants.appName,
            style:
                GoogleFonts.openSans(fontWeight: FontWeight.bold, fontSize: 30),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: TextFormField(
                    onChanged: (value) {
                      if(isSend!=null){
                        if(isSend!){
                          setState(() {
                            isSend=null;
                          });
                        }
                      }
                    },
                    validator: validateEmail,
                    controller: textEditingController,
                    style: GoogleFonts.openSans(
                        color: Constants.mainColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                    cursorColor: Constants.mainColor,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      hintStyle: GoogleFonts.openSans(
                          color: Constants.mainColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                      fillColor: Constants.backColor,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Constants.backColor),
                          borderRadius: BorderRadius.circular(25)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Constants.backColor),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Constants.backColor),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Constants.backColor),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Constants.backColor),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
