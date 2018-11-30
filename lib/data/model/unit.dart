class Unit {
  final String name;
  final double multiplier;

  Unit({
    this.name,
    this.multiplier = 1,
  });

  @override
  String toString() {
    return 'Unit{name: $name, multiplier: $multiplier}';
  }
}
