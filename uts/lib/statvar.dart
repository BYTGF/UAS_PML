class StatVar {
  static late Map<String, dynamic>? userData;
  static late int access;
  static late String userName;

  static void accessUserData() {
    // Initialize user data here
    if (StatVar.userData != null) {
      userName = StatVar.userData!['name'] ?? '';
      access = StatVar.userData!['is_admin'] ?? 0;
    } else {
      // Handle the case where StatVar.userData is null
      access = 0;
      userName = '';
    }
    // Now you can use the 'access' variable safely
    print('Access level: $access');
  }
}