// ignore_for_file: must_be_immutable, unused_import

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_diaryfood_app/models/diaryfood.dart';
import 'package:my_diaryfood_app/services/call_api.dart';
import 'package:my_diaryfood_app/utils/env.dart';
import 'package:my_diaryfood_app/views/home_ui.dart';

class ModifyDiaryfoodUI extends StatefulWidget {
  // ตัวแปรหรือออกเจ็กต์ที่เก็บข้อมูลที่ส่งมาจากหน้า Home ที่ผู้ใช้ได้เลือกรายการที่จะดูเพื่อแก้ไขหรือลบ
  Diaryfood? diaryfood;

  ModifyDiaryfoodUI({super.key, this.diaryfood});

  @override
  State<ModifyDiaryfoodUI> createState() => _ModifyDiaryfoodUIState();
}

class _ModifyDiaryfoodUIState extends State<ModifyDiaryfoodUI> {
  TextEditingController foodShopCtrl = TextEditingController(text: '');
  TextEditingController foodPayCtrl = TextEditingController(text: '');
  TextEditingController foodDateCtrl = TextEditingController(text: '');

  int meal = 1;

  @override
  void initState() {
    foodShopCtrl.text = widget.diaryfood!.foodShopname!;
    foodPayCtrl.text = widget.diaryfood!.foodPay!;
    meal = int.parse(widget.diaryfood!.foodMeal!);
    foodDateCtrl.text = widget.diaryfood!.foodDate!;
    foodProvince = widget.diaryfood!.foodProvince!;

    super.initState();
  }

  // เมธอดแปลงวันที่แบบสากล (ปี ค.ศ. -เดือน ตัวเลข-วัน ตัวเลข) ให้เป็นวันที่แบบไทย (วัน เดือน ปี)
  //                              0123456789
  //                              2023-11-25
  convertToThaiDate(date) {
    String day = date.toString().substring(8, 10);
    String year = (int.parse(date.toString().substring(0, 4)) + 543).toString();
    String month = '';
    int monthTemp = int.parse(date.toString().substring(5, 7));
    switch (monthTemp) {
      case 1:
        month = 'มกราคม';
        break;
      case 2:
        month = 'กุมภาพันธ์';
        break;
      case 3:
        month = 'มีนาคม';
        break;
      case 4:
        month = 'เมษายน';
        break;
      case 5:
        month = 'พฤษภาคม';
        break;
      case 6:
        month = 'มิถุนายน';
        break;
      case 7:
        month = 'กรกฎาคม';
        break;
      case 8:
        month = 'สิงหาคม';
        break;
      case 9:
        month = 'กันยายน';
        break;
      case 10:
        month = 'ตุลาคม';
        break;
      case 11:
        month = 'พฤศจิกายน';
        break;
      default:
        month = 'ธันวาคม';
    }

    return day + ' ' + month + ' พ.ศ. ' + year;
  }

  // เมธอดแสดงปฏิทิน
  showCalendar() async {
    DateTime? foodDatePicker = await DatePicker.showSimpleDatePicker(
      context,
      initialDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      dateFormat: 'dd MMMM yyyy',
      locale: DateTimePickerLocale.th,
      looping: true,
      confirmText: 'ตกลง',
      cancelText: 'ยกเลิก',
      titleText: 'เลือกวันที่กิน',
      itemTextStyle: GoogleFonts.itim(),
      textColor: Colors.green,
      backgroundColor: Colors.green[100],
    );

    setState(() {
      foodDateCtrl.text = foodDatePicker != null
          ? convertToThaiDate(foodDatePicker)
          : foodDateCtrl.text;
    });
  }

  // ประกาศ/สร้างตัวแปรเพื่อเก็บข้อมูลรายการที่จะเอาไปใช้กับ DropdownButton
  List<DropdownMenuItem<String>> items = [
    'กรุงเทพมหานคร',
    'กระบี่',
    'กาญจนบุรี',
    'กาฬสินธุ์',
    'กำแพงเพชร',
    'ขอนแก่น',
    'จันทบุรี',
    'ฉะเชิงเทรา',
    'ชลบุรี',
    'ชัยนาท',
    'ชัยภูมิ',
    'ชุมพร',
    'เชียงราย',
    'เชียงใหม่',
    'ตรัง',
    'ตราด',
    'ตาก',
    'นครนายก',
    'นครปฐม',
    'นครพนม',
    'นครราชสีมา',
    'นครศรีธรรมราช',
    'นครสวรรค์',
    'นนทบุรี',
    'นราธิวาส',
    'น่าน',
    'บึงกาฬ',
    'บุรีรัมย์',
    'ปทุมธานี',
    'ประจวบคีรีขันธ์',
    'ปราจีนบุรี',
    'ปัตตานี',
    'พระนครศรีอยุธยา',
    'พะเยา',
    'พังงา',
    'พัทลุง',
    'พิจิตร',
    'พิษณุโลก',
    'เพชรบุรี',
    'เพชรบูรณ์',
    'แพร่',
    'ภูเก็ต',
    'มหาสารคาม',
    'มุกดาหาร',
    'แม่ฮ่องสอน',
    'ยโสธร',
    'ยะลา',
    'ร้อยเอ็ด',
    'ระนอง',
    'ระยอง',
    'ราชบุรี',
    'ลพบุรี',
    'ลำปาง',
    'ลำพูน',
    'เลย',
    'ศรีสะเกษ',
    'สกลนคร',
    'สงขลา',
    'สตูล',
    'สมุทรปราการ',
    'สมุทรสงคราม',
    'สมุทรสาคร',
    'สระแก้ว',
    'สระบุรี',
    'สิงห์บุรี',
    'สุโขทัย',
    'สุพรรณบุรี',
    'สุราษฎร์ธานี',
    'สุรินทร์',
    'หนองคาย',
    'หนองบัวลำภู',
    'อ่างทอง',
    'อำนาจเจริญ',
    'อุดรธานี',
    'อุตรดิตถ์',
    'อุทัยธานี',
    'อุบลราชธานี'
  ]
      .map((e) => DropdownMenuItem<String>(
            value: e,
            child: Text(e),
          ))
      .toList();

