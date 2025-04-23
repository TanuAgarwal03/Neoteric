class BookingListModel{
  String? timestamp;
  String? booking_number;
  String? property_booking_name;
  String? name;
  String? contact_no;
  //String? person_adult;
 // String? person_child;
  String? club_services;
  String? date;
  String? time;
  String? children;
  String? adult;
 // String? to;
  String? status;
  String? comments_from_admin;


  BookingListModel(
  {this.timestamp,
    this.booking_number,
    this.property_booking_name,
    this.name,
    this.contact_no,
  //  this.person_adult,
   // this.person_child,
    this.club_services,
    this.date,
    this.adult,
    this.children,
    this.time,
  //  this.to,
    this.status,
    this.comments_from_admin});


  factory BookingListModel.fromJson(Map<String, dynamic> json) {
    return BookingListModel(
      timestamp: json['Timestamp'],
      booking_number: json['Booking Number'],
      property_booking_name: json['Prooperty Booking Name'],
      name: json['Name'],
      contact_no: json['Contact No.'],
     // person_adult: json['Person Adult'],
     // person_child : json['Person Child'],
      club_services: json['Club Services'],
      date: json['Date'],
      time: json['Booking Time'],
      children: json['Person Child'],
      adult: json['Person Adult'],
     // to: json['To'],
      status: json['Status'],
      comments_from_admin: json['commetns from admin'],
    );



  }




}