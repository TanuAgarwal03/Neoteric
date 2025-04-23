import '../../project_dropdown/project.dart';

class ViewAllPropertiesModel{

  String? mobile_no;
  String? property_id;
  String? project_id;
  String? project_name;
  String? property_type;
  String? unit_no;
  String? area;
  String? parking;
  String? unit_cost;
  String? payment_plan;
  String? agreement;
  String? registry;
  String? rera;
  String? floor;
  String? location;
  String? location_link;
  String? temple;
  String? evcharging;
  String? healthcare;
  String? virtual_tour;
  String? maintenance_agreement;
  ProjectData? projectData;


  ViewAllPropertiesModel(
  {
    this.mobile_no,
    this.property_id,
    this.project_name,
    this.property_type,
    this.unit_no,
    this.temple,
    this.project_id,
    this.evcharging,
    this.healthcare,
    this.area,
    this.parking,
    this.unit_cost,
    this.projectData,
    this.location,
    this.location_link,
    this.payment_plan,
    this.agreement,
    this.virtual_tour,
    this.rera,
    this.registry,
    this.maintenance_agreement,
    this.floor,
});

  factory ViewAllPropertiesModel.fromJson(Map<String, dynamic> json) {
    return ViewAllPropertiesModel(
      mobile_no: json['Customer Id'],
      project_name: json['Project Name'].toString(),
      projectData: json["projectData"] == null ? null : ProjectData.fromJson(json["projectData"]),
      property_id: json['Property ID'].toString(),
      // property_id: json['Property Id']?.toString(),

      unit_no: json['Unit No.'].toString(),
      area: json['Area'].toString(),
      parking: json['Parking'].toString(),
      unit_cost : json['Unit Cost'].toString(),
      payment_plan: json['Payment Plan'].toString(),
      agreement: json['Agreement'].toString(),
      project_id: json['Project ID'].toString(),
      location: json['Location'].toString(),
      location_link: json['Location Link'].toString(),
      virtual_tour: json['Virtual Tour'].toString(),
      rera: json['Rera'].toString(),
      registry: json['Registry'].toString(),
      maintenance_agreement: json['Maintenance Agreement'].toString(),
      property_type: json['Property Type'].toString(),
      floor: json['Floor'].toString(),
      healthcare: json['Healthcare'].toString(),
      evcharging: json['EV Charging'].toString(),
      temple: json['Temple'].toString(),
    );
  }
}