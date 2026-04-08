/// A placeholder class that represents an entity or model.
class Cake {
  const Cake({
    required this.title,
    required this.description,
    required this.image,
  });

  final String title;
  final String description;
  final String image;

  factory Cake.fromJson(Map<String, dynamic> json) {
    return Cake(
      title: (json['title'] as String?) ?? '',
      description: (json['desc'] as String?) ?? '',
      image: (json['image'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'desc': description,
      'image': image,
    };
  }
}