  // ประกาศ/สร้างตัวแปรเก็ยจังหวัดที่ผู้ใช้เลือก
  String foodProvince = 'กรุงเทพมหานคร';

  // ตัวแปรเก็บรูปที่เลือกจาก Gallery หรือถ่ายจากกล้อง
  XFile? foodImageSelected;

  // ตัวแปรเก็บรูปภาพที่แปลงเป็น base64 เพื่อส่งไปที่ server
  String? foodImageBase64 = '';

  // เมธอดที่ใช้ในการเปิดกล้อง หรือเปิดแกลอรี่
  openGalleryAndSelectImage() async {
    final photo = await ImagePicker().pickImage(
      source: ImageSource.gallery, //*****
      imageQuality: 75,
    );

    if (photo == null) return;
    foodImageBase64 = base64Encode(File(photo.path).readAsBytesSync());

    setState(() {
      foodImageSelected = photo;
    });
  }

  openCameraAndSelectImage() async {
    final photo = await ImagePicker().pickImage(
      source: ImageSource.camera, //*****
      imageQuality: 75,
    );

    if (photo == null) return;
    foodImageBase64 = base64Encode(File(photo.path).readAsBytesSync());

    setState(() {
      foodImageSelected = photo;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'แก้ไข-ลบ ข้อมูล My Diary Food',
          style: GoogleFonts.itim(),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            // กดแล้วย้อนกลับไปหน้าก่อนหน้า
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.075,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.green),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: foodImageSelected == null
                            ? NetworkImage(
                                Env.domainURL +
                                    'diaryfoodapi/images/' +
                                    widget.diaryfood!.foodImage!,
                              )
                            : FileImage(
                                File(foodImageSelected!.path),
                              ) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                openCameraAndSelectImage();
                              },
                              leading: Icon(
                                Icons.camera_alt,
                                color: Colors.red,
                              ),
                              title: Text(
                                'Open Camera',
                                style: GoogleFonts.itim(),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              height: 5.0,
                            ),
                            ListTile(
                              onTap: () {
                                Navigator.pop(context);
                                openGalleryAndSelectImage();
                              },
                              leading: Icon(
                                Icons.image,
                                color: Colors.green,
                              ),
                              title: Text(
                                'Open Gallery',
                                style: GoogleFonts.itim(),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ร้านอาหาร',
                    style: GoogleFonts.itim(
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
                  top: MediaQuery.of(context).size.height * 0.01,
                ),
                child: TextField(
                  controller: foodShopCtrl,
                  decoration: InputDecoration(
                    hintText: 'ป้อนชื่อร้านอาหาร',
                    hintStyle: GoogleFonts.itim(
                      color: Colors.grey[400],
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.01,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ค่าใช้จ่าย',
                    style: GoogleFonts.itim(
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
                  top: MediaQuery.of(context).size.height * 0.01,
                ),
                child: TextField(
                  controller: foodPayCtrl,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'ป้อนค่าใช้จ่าย',
                    hintStyle: GoogleFonts.itim(
                      color: Colors.grey[400],
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.01,
                  bottom: MediaQuery.of(context).size.height * 0.01,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'อาหารมื้อ',
                    style: GoogleFonts.itim(
                      color: Colors.grey[800],
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    onChanged: (int? value) {
                      setState(() {
                        meal = value!;
                      });
                    },
                    value: 1,
                    groupValue: meal,
                    activeColor: Colors.green,
                  ),
                  Text(
                    'เช้า',
                    style: GoogleFonts.itim(
                      color: Colors.grey[800],
                    ),
                  ),
                  Radio(
                    onChanged: (int? value) {
                      setState(() {
                        meal = value!;
                      });
                    },
                    value: 2,
                    groupValue: meal,
                    activeColor: Colors.green,
                  ),
                  Text(
                    'กลางวัน',
                    style: GoogleFonts.itim(
                      color: Colors.grey[800],
                    ),
                  ),
                  Radio(
                    onChanged: (int? value) {
                      setState(() {
                        meal = value!;
                      });
                    },
                    value: 3,
                    groupValue: meal,
                    activeColor: Colors.green,
                  ),
                  Text(
                    'เย็น',
                    style: GoogleFonts.itim(
                      color: Colors.grey[800],
                    ),
                  ),
                  Radio(
                    onChanged: (int? value) {
                      setState(() {
                        meal = value!;
                      });
                    },
                    value: 4,
                    groupValue: meal,
                    activeColor: Colors.green,
                  ),
                  Text(
                    'ว่าง',
                    style: GoogleFonts.itim(
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.01,
                  bottom: MediaQuery.of(context).size.height * 0.01,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'วันที่กิน',
                    style: GoogleFonts.itim(
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
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: foodDateCtrl,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: 'เลือกวันที่กิน',
                          hintStyle: GoogleFonts.itim(
                            color: Colors.grey[400],
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showCalendar();
                      },
                      icon: Icon(
                        Icons.calendar_month,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.01,
                  bottom: MediaQuery.of(context).size.height * 0.01,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'จังหวัด',
                    style: GoogleFonts.itim(
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
                  top: MediaQuery.of(context).size.height * 0.01,
                  bottom: MediaQuery.of(context).size.height * 0.01,
                ),
                child: Container(
                  padding: EdgeInsets.all(9.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    items: items,
                    onChanged: (String? value) {
                      setState(() {
                        foodProvince = value!;
                      });
                    },
                    value: foodProvince,
                    underline: SizedBox(),
                    style: GoogleFonts.itim(
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  top: MediaQuery.of(context).size.height * 0.01,
                  bottom: MediaQuery.of(context).size.height * 0.01,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ตำแหน่งที่ตั้ง',
                    style: GoogleFonts.itim(
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
                  top: MediaQuery.of(context).size.height * 0.01,
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                    ),
                  ),
                  child: Image.asset(
                    'assets/images/map.png',
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.025,
              ),
              ElevatedButton(
                onPressed: () {
                  // Validate หน้าจอก่อนส่งข้อมูลไปบันทึกเก็บไว้ที่ Server
                  if (foodShopCtrl.text.trim().length == 0) {
                    showWarningDialog(context, 'กรุณาป้อนชื่อร้านด้วยครับ');
                  } else if (foodPayCtrl.text.trim().length == 0) {
                    showWarningDialog(context, 'กรุณาป้อนค่าใช้จ่ายด้วยครับ');
                  } else if (foodDateCtrl.text.trim().length == 0) {
                    showWarningDialog(context, 'กรุณาเลือกวันที่กินด้วยครับ');
                  } else {
                    // โค้ดส่วนของการส่งข้อมูลไปบันทึกที่ Server
                    Diaryfood diaryfood = Diaryfood(
                      foodId: widget.diaryfood!.foodId!,
                      foodShopname: foodShopCtrl.text.trim(),
                      // foodImage: foodImageBase64,
                      foodImage: foodImageBase64 == '' ? '' : foodImageBase64,
                      foodPay: foodPayCtrl.text.trim(),
                      foodMeal: meal.toString(),
                      foodDate: foodDateCtrl.text.trim(),
                      foodProvince: foodProvince,
                    );

                    CallApi.callAPIUpdateDiaryfood(diaryfood)
                        .then((value) => showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'ผลการทำงาน',
                                    style: GoogleFonts.itim(),
                                  ),
                                ),
                                content: Text(
                                  'บันทึกการแก้ไขเรียบร้อยแล้ว',
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
                                            borderRadius: BorderRadius.circular(
                                                15.0), // กำหนดรัศมีของมุมโค้ง
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
                            ))
                        .then((value) => Navigator.pop(context));
                  }
                },
                child: Text(
                  'บันทึกแก้ไขข้อมูลการกิน',
                  style: GoogleFonts.itim(),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.8,
                    MediaQuery.of(context).size.height * 0.07,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15.0), // กำหนดรัศมีของมุมโค้ง
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              ElevatedButton(
                onPressed: () {
                  Diaryfood diaryfood = Diaryfood(
                    foodId: widget.diaryfood!.foodId!,
                  );

                  CallApi.callAPIDeleteDiaryfood(diaryfood)
                      .then((value) => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'ผลการทำงาน',
                                  style: GoogleFonts.itim(),
                                ),
                              ),
                              content: Text(
                                'ลบข้อมูลเรียบร้อยแล้ว',
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
                                          borderRadius: BorderRadius.circular(
                                              15.0), // กำหนดรัศมีของมุมโค้ง
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
                          ))
                      .then((value) => Navigator.pop(context));
                },
                child: Text(
                  'ลบข้อมูล',
                  style: GoogleFonts.itim(),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.8,
                    MediaQuery.of(context).size.height * 0.07,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.025,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
