// import 'dart:convert';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:internp/Widgets/ExpandableWidget.dart';
// import 'package:read_more_text/read_more_text.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// class ContainerWidget extends StatefulWidget {
//   final String title;
//   final String subtitle;
//   final String imageI;
//   final String description;
//   final bool ans;
//
//   const ContainerWidget({
//     Key? key,
//     required this.title,
//     required this.subtitle,
//     required this.imageI,
//     required this.description,
//     required this.ans,
//   }) : super(key: key);
//
//   @override
//   State<ContainerWidget> createState() => _ContainerWidgetState();
// }
//
// class _ContainerWidgetState extends State<ContainerWidget> {
//    late Uint8List bytes;
//
//   @override
//   Widget build(BuildContext context) {
//     if(widget.ans == false)
//       {
//          bytes = base64Decode(widget.imageI);
//       }
//     Object imageProvider = widget.ans  ? NetworkImage(widget.imageI)  : MemoryImage(bytes);         // Otherwise, use MemoryImage
//     final width = MediaQuery.of(context).size.width * 1;
//     final height = MediaQuery.of(context).size.height * 1;
//     return Column(
//       children: [
//         ListTile(
//           leading: CircleAvatar(
//             radius: height * 0.05,
//             child: Container(
//               decoration: BoxDecoration(
//                 image: DecorationImage(
//                   image:imageProvider,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//           ),
//           trailing: PopupMenuButton<String>(
//             icon: Icon(Icons.more_horiz),
//             onSelected: (value) async {
//               if (value == 'Save') {
//                 await saveToSharedPreferences();
//               }
//             },
//             itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
//               const PopupMenuItem<String>(
//                 value: 'Save',
//                 child: Text('Save'),
//               ),
//             ],
//           ),
//           title: Text(widget.title),
//           subtitle: Text(widget.subtitle),
//         ),
//         Container(
//           height: height * 0.4,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: NetworkImage(widget.imageI),
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         ExpandableWidget(content: widget.description),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             IconButton(
//               icon: Icon(Icons.thumb_up),
//               onPressed: () {
//                 // Add like functionality
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.comment),
//               onPressed: () {
//                 // Add comment functionality
//               },
//             ),
//             IconButton(
//               icon: Icon(Icons.share),
//               onPressed: () {
//                 // Add share functionality
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Future<void> saveToSharedPreferences() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     // Retrieve the existing container data from shared preferences
//     String? jsonData = prefs.getString('containerData');
//     List<Map<String, String>> existingDataList = [];
//
//     // Check if there's existing data and convert it to a list of maps
//     if (jsonData != null) {
//       // Convert the JSON string to a dynamic object
//       dynamic decodedData = jsonDecode(jsonData);
//
//       // If the decoded data is a list, cast it properly
//       if (decodedData is List) {
//         // Cast each element of the list to Map<String, String>
//         existingDataList = decodedData.cast<Map<String, dynamic>>().map((map) => map.cast<String, String>()).toList();
//       }
//       // If the decoded data is a map (only one item), wrap it in a list
//       else if (decodedData is Map) {
//         existingDataList = [Map<String, String>.from(decodedData.cast<String, dynamic>())];
//       }
//     }
//     final http.Response response = await http.get(Uri.parse(widget.imageI));
//     String? base64 = base64Encode(response.bodyBytes);
//
//     // Create a map containing the data for the new post
//     Map<String, String> newDataMap = {
//       'title': widget.title,
//       'subtitle': widget.subtitle,
//
//       'imageI':base64,
//       'description': widget.description,
//     };
//
//     // Append the new post data to the existing list
//     existingDataList.add(newDataMap);
//
//     // Convert the updated list to a JSON string and save it to shared preferences
//     await prefs.setString('containerData', jsonEncode(existingDataList));
//     print('Data saved to shared preferences');
//   }
// }
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:internp/Widgets/ExpandableWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContainerWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imageI;
  final String description;
  final bool ans;
  final bool isliked ;
  final List<String> comment;
  final String? eventCategory ;
  final String? userid;
  final String? eventStartAt ;
  final String? eventid ;


  const ContainerWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imageI,
    required this.description,
    required this.ans,
    required this.isliked,
    required this.comment,
     this.userid,
     this.eventCategory,
    this.eventStartAt,
     this.eventid,


  }) : super(key: key);

  @override
  State<ContainerWidget> createState() => _ContainerWidgetState();
}

class _ContainerWidgetState extends State<ContainerWidget> {
  late ImageProvider imageProvider;
  TextEditingController commentController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  List<String> comments = [];
 // List<String> cment =[];
  bool isLiked = false;
  @override
  void initState() {
    super.initState();
    _loadImageProvider();
    _loadComments();
    _loadLikes();
  }

