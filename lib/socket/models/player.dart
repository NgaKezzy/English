class Player {
  final int id;
  final String name;
  final String avatar;
  final bool isMaster;
  final bool isReady;
  Player({
    required this.id,
    required this.name,
    required this.avatar,
    required this.isMaster,
    this.isReady = false,
  });
}
