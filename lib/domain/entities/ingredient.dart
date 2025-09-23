class Ingredient {
  final String id;
  final String name;
  final String? imageUrl;
  final String? description;
  final bool isCustom;

  const Ingredient({
    required this.id,
    required this.name,
    this.imageUrl,
    this.description,
    this.isCustom = false,
  });

  Ingredient copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? description,
    bool? isCustom,
  }) {
    return Ingredient(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  toJson() => {
    'id': id,
    'name': name,
    'imageUrl': imageUrl,
    'description': description,
    'isCustom': isCustom,
  };

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
    id: json['id'],
    name: json['name'],
    imageUrl: json['imageUrl'],
    description: json['description'],
    isCustom: json['isCustom'],
  );

  @override
  String toString() => 'Ingredient(id: $id, name: $name, imageUrl: $imageUrl, description: $description, isCustom: $isCustom)';
}
