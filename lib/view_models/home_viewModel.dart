import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:library_app/models/home_model.dart';

class HomeViewProvider extends ChangeNotifier {
 
  List<Book> books = [];
  late List<Book> _filteredBooks;

  HomeViewProvider({required this.books}) {
    _filteredBooks = List.from(books);
  }

  List<Book> get filteredBooks => _filteredBooks;

  void filterBooks(String query) {
    _filteredBooks = query.isEmpty
        ? List.from(books)
        : books.where((book) {
            final title = book.title.toLowerCase();
            final author = book.author.toLowerCase();
            final searchQuery = query.toLowerCase();
            return title.contains(searchQuery) || author.contains(searchQuery);
          }).toList();
    notifyListeners();
  }

  Future<void> fetchBooks() async {
    final response = await http.get(Uri.parse('https://openlibrary.org/search.json?q=the+lord+of+the+rings'));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final lordOfTheRings = HomeModel.fromJson(jsonData);
      books = lordOfTheRings.docs.map((doc) => Book.fromDoc(doc)).toList();
      _filteredBooks = List.from(books);
      notifyListeners();
    } else {
      throw Exception('Failed to load books');
    }
  }

  
  Future<void> toggleReadStatus(int index) async {
    bool newStatus = !(books[index].isRead);
    books[index].isRead = newStatus;
    notifyListeners();
  }

  Future<String> getImageUrl(dynamic coverId) async {
    final response = await http.get(Uri.parse('https://covers.openlibrary.org/b/id/$coverId-M.jpg'));
    if (response.statusCode == 200) {
      return 'https://covers.openlibrary.org/b/id/$coverId-M.jpg';
    } else {
      throw Exception('Failed to load image');
    }
  }
}
