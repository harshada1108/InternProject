import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:internp/Widgets/ContainerWidget.dart'; // Import your ContainerWidget
import 'package:shared_preferences/shared_preferences.dart';

class SavedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Posts '),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: getContainerDataFromSharedPreferences(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final List<Map<String, String>> containerDataList = snapshot.data!;
            if (containerDataList.isEmpty) {
              return Center(
                child: Text('No data available.'),
              );
            } else {
              return ListView.builder(
                itemCount: containerDataList.length,
                itemBuilder: (context, index) {
                  final containerData = containerDataList[index];
                  final List<String> comments = (containerData['comments'] != null)
                      ? List<String>.from(jsonDecode(containerData['comments']!))
                      : [];
                  return ContainerWidget(
                    title: containerData['title']!,
                    subtitle: containerData['subtitle']!,
                    imageI: containerData['imageI']!,
                    description: containerData['description']!,
                    ans : false,
                    isliked: containerData['isLiked'] == 'true', // Convert to boolean

                    comment:comments,

                  );
                },
              );
            }
          } else {
            return Center(
              child: Text('No data available.'),
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, String>>> getContainerDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('containerData');
    if (jsonData != null) {
      List<dynamic> decodedData = jsonDecode(jsonData);
      List<Map<String, String>> containerDataList = [];
      for (var item in decodedData) {
        if (item is Map<String, dynamic>) {
          containerDataList.add(item.cast<String, String>());
        }
      }
      return containerDataList;
    } else {
      throw Exception('No data found in shared preferences');
    }
  }
}
