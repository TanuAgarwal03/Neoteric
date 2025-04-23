class PaymentPlanModel{
  String? customer_id;
  String? property_id;
  String? payment_id;
  String? date;
  String? Installments;
  String? payment_inr;
  String? payment_percent;
  String? payment_status;
  String? payment_link;
  String? payment_recieve;
  String? comments_from_admin;
  String? payment_receipt;



  PaymentPlanModel({
    this.customer_id,
    this.property_id,
    this.payment_id,
    this.date,
    this.payment_inr,
    this.payment_percent,
    this.payment_status,
    this.payment_link,
    this.payment_recieve,
    this.Installments,
    this.comments_from_admin,
    this.payment_receipt
});






  factory PaymentPlanModel.fromJson(Map<String, dynamic> json) {
    return PaymentPlanModel(

      customer_id: json['Customer Id'],
      property_id: json['Property Id'].toString(),
      payment_id: json['Payment Id'].toString(),
      date: json['Date'].toString(),
      payment_inr: json['Payment(INR)'].toString(),
      Installments: json['Installments'].toString(),
      payment_percent: json['Payment(%)'].toString(),
      payment_status : json['Payment Satus'].toString(),
      payment_link: json['Payment Link'].toString(),
      payment_recieve: json['Payment Recieve'].toString(),
      comments_from_admin: json['Comments From Admin'].toString(),
      payment_receipt: json['Payment Receipt'].toString()

    );
  }




}