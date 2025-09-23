class RecipeStep {
  final String id;
  final String title;
  final String? description;
  final int stepNumber;

  const RecipeStep({
    required this.id,
    required this.title,
    required this.stepNumber,
    this.description,
  });

  RecipeStep copyWith({
    String? id,
    String? title,
    String? description,
    int? stepNumber,
  }) {
    return RecipeStep(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      stepNumber: stepNumber ?? this.stepNumber,
    );
  }

  toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'stepNumber': stepNumber,
  };

  factory RecipeStep.fromJson(Map<String, dynamic> json) => RecipeStep(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    stepNumber: json['stepNumber'],
  );

  @override
  String toString() =>
      'RecipeStep(id: $id, title: $title, description: $description, stepNumber: $stepNumber)';
}
