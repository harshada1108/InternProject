// import 'dart:convert';
//
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:internp/viewModel/fetchmodel.dart';
//
// class fetchImageApi {
//   Future<EventModel> fetchApi() async {
//     String url = "http://post-api-omega.vercel.app/api/posts?page=1";
//
//     try {
//       final response = await http.get(Uri.parse(url));
//
//       if (kDebugMode) {
//         print(response.body);
//       }
//
//       if (response.statusCode == 200) {
//         final body = jsonDecode(response.body);
//
//         return EventModel.fromJson(body);
//       } else {
//         throw Exception('Failed to fetch data: ${response.statusCode}');
//       }
//     } catch (e) {
//       print("Error occurred: $e");
//       throw Exception(); // Rethrow the exception for handling elsewhere if needed
//     }
//   }
// }
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:internp/viewModel/fetchmodel.dart';

class fetchImageApi {
  int _currentPage = 1;

  Future<EventModel> fetchApi() async {
    String url = "http://post-api-omega.vercel.app/api/posts?page=$_currentPage";

    try {
      final response = await http.get(Uri.parse(url));

      if (kDebugMode) {
        print(response.body);
      }

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        return EventModel.fromJson(body);
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception(); // Rethrow the exception for handling elsewhere if needed
    }
  }

  Future<EventModel> fetchMoreData() async {
    _currentPage++; // Increment the page number
    String url = "http://post-api-omega.vercel.app/api/posts?page=$_currentPage";

    try {
      final response = await http.get(Uri.parse(url));

      if (kDebugMode) {
        print(response.body);
      }

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        return EventModel.fromJson(body);
      } else {
        throw Exception('Failed to fetch more data: ${response.statusCode}');
      }
    } catch (e) {
      print("Error occurred: $e");
      throw Exception(); // Rethrow the exception for handling elsewhere if needed
    }
  }
}