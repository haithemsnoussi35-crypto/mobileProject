/// Simple student profile model.
class Student {
  Student({
    required this.id,
    required this.name,
    required this.field,
    required this.skills,
    required this.bio,
    required this.rating,
    required this.avatar,
    this.university,
    this.studyStyle,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String field;
  final List<String> skills;
  final String bio;
  double rating;
  final String avatar;
  final String? university;
  final String? studyStyle;
  final String? avatarUrl;

  factory Student.fromJson(Map<String, dynamic> json) {
    // Support both API format (subjects) and local format (skills)
    final skills = json['subjects'] != null
        ? (json['subjects'] as List<dynamic>).cast<String>()
        : (json['skills'] as List<dynamic>?)?.cast<String>() ?? <String>[];
    
    // Support both API format (university as field) and local format (field)
    final field = json['university'] as String? ?? json['field'] as String? ?? 'Unknown';
    
    // Support both API format (avatarUrl) and local format (avatar path)
    final avatar = json['avatarUrl'] as String? ?? 
                   (json['avatar'] as String? ?? 'assets/avatars/avatar1.png');
    
    // Default rating if not provided
    final rating = (json['rating'] as num?)?.toDouble() ?? 4.0;

    return Student(
      id: json['id'] as String,
      name: json['name'] as String,
      field: field,
      skills: skills,
      bio: json['bio'] as String? ?? '',
      rating: rating,
      avatar: avatar,
      university: json['university'] as String?,
      studyStyle: json['studyStyle'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'field': field,
    'skills': skills,
    'bio': bio,
    'rating': rating,
    'avatar': avatar,
    if (university != null) 'university': university,
    if (studyStyle != null) 'studyStyle': studyStyle,
    if (avatarUrl != null) 'avatarUrl': avatarUrl,
  };
}

