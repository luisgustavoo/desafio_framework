class TypesModel {
  TypesModel({required this.slot, required this.name});

  factory TypesModel.fromMap(Map<String, dynamic> map) {
    return TypesModel(
      slot: map['slot'] as int,
      name: map['name'] as String,
    );
  }

  late final int slot;
  late final String name;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'slot': slot,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'Types{slot: $slot, name: $name}';
  }
}
