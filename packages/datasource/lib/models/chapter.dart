
import '../src/base.dart';

class Chapter extends BaseModel {
  final String courseId;
  final String title;
  final int originalPrice;
  final int price;

  @override
  List<String> get searchTerms => [title];

  Chapter({
    super.id,
    super.createdAt,
    required this.courseId,
    required this.title,
    required this.originalPrice,
    required this.price,
  });

  Chapter.fromMap(super.data)
      : courseId = data['courseId'],
        title = data['title'],
        originalPrice = data['originalPrice'],
        price = data['price'],
        super.fromMap();

  @override
  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'title': title,
      'originalPrice': originalPrice,
      'price': price,
      ...super.toMap(),
    };
  }
}
