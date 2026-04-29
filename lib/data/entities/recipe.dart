import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final String name;
  final String measure;
  const Ingredient({required this.name, required this.measure});
  @override
  List<Object?> get props => [name, measure];
}

class Recipe extends Equatable {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String image;
  final String youtubeUrl;
  final List<Ingredient> ingredients;
  final String tags;
  final bool isFavorite;

  const Recipe({
    required this.id,
    required this.name,
    this.category = '',
    this.area = '',
    this.instructions = '',
    required this.image,
    this.youtubeUrl = '',
    this.ingredients = const [],
    this.tags = '',
    this.isFavorite = false,
  });

  Recipe copyWith({
    String? id, String? name, String? category, String? area,
    String? instructions, String? image, String? youtubeUrl,
    List<Ingredient>? ingredients, String? tags, bool? isFavorite,
  }) => Recipe(
    id: id ?? this.id, name: name ?? this.name,
    category: category ?? this.category, area: area ?? this.area,
    instructions: instructions ?? this.instructions, image: image ?? this.image,
    youtubeUrl: youtubeUrl ?? this.youtubeUrl,
    ingredients: ingredients ?? this.ingredients,
    tags: tags ?? this.tags, isFavorite: isFavorite ?? this.isFavorite,
  );

  @override
  List<Object?> get props =>
      [id, name, category, area, instructions, image, youtubeUrl, ingredients, tags, isFavorite];
}
