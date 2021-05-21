class StatsModel {
  StatsModel({required this.name, required this.baseStats});

  factory StatsModel.fromMap(Map<String, dynamic> map) {
    return StatsModel(
      name: map['name'] as String,
      baseStats: map['baseStats'] as int,
    );
  }

  late final String name;
  late final int baseStats;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'baseStats': baseStats,
    };
  }

  @override
  String toString() {
    return 'Stats{name: $name, baseStats: $baseStats}';
  }
}
