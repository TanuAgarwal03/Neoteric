
class ProfileImageModel {
  bool? status;
  List<ProfileDatum>? profileData;
  String? message;

  ProfileImageModel({
    this.status,
    this.profileData,
    this.message,
  });

  factory ProfileImageModel.fromJson(Map<String, dynamic> json) => ProfileImageModel(
    status: json["status"],
    profileData: json["profileData"] == null ? [] : List<ProfileDatum>.from(json["profileData"]!.map((x) => ProfileDatum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "profileData": profileData == null ? [] : List<dynamic>.from(profileData!.map((x) => x.toJson())),
    "message": message,
  };
}

class ProfileDatum {
  String? custmerId;
  String? image;

  ProfileDatum({
    this.custmerId,
    this.image,
  });

  factory ProfileDatum.fromJson(Map<String, dynamic> json) => ProfileDatum(
    custmerId: json["Custmer ID"],
    image: json["Image"],
  );

  Map<String, dynamic> toJson() => {
    "Custmer ID": custmerId,
    "Image": image,
  };
}
