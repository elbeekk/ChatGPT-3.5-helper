import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/app_constants.dart';
import 'package:test_app/home_page.dart';

class SignInPage extends StatefulWidget {
  SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  FToast fToast = FToast();
  bool? isSend;
  bool isLogin = true;
  TextEditingController emailCon = TextEditingController();
  TextEditingController passwordCon1 = TextEditingController();
  TextEditingController passwordCon2 = TextEditingController();
  final fromEmailKey = GlobalKey<FormState>();
  final formPasswordKey1 = GlobalKey<FormState>();
  final formPasswordKey2 = GlobalKey<FormState>();
  bool? isUz = false;
  bool? isRu = false;
  Future<void> pickLanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
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
        ? pickText(
            en1: Constants.formEmail1,
            ru2: Constants.formEmail2,
            uz3: Constants.formEmail3)
        : null;
  }

  String? validatePassword1(String? value) {
    final regex2 = RegExp(r'(?=.*[a-z])');
    final regex3 = RegExp(r'(?=.*?[0-9])');
    final regex1 = RegExp(r'.{6,}$');
    if (!regex1.hasMatch(value!)) {
      return pickText(
          en1: Constants.form1Password1,
          ru2: Constants.form1Password2,
          uz3: Constants.form1Password3);
    } else if (!regex2.hasMatch(value)) {
      return pickText(
          en1: Constants.form2Password1,
          ru2: Constants.form2Password2,
          uz3: Constants.form2Password3);
    } else if (!regex3.hasMatch(value)) {
      return pickText(
          en1: Constants.form3Password1,
          ru2: Constants.form3Password2,
          uz3: Constants.form3Password3);
      ;
    } else {
      return null;
    }
  }

  String? validatePassword2(String? value) {
    final regex1 = RegExp(r'.{6,}$');
    if (!regex1.hasMatch(value!)) {
      return pickText(en1: Constants.form1Password1, ru2: Constants.form1Password2, uz3: Constants.form1Password3);
    } else if (!(passwordCon1.text == passwordCon2.text)) {
      return pickText(en1: Constants.form4Password1, ru2: Constants.form4Password2, uz3: Constants.form4Password3);
    } else {
      return null;
    }
  }

  @override
  void initState() {
    fToast.init(context);
    pickLanguage();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
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
              onPressed: () async {
                if (fromEmailKey.currentState!.validate() &&
                    formPasswordKey1.currentState!.validate()) {
                  if (isLogin) {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailCon.text.trim(),
                          password: passwordCon1.text.trim());
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                          (route) => false);
                    } on FirebaseAuthException catch (error) {
                      fToast.showToast(
                          gravity: ToastGravity.TOP,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Constants.errorColor,
                                borderRadius: BorderRadius.circular(25)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              'Password or network error',
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                          ));
                    }
                  } else if (!isLogin &&
                      formPasswordKey2.currentState!.validate()) {
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: emailCon.text.trim(),
                              password: passwordCon2.text.trim());
                      FirebaseFirestore.instance.collection('user').doc(emailCon.text.trim()).set(
                          {
                            'email':emailCon.text.trim(),
                            'password':passwordCon2.text.trim(),
                            'coins':5
                          });
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                          (route) => false);
                    } on FirebaseAuthException catch (e) {
                      fToast.showToast(
                          gravity: ToastGravity.TOP,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Constants.errorColor,
                                borderRadius: BorderRadius.circular(25)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              e.message.toString(),
                              style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18),
                            ),
                          ));
                    }
                  }
                }
              },
              icon: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Text(
                  pickText(en1: Constants.continue1, ru2: Constants.continue2, uz3: Constants.continue3),
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
        ),
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
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: h * 0.3),
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Opacity(
                        opacity: !isLogin ? 0.5 : 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(w * 0.4, 40),
                              maximumSize: Size(w * 0.4, 50),
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.08, vertical: 10),
                              backgroundColor: Constants.backColor,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25)))),
                          onPressed: () {
                            setState(() {
                              isLogin = true;
                            });
                          },
                          child: Center(
                            child: Text(
                              pickText(
                                  en1: Constants.login1,
                                  ru2: Constants.login2,
                                  uz3: Constants.login3),
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Constants.mainColor),
                            ),
                          ),
                        )),
                    Opacity(
                        opacity: isLogin ? 0.5 : 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(w * 0.4, 40),
                              maximumSize: Size(w * 0.4, 50),
                              elevation: 0,
                              padding: EdgeInsets.all(10),
                              backgroundColor: Constants.backColor,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(25)))),
                          onPressed: () {
                            setState(() {
                              isLogin = false;
                            });
                          },
                          child: Center(
                            child: isUz! || isRu!
                                ? Marquee(
                                    text: pickText(
                                        en1: Constants.register1,
                                        ru2: Constants.register2,
                                        uz3: Constants.register3),
                              blankSpace: 20,
                              style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Constants.mainColor),

                            )
                                : Text(
                                    pickText(
                                        en1: Constants.register1,
                                        ru2: Constants.register2,
                                        uz3: Constants.register3),
                                    style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        color: Constants.mainColor),
                                  ),
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Form(
                  key: fromEmailKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: TextFormField(
                    validator: validateEmail,
                    controller: emailCon,
                    style: GoogleFonts.openSans(
                        color: Constants.mainColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                    cursorColor: Constants.mainColor,
                    decoration: InputDecoration(
                      hintText: pickText(
                          en1: Constants.eEmail1,
                          ru2: Constants.eEmail2,
                          uz3: Constants.eEmail3),
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
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 20, right: 20, top: 5, bottom: isLogin ? 100 : 5),
                child: Form(
                  key: formPasswordKey1,
                  autovalidateMode: AutovalidateMode.always,
                  child: TextFormField(
                    validator: validatePassword1,
                    controller: passwordCon1,
                    style: GoogleFonts.openSans(
                        color: Constants.mainColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                    cursorColor: Constants.mainColor,
                    decoration: InputDecoration(
                      hintText: pickText(
                          en1: Constants.e1Password1,
                          ru2: Constants.e1Password2,
                          uz3: Constants.e1Password3),
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
              ),
              if (!isLogin)
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 5, bottom: 100),
                  child: Form(
                    key: formPasswordKey2,
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      validator: validatePassword2,
                      controller: passwordCon2,
                      style: GoogleFonts.openSans(
                          color: Constants.mainColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                      cursorColor: Constants.mainColor,
                      decoration: InputDecoration(
                        hintText: pickText(
                            en1: Constants.e2Password1,
                            ru2: Constants.e2Password2,
                            uz3: Constants.e2Password3),
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}
