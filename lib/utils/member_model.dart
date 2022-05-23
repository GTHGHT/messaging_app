class MemberModel{
  final String id;
  final String name;
  final String image;
  final String email;

  MemberModel({
    required this.id,
    required this.name,
    required this.image,
    required this.email,
  });

  factory MemberModel.fromMap(Map<String, dynamic> data){
    return MemberModel(
      id: data['id'],
      name: data['name'],
      image: data['image'],
      email: data['email'],
    );
  }

  factory MemberModel.initial() {
    return MemberModel(
      id: '',
      name: '',
      image: '',
      email: '',
    );
  }
}