  void _loadComments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? commentsJson = prefs.getString('comments_${widget.eventid}');
    if (commentsJson != null) {
      setState(() {
        comments = jsonDecode(commentsJson).cast<String>();
      });
    }
  }

  void _loadLikes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLiked = prefs.getBool('isLiked_${widget.eventid}');
    if (isLiked != null) {
      setState(() {
        this.isLiked = isLiked;
      });
    }
  }

  void _saveComment(String comment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    comments.add(comment);
    await prefs.setString('comments_${widget.eventid}', jsonEncode(comments));
  }

  void _toggleLike() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool newIsLiked = !isLiked;
    setState(() {
      isLiked = newIsLiked;
    });
    await prefs.setBool('isLiked_${widget.eventid}', newIsLiked);
  }
  void _loadImageProvider() {
    if (widget.ans) {
      imageProvider = NetworkImage(widget.imageI);
    } else {
      final bytes = base64Decode(widget.imageI);
      imageProvider = MemoryImage(bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final height = MediaQuery
        .of(context)
        .size
        .height;
    return Column(
      children: [
        ListTile(
          tileColor: Colors.grey[200],
          leading: CircleAvatar(
            radius: height * 0.04,
            backgroundImage: imageProvider,

          ),
          trailing: PopupMenuButton<String>(
            icon: Icon(Icons.more_horiz ,size: height*0.03,),
            onSelected: (value) async {
              if (value == 'Save') {
                await saveToSharedPreferences();
              }
            },
            itemBuilder: (BuildContext context) =>
            <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Save',
                child: Text('Save'),
              ),
            ],
          ),
          title: Text(widget.title ,style: TextStyle(fontSize: height*0.025),),
          subtitle: Text(widget.subtitle,style: TextStyle(fontSize: height*0.018)),
        ),
        Container(
          height: height * 0.4,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        ExpandableWidget(content: widget.description),
        Row(

          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.thumb_up, color: isLiked ? Colors.blue : null),
              onPressed: () {
                setState(() {


                  saveDToSharedPreferences();
                  isLiked = !isLiked;

                });
              },
            ),


            IconButton(
              icon: Icon(Icons.comment),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery
                              .of(context)
                              .viewInsets
                              .bottom,
                        ),
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0),
                              child: Text(
                                'Comments',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            // Previous comments


                            ...comments.map((comment) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Text(comment),
                            )).toList(),
                            SizedBox(height: 16.0),
                            // Add comment button
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SingleChildScrollView(
                                        child: Container(
                                          padding: EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Add Comment',
                                                style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 16.0),
                                              // Name text field
                                              TextField(
                                                controller: nameController,
                                                decoration: InputDecoration(
                                                  labelText: 'Name',
                                                ),
                                              ),
                                              SizedBox(height: 16.0),
                                              // Comment text field
                                              TextField(
                                                controller: commentController,
                                                decoration: InputDecoration(
                                                  labelText: 'Comment',
                                                ),
                                              ),
                                              SizedBox(height: 16.0),
                                              // Add comment button
                                              Align(
                                                alignment: Alignment
                                                    .bottomCenter,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      // Add new comment
                                                      String name = nameController
                                                          .text;
                                                      String newComment = '$name: ${commentController
                                                          .text}';
                                                      if (newComment
                                                          .isNotEmpty) {
                                                        comments.add(
                                                            newComment);
                                                        // Save comments to SharedPreferences
                                                        // saveComments();
                                                        commentController
                                                            .clear();
                                                        nameController.clear();
                                                      }

                                                      // Close the text field modal
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Text('Add Comment'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text('Add Comment'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),


            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                // Add share functionality
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<void> saveToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the existing container data from shared preferences
    String? jsonData = prefs.getString('containerData');
    List<Map<String, String>> existingDataList = [];

    // Check if there's existing data and convert it to a list of maps
    if (jsonData != null) {
      // Convert the JSON string to a dynamic object
      dynamic decodedData = jsonDecode(jsonData);

      // If the decoded data is a list, cast it properly
      if (decodedData is List) {
        // Cast each element of the list to Map<String, String>
        existingDataList = decodedData
            .cast<Map<String, dynamic>>()
            .map((map) => map.cast<String, String>())
            .toList();
      }
      // If the decoded data is a map (only one item), wrap it in a list
      else if (decodedData is Map) {
        existingDataList = [
          Map<String, String>.from(decodedData.cast<String, dynamic>())
        ];
      }
    }
    final http.Response response = await http.get(Uri.parse(widget.imageI));
    String? base64 = base64Encode(response.bodyBytes);

    // Create a map containing the data for the new post
    Map<String, String> newDataMap = {
      'title': widget.title,
      'subtitle': widget.subtitle,
      'imageI': base64!,
      'description': widget.description,
      'isLiked' : widget.isliked.toString(), // Convert boolean to string
      'comments' : jsonEncode(widget.comment),

    };

    // Append the new post data to the existing list
    existingDataList.add(newDataMap);

    // Convert the updated list to a JSON string and save it to shared preferences
    await prefs.setString('containerData', jsonEncode(existingDataList));
    print('Data saved to shared preferences');
  }


  Future<void> saveDToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the existing container data from shared preferences
    String? jsonData = prefs.getString('savedData');
    List<Map<String, String>> existingDataList = [];

    // Check if there's existing data and convert it to a list of maps
    if (jsonData != null) {
      // Convert the JSON string to a dynamic object
      dynamic decodedData = jsonDecode(jsonData);

      // If the decoded data is a list, cast it properly
      if (decodedData is List) {
        // Cast each element of the list to Map<String, String>
        existingDataList = decodedData
            .cast<Map<String, dynamic>>()
            .map((map) => map.cast<String, String>())
            .toList();
      }
      // If the decoded data is a map (only one item), wrap it in a list
      else if (decodedData is Map) {
        existingDataList = [
          Map<String, String>.from(decodedData.cast<String, dynamic>())
        ];
      }
    }
    final http.Response response = await http.get(Uri.parse(widget.imageI));
    String? base64 = base64Encode(response.bodyBytes);

    // Create a map containing the data for the new post
    Map<String, String> newDataMap = {
      'title': widget.title,
      'subtitle': widget.subtitle,
      'imageI': base64!,
      'description': widget.description,
      'isLiked' : widget.isliked.toString(), // Convert boolean to string
      'comments' : jsonEncode(widget.comment),
    };

    // Append the new post data to the existing list
    existingDataList.add(newDataMap);

    // Convert the updated list to a JSON string and save it to shared preferences
    await prefs.setString('savedData', jsonEncode(existingDataList));
    print('Data saved to shared preferences');
  }

}