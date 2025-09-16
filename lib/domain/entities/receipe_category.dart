enum RecipeCategory {
  italian('Italian'),
  chinese('Chinese'),
  indian('Indian'),
  mexican('Mexican'),
  french('French'),
  japanese('Japanese'),
  thai('Thai'),
  mediterranean('Mediterranean'),
  american('American'),
  korean('Korean'),
  greek('Greek'),
  spanish('Spanish'),
  middle_eastern('Middle Eastern'),
  vietnamese('Vietnamese'),
  german('German'),
  british('British'),
  brazilian('Brazilian'),
  moroccan('Moroccan'),
  turkish('Turkish'),
  other('Other');

  const RecipeCategory(this.displayName);

  final String displayName;

  static RecipeCategory fromString(String value) {
    return RecipeCategory.values.firstWhere(
      (category) => category.name == value,
      orElse: () => RecipeCategory.other,
    );
  }

  String toJson() => name;
  static RecipeCategory fromJson(String json) => fromString(json);
}
