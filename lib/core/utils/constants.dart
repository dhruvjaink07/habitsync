class AppTextSizes {
  static const double headingLarge = 28.0;
  static const double headingMedium = 22.0;
  static const double headingSmall = 18.0;

  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;

  static const double caption = 10.0;
  static const double iconMedium = 28;
  static const double iconLarge = 38;

  static final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
  );

  static bool isValidPassword(String password, {int minLength = 8}) {
    return password.length >= minLength;
  }
}
