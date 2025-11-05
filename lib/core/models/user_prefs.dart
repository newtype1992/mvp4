class UserPrefs {
  const UserPrefs({
    required this.selectedCategoryIds,
    required this.allowNotifications,
    required this.allowLocation,
    required this.sampleCity,
    required this.demoMode,
  });

  final List<String> selectedCategoryIds;
  final bool allowNotifications;
  final bool allowLocation;
  final String sampleCity;
  final bool demoMode;

  UserPrefs copyWith({
    List<String>? selectedCategoryIds,
    bool? allowNotifications,
    bool? allowLocation,
    String? sampleCity,
    bool? demoMode,
  }) {
    return UserPrefs(
      selectedCategoryIds: selectedCategoryIds ?? this.selectedCategoryIds,
      allowNotifications: allowNotifications ?? this.allowNotifications,
      allowLocation: allowLocation ?? this.allowLocation,
      sampleCity: sampleCity ?? this.sampleCity,
      demoMode: demoMode ?? this.demoMode,
    );
  }
}
