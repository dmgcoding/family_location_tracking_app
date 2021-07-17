class User {
  final String id, name, img, markerId;
  final double latitude, longtitude;

  User(this.id, this.name, this.img, this.markerId, this.latitude,
      this.longtitude);
}

class Users {
  static List<User> users = [
    User("1", "Sara", "assets/images/user1.png", "marker1", 37.555172,
        126.971659),
    User("2", "Mira", "assets/images/user2.png", "marker2", 37.555085,
        126.973469),
    User("3", "Rebeca", "assets/images/user3.png", "marker3", 37.550305,
        126.973351),
    User("4", "Barbara", "assets/images/user4.png", "marker4", 37.589994,
        127.026099),
    User(
        "5", "Lisa", "assets/images/user5.png", "marker5", 47.004564, 62.42655),
    User("6", "Emma", "assets/images/user6.png", "marker6", 40.043633,
        -83.072787),
    User("7", "Liam", "assets/images/user7.png", "marker7", 40.012942,
        -83.065961),
    User("8", "Elijah", "assets/images/user8.png", "marker8", 40.690368,
        -74.046675),
    User("9", "Khol", "assets/images/user9.png", "marker9", 40.701891,
        -74.050176),
  ];
}
