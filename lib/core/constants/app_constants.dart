enum UserRole { customer, provider, unknown }

class AppConstants {
  AppConstants._();

  // Firestore collections
  static const String usersCollection = 'users';

  // Provider service categories
  static const List<String> availableServices = [
    'Electrician',
    'Plumber',
    'AC Repair',
    'Carpenter',
    'Painter',
    'Mason / Civil',
    'Gas Technician',
    'Home Cleaner',
    'Welder',
    'CCTV / Security',
  ];
  static const String servicesCollection = 'services';
  static const String bookingsCollection = 'bookings';
  static const String reviewsCollection = 'reviews';

  // SharedPreferences keys
  static const String userRoleKey = 'user_role';
  static const String onboardingKey = 'onboarding_done';
}
