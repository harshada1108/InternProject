class EventModel {
   List<Event>? events;

  EventModel({ this.events});

  EventModel.fromJson(List<dynamic> json) {
    events = json.map((e) => Event.fromJson(e)).toList();
    print("YAaaaaaaaaaaaaaahppppppppp");
    //print(events?[0].description);
  }
}

class Event {
   String? id;


   String? userId;
   String? description;
   String? title;
   List<String>? image;
   List<String>? tags;
   String? eventCategory;
   String? eventStartAt;
  String? eventEndAt;
  String? eventId;
  bool? registrationRequired;
  String? eventDescription;
  int? likes;
  List<dynamic>? comments;
   String? createdAt;
   int? v;

  Event({
     this.id,
    this.userId,
     this.description,
     this.title,
    this.image,
     this.tags,
     this.eventCategory,
     this.eventStartAt,
    this.eventEndAt,
    this.eventId,
    this.registrationRequired,
    this.eventDescription,
    this.likes,
     this.comments,
    this.createdAt,
     this.v,
  });

  Event.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    description = json['description'];
    title = json['title'];
    image = json['image'].cast<String>();
    tags = json['tags'].cast<String>();
    eventCategory = json['eventCategory'];
    eventStartAt = json['eventStartAt'];
    eventEndAt = json['eventEndAt'];
    eventId = json['eventId'];
    registrationRequired = json['registrationRequired'];
    eventDescription = json['eventDescription'];
    likes = json['likes'];
    comments = json['comments'];
    createdAt = json['createdAt'];
    v = json['__v'];
  }
}
