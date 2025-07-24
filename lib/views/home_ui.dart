// ignore_for_file: duplicate_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_diaryfood_app/models/diaryfood.dart';
import 'package:my_diaryfood_app/services/call_api.dart';
import 'package:my_diaryfood_app/views/add_diaryfood_ui.dart';
import 'package:my_diaryfood_app/utils/env.dart';
import 'package:my_diaryfood_app/views/login_ui.dart';
import 'package:my_diaryfood_app/views/modify_diaryfood_ui.dart';
import 'package:my_diaryfood_app/models/diaryfood.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  // สร้างตัวแปรที่เก็บข้อมูลจากการเรียกใช้ API
  Future<List<Diaryfood>>? diaryfoodData;

  // สร้างเมธอดที่เรียกใช้ API
  getAllDiaryfood() {
    setState(() {
      diaryfoodData = CallApi.callAPIGetAllDiaryfood();
    });
  }

  @override
  void initState() {
    getAllDiaryfood();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'My Diary Food',
          style: GoogleFonts.itim(),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginUI(),
                ),
              );
            },
            icon: Icon(
              Icons.exit_to_app,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // เปิดไปหน้า AddDiaryfoodUI แบบย้อนกลับได้
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddDairyfoodUI(),
            ),
          ).then((value) => getAllDiaryfood());
        },
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: Column(
          children: [
            // แสดงรูปที่เตรียมไว้
            Image.asset(
              'assets/images/banner.jpg',
              fit: BoxFit.cover,
            ),
            // แสดงข้อมูลรายการกินที่ Get มาจาก Database ที่ Server ในรูปของ ListView
            Expanded(
              child: FutureBuilder(
                future: CallApi.callAPIGetAllDiaryfood(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    // เอาข้อมูลใส่ ListView โดยการตรวจสอบ massage
                    if (snapshot.data[0].message == '0') {
                      return Center(
                        child: Text(
                          'ยังไม่มีข้อมูล',
                          style: GoogleFonts.itim(),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        // นับจำนวนข้อมูลทีจะแสดงใน ListView
                        itemCount: snapshot.data!.length,
                        // Layout ของ ListView ที่จะนำข้อมูลมาแสดง
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  // เอาข้อมูลที่ได้มาจาก Server เก็บไว้ในตัวแปร/ออปเจ็กต์
                                  Diaryfood diaryfood = Diaryfood(
                                    foodId: snapshot.data[index].foodId,
                                    foodShopname:
                                        snapshot.data[index].foodShopname,
                                    foodImage: snapshot.data[index].foodImage,
                                    foodPay: snapshot.data[index].foodPay,
                                    foodMeal: snapshot.data[index].foodMeal,
                                    foodDate: snapshot.data[index].foodDate,
                                    foodProvince:
                                        snapshot.data[index].foodProvince,
                                  );

                                  // เปิดหน้า modify พร้อมกันส่งข้อมูลในตัวแปรไปแสดงด้วย
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ModifyDiaryfoodUI(
                                        diaryfood: diaryfood,
                                      ),
                                    ),
                                  ).then((value) => getAllDiaryfood());
                                },
                                leading: Image.network(
                                  // Env.domainURL + 'diaryfoodapi/images/img1.jpg',
                                  Env.domainURL +
                                      '/diaryfoodapi/images/' +
                                      snapshot.data[index].foodImage,
                                  fit: BoxFit.cover,
                                  height: 50,
                                  width: 50,
                                ),
                                title: Text(
                                  snapshot.data[index].foodShopname,
                                ),
                                subtitle: Text(
                                  snapshot.data[index].foodDate,
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'มีข้อผิดพลาดเกิดขึ้น',
                        style: GoogleFonts.itim(),
                      ),
                    );
                  }

                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
