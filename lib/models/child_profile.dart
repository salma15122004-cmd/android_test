class ChildProfile {
  const ChildProfile({
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.avatarAsset,
  });

  final String name;
  final DateTime birthDate;
  final String gender;
  final String avatarAsset;

  Map<String, Object> toJson() => {
    'name': name,
    'birthDate': birthDate.toIso8601String(),
    'gender': gender,
    'avatarAsset': avatarAsset,
  };

  factory ChildProfile.fromJson(Map<String, dynamic> json) {
    return ChildProfile(
      name: json['name'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      gender: json['gender'] as String,
      avatarAsset: json['avatarAsset'] as String,
    );
  }
}
