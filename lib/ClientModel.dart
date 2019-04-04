import 'dart:convert';

Client clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Client.fromMap(jsonData);
}

String clientToJson(Client data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Client {
  int id;
  String Name;
  String Address;
  String Mobile;

  Client({
    this.id,
    this.Name,
    this.Address,
    this.Mobile,
  });

  factory Client.fromMap(Map<String, dynamic> json) => new Client(
    id: json["id"],
    Name: json["name"],
    Address: json["address"],
    Mobile: json["mobile"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": Name,
    "address": Address,
    "mobile": Mobile,
  };
}