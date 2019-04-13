import 'dart:convert';

Third thirdFromJson(String str) {
  final jsonData = json.decode(str);
  return Third.fromMap(jsonData);
}

String thirdToJson(Third data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Third {
  int nid;
  String Partyname;
  String Colorquantity;
  String Colorprice;
  String Whitequantity;
  String Whiteprice;
  String Totalprice;
  String Paid;

  Third({
    this.nid,
    this.Partyname,
    this.Colorquantity,
    this.Colorprice,
    this.Whitequantity,
    this.Whiteprice,
    this.Totalprice,
    this.Paid,
  });

  factory Third.fromMap(Map<String, dynamic> json) => new Third(
    nid: json["nid"],
    Partyname: json["partyname"],
    Colorquantity: json["colorquantity"],
    Colorprice: json["colorprice"],
    Whitequantity: json["whitequantity"],
    Whiteprice: json["Whiteprice"],
    Totalprice: json["totalprice"],
    Paid: json["Paid"],
  );

  Map<String, dynamic> toMap() => {
    "nid": nid,
    "partyname": Partyname,
    "colorquantity": Colorquantity,
    "colorprice": Colorprice,
    "whitequantity": Whitequantity,
    "whiteprice": Whiteprice,
    "totalprice": Totalprice,
    "paid": Paid,
  };
}
