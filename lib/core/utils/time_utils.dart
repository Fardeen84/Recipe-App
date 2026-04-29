enum MealType { breakfast, lunch, dinner }

class TimeUtils {
  static MealType getMealType() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) return MealType.breakfast;
    if (hour >= 11 && hour < 17) return MealType.lunch;
    return MealType.dinner;
  }

  static String getMealLabel() {
    switch (getMealType()) {
      case MealType.breakfast: return 'Breakfast';
      case MealType.lunch:     return 'Lunch';
      case MealType.dinner:    return 'Dinner';
    }
  }

  static String getGreeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning';
    if (h < 17) return 'Good Afternoon ';
    return 'Good Evening ';
  }

  static String getMealCategory() {
    switch (getMealType()) {
      case MealType.breakfast: return 'Breakfast';
      case MealType.lunch:     return 'Chicken';
      case MealType.dinner:    return 'Beef';
    }
  }
}
