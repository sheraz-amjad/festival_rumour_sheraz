class FestivalModel {
  final String title;
  final String location;
  final String date;
  final String imagepath;// 👈 non-nullable
  final bool isLive;

  FestivalModel({
    required this.title,
    required this.location,
    required this.date,
    required this.imagepath,
    this.isLive = false,
  });
}
