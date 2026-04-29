import '../entities/recipe.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    required super.name,
    super.category,
    super.area,
    super.instructions,
    required super.image,
    super.youtubeUrl,
    super.ingredients,
    super.tags,
    super.isFavorite,
  });


  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    final ingredients = <Ingredient>[];
    for (int i = 1; i <= 20; i++) {
      final name    = json['strIngredient$i']?.toString().trim() ?? '';
      final measure = json['strMeasure$i']?.toString().trim()    ?? '';
      if (name.isNotEmpty) {
        ingredients.add(Ingredient(name: name, measure: measure));
      }
    }

    return RecipeModel(
      id:           json['idMeal']?.toString()           ?? '',
      name:         json['strMeal']?.toString()           ?? '',
      category:     json['strCategory']?.toString()       ?? '',
      area:         json['strArea']?.toString()            ?? '',
      instructions: json['strInstructions']?.toString()   ?? '',
      image:        json['strMealThumb']?.toString()       ?? '',
      youtubeUrl:   json['strYoutube']?.toString()         ?? '',
      tags:         json['strTags']?.toString()            ?? '',
      ingredients:  ingredients,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'idMeal':          id,
      'strMeal':         name,
      'strCategory':     category,
      'strArea':         area,
      'strInstructions': instructions,
      'strMealThumb':    image,
      'strYoutube':      youtubeUrl,
      'strTags':         tags,
      'isFavorite':      isFavorite,
    };
    for (int i = 0; i < ingredients.length; i++) {
      map['strIngredient${i + 1}'] = ingredients[i].name;
      map['strMeasure${i + 1}']    = ingredients[i].measure;
    }
    return map;
  }

  factory RecipeModel.fromCachedJson(Map<String, dynamic> json) =>
      RecipeModel.fromJson({...json, 'idMeal': json['idMeal'] ?? json['id'] ?? ''});

  RecipeModel withFavorite(bool fav) => RecipeModel(
    id: id, name: name, category: category, area: area,
    instructions: instructions, image: image, youtubeUrl: youtubeUrl,
    ingredients: ingredients, tags: tags, isFavorite: fav,
  );
}
