import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:test_app/app_constants.dart';
import 'package:test_app/drawer.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Constants.backColor,
      key: scaffoldKey,
      drawer: const MyDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 55,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            color: Constants.mainColor,
            borderRadius: BorderRadius.circular(25)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: TextField(
              controller: textEditingController,
              cursorColor: Constants.backColor,
              keyboardAppearance: Brightness.light,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              style: GoogleFonts.openSans(color: Colors.white, fontSize: 20),
              cursorHeight: 30,
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                suffixIcon: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Constants.mainColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '- 1',
                              style: GoogleFonts.openSans(
                                  fontSize: 22,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                                height: 60,
                                width: 60,
                                child: Lottie.asset('assets/coin.json'))
                          ],
                        ),
                        content: Text(
                          'You will spend your 1 coin.',
                          style: GoogleFonts.openSans(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        actions: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Center(
                                      child: Text(
                                        'Cancel',
                                        style: GoogleFonts.openSans(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                                child: VerticalDivider(
                                  color: Colors.white,
                                  thickness: 1,
                                  endIndent: 0,
                                  indent: 0,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: Text(
                                      'Continue',
                                      style: GoogleFonts.openSans(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  splashRadius: 20,
                  icon: Icon(
                    Icons.send_rounded,
                    color: Constants.backColor,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Constants.mainColor,
        leading: IconButton(
            onPressed: () {
              scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            )),
        elevation: 0,
        title: const Text('e.help'),
        actions: [
          Center(
              child: Text(
            '5',
            style: GoogleFonts.openSans(fontSize: 18),
          )),
          Lottie.asset('assets/coin.json')
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: h * 0.25,
              width: h * 0.25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Constants.mainColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/question.json',
                    width: h * 0.17,
                    height: h * 0.17,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GradientText(
                      'Ask any question',
                      style: GoogleFonts.openSans(
                          fontSize: 20, fontWeight: FontWeight.w500),
                      colors: [
                        Colors.blue.shade900,
                        Colors.deepPurple.shade700,
                        Colors.blue.shade900,
                        Colors.deepPurple.shade900,
                      ],
                    ),
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
