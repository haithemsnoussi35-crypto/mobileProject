/// Lightweight user profile model.
class UserProfile {
  UserProfile({
    required this.name,
    required this.bio,
    required this.skills,
    required this.avatar,
  });

  String name;
  String bio;
  List<String> skills;
  String avatar;

  Map<String, dynamic> toJson() => {
    'name': name,
    'bio': bio,
    'skills': skills,
    'avatar': avatar,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    name: json['name'] as String? ?? 'You',
    bio: json['bio'] as String? ?? 'Describe how you like to study.',
    skills: (json['skills'] as List<dynamic>?)?.cast<String>() ?? <String>[],
    avatar: json['avatar'] as String? ?? '', // No default avatar
  );
}




