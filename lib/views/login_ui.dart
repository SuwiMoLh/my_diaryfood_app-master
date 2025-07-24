import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_diaryfood_app/models/member.dart';
import 'package:my_diaryfood_app/services/call_api.dart';
import 'package:my_diaryfood_app/views/home_ui.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  TextEditingController memUsernameCtrl = TextEditingController(text: '');
  TextEditingController memPasswordCtrl = TextEditingController(text: '');

  // เมธอดแสดงข้อความเตือนจากการ Validate ต่างๆ บนหน้าจอ เช่น เลือกรูป ป้อนชื่อร้าน ป้อนต่าใช้จ่าย เลือกวันที่กิน
  showWarningDialog(context, msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'คำเตือน',
            style: GoogleFonts.itim(),
          ),
        ),
        content: Text(
          msg,
          style: GoogleFonts.itim(),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15.0), // กำหนดรัศมีของมุมโค้ง
                  ),
                ),
                child: Text(
                  'ตกลง',
                  style: GoogleFonts.itim(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Member? member;
  // เมธอดเรียกใช้ callAPIChecklogin เพื่อตรวจสอบ ชื่อผู้ใช้ รหัสผ่าน
  Future checklogin() async {
    member = await CallApi.callAPIChecklogin(member!);
    return member;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'Diary Food App',
          style: GoogleFonts.kanit(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Image.asset(
                'assets/images/banner.jpg',
                height: MediaQuery.of(context).size.width * 0.45,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Text(
                'Diary Food App',
                style: GoogleFonts.kanit(
                  fontSize: MediaQuery.of(context).size.height * 0.035,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                'เข้าใช้งานระบบ',
                style: GoogleFonts.kanit(
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ชื่อผู้ใช้ :',
                    style: GoogleFonts.kanit(
                      color: Colors.grey[800],
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.015,
                ),
                child: TextField(
                  controller: memUsernameCtrl,
                  decoration: InputDecoration(
                    hintText: 'ป้อนชื่อผู้ใช้',
                    hintStyle: GoogleFonts.kanit(
                      color: Colors.grey[400],
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'รหัสผ่าน :',
                    style: GoogleFonts.kanit(
                      color: Colors.grey[800],
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.015,
                ),
                child: TextField(
                  controller: memPasswordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'ป้อนรหัสผ่าน',
                    hintStyle: GoogleFonts.kanit(
                      color: Colors.grey[400],
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.03,
                  bottom: MediaQuery.of(context).size.height * 0.1,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // validate ui
                    if (memUsernameCtrl.text.trim().length <= 0) {
                      showWarningDialog(context, "ป้อนชื่อผู้ใช้ด้วย");
                    } else if (memPasswordCtrl.text.trim().length <= 0) {
                      showWarningDialog(context, "ป้อนรหัสผ่านด้วย");
                    } else {
                      // กำหนด ชื่อผู้ใช้และรหัสผ่านให้กับ member เพื่อใช้ส่งไปกับการใช้ API
                      member = Member(
                        memUsername: memUsernameCtrl.text.trim(),
                        memPassword: memPasswordCtrl.text.trim(),
                      );

                      // เรียกใช้เมธอด checklogin() เพื่อตรวจสอบ username, password
                      checklogin().then((value) => {
                            if (value.message == '0')
                              {
                                showWarningDialog(
                                    context, "ชื่อผู้ใช้ รหัสผ่าน ไม่ถูกต้อง"),
                              }
                            else
                              {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomeUI(),
                                  ),
                                ),
                              }
                          });
                    }
                  },
                  child: Text(
                    'เข้าใช้งานระบบ',
                    style: GoogleFonts.kanit(),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.8,
                      MediaQuery.of(context).size.height * 0.07,
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
