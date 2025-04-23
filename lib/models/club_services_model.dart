class ClubServicesModel{
  String? name;
  String? type;
  String? image;
  bool? isSelected;

  ClubServicesModel({this.name, this.type, this.image, this.isSelected = false});

  factory ClubServicesModel.fromJson(Map<String, dynamic> json) {
    return ClubServicesModel(
      name: json['Name'],
      type: json['Type'],
      image: json['Image'],

    );
  }




}