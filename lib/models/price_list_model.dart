class PriceListModel{
  String? name;
  String? type;
  String? image;

  PriceListModel({this.name, this.type, this.image});

  factory PriceListModel.fromJson(Map<String, dynamic> json) {
    return PriceListModel(
      name: json['Name'],
      type: json['Type'],
      image: json['Image'],
    );
  }

}