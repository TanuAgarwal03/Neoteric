class SliderModel{
  String? image;

  SliderModel({this.image});

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      image: json['Image'].toString(),
    );
  }

}