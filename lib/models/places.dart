class Place {
  final String name;

  Place({
    required this.name,
  });

  Place.fromJson(Map<dynamic, dynamic> parsedJson)
      : name = parsedJson['name'];
}
