class UserModel {
  final String id;
  String name;
  

  UserModel({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'Name' : name,
    };
  }
}