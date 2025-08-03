class Medicine {
  String name;
  int howOften;
  int howMany;
  bool after;

  Medicine({
    required this.name,
    required this.howMany,
    required this.howOften,
    required this.after,
  });

  Map<String, dynamic> toJson() {
    return {
      'name' : name,
      'howOften' : howOften,
      'howMany' : howMany,
      'after' : after,
    };
  }

}