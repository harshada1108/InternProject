
import 'package:flutter/material.dart';
import 'package:internp/Widgets/ContainerWidget.dart';
import 'package:internp/Widgets/FilterList.dart';
import 'package:internp/Widgets/LikedPage.dart';
import 'package:internp/Widgets/SavedPage.dart';
import 'package:internp/viewModel/Viewmodel.dart';

class MyAppHome extends StatefulWidget {
  @override
  _MyAppHomeState createState() => _MyAppHomeState();
}

class _MyAppHomeState extends State<MyAppHome> {
  List<String> titles = [];
  List<String> events = [];
  List<String> userids = [];
  List<String> eventsdate = [];
  List<String> eventsid = [];
  String searchQuery = '';

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            children: [
              Align(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Filter Options"),
                ),
                alignment: Alignment.center,
              ),
              ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text('Title'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FilteredPostsPage(apptitle: 'Title', titles: titles)),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('UserId'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FilteredPostsPage(apptitle: 'UserID', titles: userids)),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Event Category'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FilteredPostsPage(apptitle: 'Event Category', titles: events)),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('EventId '),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FilteredPostsPage(apptitle: 'EventID', titles: eventsid)),
                      );
                    },
                  ),
                  ListTile(
                    title: Text('Event Start Scehdule'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FilteredPostsPage(apptitle: 'Event Start Schedule', titles: eventsdate)),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              print("Heyyyyyyyyyyyyyyyy");
              _showFilterOptions(context);
            },
          ),
        ],
      ),
    );
  }
//here
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;


    return Scaffold(


      body: Column(
        children: [
          //Divider(height: height*0.01,color: Colors.grey,),
          _buildSearchBar(),
        //  SizedBox(height: height*0.03,child: Container(color: Colors.grey[400],),),
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
                        // Filter posts based on search query
                        titles.add(snapshot.data.events[index].title);
                            events.add(snapshot.data.events[index].eventCategory);
                            userids.add(snapshot.data.events[index].userId);
                            eventsdate.add(snapshot.data.events[index].eventStartAt );
                            eventsid.add(snapshot.data.events[index].eventId);
                        if (searchQuery.isEmpty ||
                            snapshot.data.events[index].title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                            snapshot.data.events[index].eventCategory.toLowerCase().contains(searchQuery.toLowerCase())) {
                          return Column(
                            children: [
                              ContainerWidget(
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
                              ),
                              SizedBox(height: height*0.05,child: Container(color: Colors.grey[400],),)
                            ],
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
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
