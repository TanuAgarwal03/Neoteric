class ProjectData {
  late final String name;
  late final String project_id;
  late final String image;
  late final String propertyPhotos;
  late final String constructionUpadates;

  ProjectData({
    required this.name,
    required this.project_id,
    required this.image,
    required this.propertyPhotos,
    required this.constructionUpadates,
  });

  factory ProjectData.fromJson(Map<String, dynamic> json) {
    return ProjectData(
      name: json['Name'],
      image: json['Image'],
      project_id: json['Project ID'],
      propertyPhotos: json['Property Photos'],
      constructionUpadates: json['Construction Upadates'],
    );
  }
}