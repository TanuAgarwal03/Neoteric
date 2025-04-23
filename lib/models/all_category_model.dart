class AllCategoryModel{

   String? name;
   String? type;

   AllCategoryModel({required this.name, required this.type});

  factory AllCategoryModel.fromJson(Map<String, dynamic> json) {
    return AllCategoryModel(
      name: json['Name'],
      type: json['Type'],
    );
  }

}