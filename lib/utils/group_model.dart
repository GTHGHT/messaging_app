class GroupModel {
  final String id;
  final String title;
  final String image;

  GroupModel({
    required this.id,
    required this.title,
    required this.image,
  });

  factory GroupModel.fromMap(Map<String, dynamic> data){
    return GroupModel(
      id: data['id'],
      title: data['title'],
      image: data['image'],
    );
  }

  factory GroupModel.initial() {
    return GroupModel(
      id: '',
      title: '',
      image: '',
    );
  }
}