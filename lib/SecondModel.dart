import 'dart:convert';

Second secondFromJson(String str) {
  final jsonData = json.decode(str);
  return Second.fromMap(jsonData);
}

String secondToJson(Second data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Second {
  int id;
  String Userdetails;
  String Quantity;
  String Price;
  String Totalprice;

  Second({
    this.id,
    this.Userdetails,
    this.Quantity,
    this.Price,
    this.Totalprice,
  });

  factory Second.fromMap(Map<String, dynamic> json) => new Second(
        id: json["id"],
        Userdetails: json["userdetails"],
        Quantity: json["quantity"],
        Price: json["price"],
        Totalprice: json["totalprice"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "userdetails": Userdetails,
        "quantity": Quantity,
        "price": Price,
        "totalprice": Totalprice,
      };
}
