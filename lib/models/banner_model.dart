class BannerModel {
  final int id;
  final String image;
  final String title;
  final String subTitle;
  final String buttonText;

  BannerModel({
    required this.id,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.buttonText,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      subTitle: json['sub_title'] ?? '',
      buttonText: json['button_text'] ?? '',
    );
  }
}