class PropertyTypeData {
  late final String name;


  PropertyTypeData({
    required this.name,

  });

  factory PropertyTypeData.fromJson(Map<String, dynamic> json) {
    return PropertyTypeData(
      name: json['Name'],

    );
  }
}