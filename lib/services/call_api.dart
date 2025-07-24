// ไฟล์นี้เป็นไฟล์เรียกใช้ Api ต่างๆ

// ignore_for_file: unused_import

import 'dart:convert';
import 'package:my_diaryfood_app/models/diaryfood.dart';
import 'package:http/http.dart' as http;
import 'package:my_diaryfood_app/models/member.dart';
import 'package:my_diaryfood_app/utils/env.dart';

class CallApi {
  // เมธอดเรียกใช้ API : getall --------------------------------------------
  static Future<List<Diaryfood>> callAPIGetAllDiaryfood() async {
    // เรียกใช้ API
    final response = await http.get(
      Uri.parse(Env.domainURL + '/diaryfoodapi/getall'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // เอาข้อมูลที่ส่งกลับมาเป็น JSON แปลงเป็นข้อมูลที่จะนำมาใช้ในแอป เก็ยไว้ในตัวแปร
      final responseData = jsonDecode(response.body);

      // แปลงข้อมูลให้เป็น List และเก็บในตัวแปร List
      final diaryfoodDataList = await responseData.map<Diaryfood>((json) {
        return Diaryfood.fromJson(json);
      }).toList();

      return diaryfoodDataList;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  // เมธอดเรียกใช้ API : insert --------------------------------------------
  static Future<String> callAPIInsertDiaryfood(Diaryfood diaryfood) async {
    // เรียกใช้ API
    final response = await http.post(
      Uri.parse(Env.domainURL + '/diaryfoodapi/insert'),
      body: jsonEncode(diaryfood.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // เอาข้อมูลที่ส่งกลับมาเป็น JSON แปลงเป็นข้อมูลที่จะนำมาใช้ในแอป เก็ยไว้ในตัวแปร
      final responseData = jsonDecode(response.body);
      // print(responseData['message']);

      // ส่งค่าข้อมูลที่ส่งกลับมาไปที่จุดเรียกใช้เมธอด
      return responseData['message']!;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  // เมธอดเรียกใช้ API : update --------------------------------------------
  static Future<String> callAPIUpdateDiaryfood(Diaryfood diaryfood) async {
    // เรียกใช้ API
    final response = await http.post(
      Uri.parse(Env.domainURL + '/diaryfoodapi/update'),
      body: jsonEncode(diaryfood.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // เอาข้อมูลที่ส่งกลับมาเป็น JSON แปลงเป็นข้อมูลที่จะนำมาใช้ในแอป เก็ยไว้ในตัวแปร
      final responseData = jsonDecode(response.body);

      // ส่งค่าข้อมูลที่ส่งกลับมาไปที่จุดเรียกใช้เมธอด
      return responseData['message'];
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  // เมธอดเรียกใช้ API : delete --------------------------------------------
  static Future<String> callAPIDeleteDiaryfood(Diaryfood diaryfood) async {
    // เรียกใช้ API
    final response = await http.post(
      Uri.parse(Env.domainURL + '/diaryfoodapi/delete'),
      body: jsonEncode(diaryfood.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // เอาข้อมูลที่ส่งกลับมาเป็น JSON แปลงเป็นข้อมูลที่จะนำมาใช้ในแอป เก็ยไว้ในตัวแปร
      final responseData = jsonDecode(response.body);

      // ส่งค่าข้อมูลที่ส่งกลับมาไปที่จุดเรียกใช้เมธอด
      return responseData['message'];
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  // เมธอดเรียกใช้ API : checklogin --------------------------------------------
  static Future<Member> callAPIChecklogin(Member member) async {
    // เรียกใช้ API
    final response = await http.post(
      Uri.parse(Env.domainURL + '/diaryfoodapi/checklogin'),
      body: jsonEncode(member.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // เอาข้อมูลที่ส่งกลับมาเป็น JSON แปลงเป็นข้อมูลที่จะนำมาใช้ในแอป เก็ยไว้ในตัวแปร
      final responseData = jsonDecode(response.body);

      // ส่งค่าข้อมูลที่ส่งกลับมาไปที่จุดเรียกใช้เมธอด
      return Member.fromJson(responseData);
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
