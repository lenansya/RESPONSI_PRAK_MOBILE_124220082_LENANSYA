class Amiibo {
  final String id;
  final String name;
  final String amiiboSeries;
  final String gameSeries;
  final String image;
  final String type;
  final String character;
  final String head;
  final String tail;
  final Map<String, String> releaseDates;

  Amiibo({
    required this.id,
    required this.name,
    required this.amiiboSeries,
    required this.gameSeries,
    required this.image,
    required this.type,
    required this.releaseDates,
    required this.character,
    required this.head,
    required this.tail,
  });

  factory Amiibo.fromJson(Map<String, dynamic> json) {
    return Amiibo(
      id: json["id"] ?? "Unknown ID",
      name: json["name"] ?? "Unknown Character", // Using "name" instead of "character"
      amiiboSeries: json["amiiboSeries"] ?? "Unknown Series",
      gameSeries: json["gameSeries"] ?? "Unknown Game Series", // "gameSeries" key
      image: json["image"] ?? "https://placehold.co/600x400", // Placeholder image
      type: json["type"] ?? "Unknown Type",
      character: json["character"] ?? "Unknown Character",
      head: json["head"] ?? "Unknown Head",
      tail: json["tail"] ?? "Unknown Tail",
      releaseDates: _parseReleaseDates(json["release"]),
    );
  }

  // Helper function to parse release dates
  static Map<String, String> _parseReleaseDates(Map<String, dynamic>? release) {
    if (release == null) {
      return {};
    }
    return {
      "AU": release["au"] ?? "Unknown",
      "EU": release["eu"] ?? "Unknown",
      "JP": release["jp"] ?? "Unknown",
      "NA": release["na"] ?? "Unknown",
    };
  }
}
