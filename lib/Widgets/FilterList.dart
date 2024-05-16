
import 'package:flutter/material.dart';
import 'package:internp/Widgets/ContainerWidget.dart';
import 'package:internp/viewModel/Viewmodel.dart';

class FilteredPostsPage extends StatefulWidget {
  final List<String> titles;
  final String apptitle;

  FilteredPostsPage({required this.titles, required this.apptitle});

  @override
  _FilteredPostsPageState createState() => _FilteredPostsPageState();
}

class _FilteredPostsPageState extends State<FilteredPostsPage> {
  String? _selectedTitle;

  @override
  void initState() {
    super.initState();
    if (widget.titles.isNotEmpty) {
      _selectedTitle = widget.titles.first;
    }
  }

  @override
  Widget build(BuildContext context) {

    List<String> uniqueTitles = widget.titles.toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.apptitle),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: _selectedTitle,
            onChanged: (String? newValue) {
              setState(() {
                _selectedTitle = newValue;
              });

              print(newValue);
            },
            items: uniqueTitles.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: FutureBuilder(
              future: ViewModel().fetchApi(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  print("Alright");

                  if (snapshot.hasData) {
                    print(snapshot.data.events.length);
                    return ListView.builder(
                      itemCount: snapshot.data.events.length,
                      itemBuilder: (context, index) {
                        // if (_selectedTitle == null || _selectedTitle == 'All' || _selectedTitle == '') {
                        //   // Show all posts if no specific title is selected
                        //   return ContainerWidget(
                        //     title: snapshot.data.events[index].title,
                        //     subtitle: snapshot.data.events[index].description,
                        //     imageI: snapshot.data.events[index].image[0],
                        //     description: snapshot.data.events[index].eventDescription,
                        //     ans: true,
                        //     isliked: false,
                        //     comment: [],
                        //     userid: snapshot.data.events[index].userId,
                        //     eventCategory: snapshot.data.events[index].eventCategory,
                        //     eventStartAt: snapshot.data.events[index].eventStartAt,
                        //     eventid: snapshot.data.events[index].eventId,
                        //   );
                        // } else {

                          if (widget.apptitle == 'Title' && _selectedTitle == snapshot.data.events[index].title ||
                              widget.apptitle == 'UserId' && _selectedTitle == snapshot.data.events[index].userId ||
                              widget.apptitle == 'Event Category' && _selectedTitle == snapshot.data.events[index].eventCategory ||
                              widget.apptitle == 'EventID' && _selectedTitle == snapshot.data.events[index].eventId ||
                              widget.apptitle == 'Event Start Schedule' && _selectedTitle == snapshot.data.events[index].eventStartAt) {
                            return ContainerWidget(
                              title: snapshot.data.events[index].title,
                              subtitle: snapshot.data.events[index].description,
                              imageI: snapshot.data.events[index].image[0],
                              description: snapshot.data.events[index].eventDescription,
                              ans: true,
                              isliked: false,
                              comment: [],
                              userid: snapshot.data.events[index].userId,
                              eventCategory: snapshot.data.events[index].eventCategory,
                              eventStartAt: snapshot.data.events[index].eventStartAt,
                              eventid: snapshot.data.events[index].eventId,
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        }

                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("Error fetching data"),
                    );
                  }
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
