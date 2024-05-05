// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:famitree/src/core/utils/converter.dart';

class Place extends Equatable {
  final String id;
  final String name;
  final String address;
  final int quantity;
  final bool deleted;
  const Place({
    required this.id,
    required this.name,
    required this.address,
    required this.quantity,
    this.deleted = false,
  });

  @override
  List<Object> get props => [id, name, address, quantity, deleted];

  Place copyWith({
    String? id,
    String? name,
    String? address,
    int? quantity,
    bool? deleted,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      quantity: quantity ?? this.quantity,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  bool get stringify => true;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'address': address,
      'quantity': quantity,
      'deleted': deleted
    };
  }

  factory Place.fromJSon({
    String? id, 
    required Map<String, dynamic> json
  }) {
    return Place(
      id: id ?? cvToString(json['id']),
      name: cvToString(json['name']),
      address: cvToString(json['address']),
      deleted: cvToBool(json['deleted']),
      quantity: cvToInt(json['quantity']),
    );
  }
}
