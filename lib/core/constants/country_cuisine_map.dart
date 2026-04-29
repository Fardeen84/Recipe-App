/// Maps ISO-3166 country codes to MealDB area names.
class CountryCuisineMap {
  CountryCuisineMap._();

  static const Map<String, String> _map = {
    'IN': 'Indian',
    'US': 'American',
    'GB': 'British',
    'CN': 'Chinese',
    'JP': 'Japanese',
    'MX': 'Mexican',
    'IT': 'Italian',
    'FR': 'French',
    'TH': 'Thai',
    'GR': 'Greek',
    'ES': 'Spanish',
    'MA': 'Moroccan',
    'PH': 'Filipino',
    'VN': 'Vietnamese',
    'KR': 'Korean',
    'TR': 'Turkish',
    'PL': 'Polish',
    'CA': 'Canadian',
    'JM': 'Jamaican',
    'HR': 'Croatian',
    'NL': 'Dutch',
    'IE': 'Irish',
    'TW': 'Taiwanese',
    'TN': 'Tunisian',
    'RU': 'Russian',
    'EG': 'Egyptian',
  };

  static String fromCode(String countryCode) =>
      _map[countryCode.toUpperCase()] ?? 'Italian';
}
