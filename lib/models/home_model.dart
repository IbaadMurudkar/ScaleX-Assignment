class HomeModel {
  List<HomeModelDoc> docs;

  HomeModel({required this.docs});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> docList = json['docs'];
    final List<HomeModelDoc> docs = docList.map((json) => HomeModelDoc.fromJson(json)).toList();
    return HomeModel(docs: docs);
  }
}


class HomeModelDoc {
  String title;
  List<String> authorName;
  List<int> publishYear;
  dynamic cover_i; 

  HomeModelDoc({
    required this.title,
    required this.authorName,
    required this.publishYear,
    required this.cover_i, 
  });

  factory HomeModelDoc.fromJson(Map<String, dynamic> json) {
    return HomeModelDoc(
      title: json['title'],
      authorName: List<String>.from(json['author_name'] ?? []),
      publishYear: List<int>.from(json['publish_year'] ?? []),
      cover_i: json['cover_i'], 
    );
  }
}




class Book {
  String title;
  String author;
  int? publishedYear;
  dynamic coverId;
  bool isRead;

  Book({
    required this.title,
    required this.author,
    this.publishedYear,
    required this.coverId,
    this.isRead = false, 
  });

  factory Book.fromDoc(HomeModelDoc doc) {
    return Book(
      title: doc.title,
      author: doc.authorName.isNotEmpty ? doc.authorName[0] : 'Unknown',
      publishedYear: doc.publishYear.isNotEmpty ? doc.publishYear[0] : null,
      coverId: doc.cover_i,
    );
  }
}


