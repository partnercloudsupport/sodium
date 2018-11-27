class Achievement {
  final int id;
  final int points;
  final bool unlocked;
  final String name;
  final String description;

  Achievement({
    this.id,
    this.points = 0,
    this.unlocked = false,
    this.name,
    this.description,
  });

  @override
  String toString() {
    return 'Achievement{id: $id, points: $points, unlocked: $unlocked, name: $name, description: $description}';
  }
}
