class ComplaintListModel{
  String? timestamp;
  String? name;
  String? contact;
  String? image;
  String? status;
  String? commetns_from_admin;
  String? service_request_id;
  String? project_id;
  String? request_type;
  String? request_about;
  String? request_category;
  String? narration;
  String? projectName;


  ComplaintListModel(
  {
    this.timestamp,
    this.name,
     this.contact,
     this.service_request_id,
     this.project_id,
     this.request_type,
     this.request_about,
     this.request_category,
     this.narration,
     this.projectName,
    this.image,
    this.status,
    this.commetns_from_admin,
  });



  factory ComplaintListModel.fromJson(Map<String, dynamic> json) {
    return ComplaintListModel(
        timestamp: json['Timestamp'].toString(),
        name: json['Name'].toString(),
        service_request_id: json['Service Request Id'].toString(),
        project_id: json['Project Id'].toString(),
        request_type: json['Request Type'].toString(),
        request_about: json['Request About'].toString(),
        request_category: json['Request Category'].toString(),
        narration: json['Narration'].toString(),
        image: (json['Image']).toString(),

        contact: json['Contact No.'],
      projectName: json['Project Name'],

        status: (json['Status']).toString(),
        commetns_from_admin: json['Comments From Admin'].toString(),








    );
  }



}