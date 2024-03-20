// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:library_app/models/home_model.dart';
import 'package:library_app/view_models/home_viewModel.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<HomeViewProvider>(context, listen: false);
    provider.fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeViewProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                'assets/scalex.jpg',
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'ScaleX Library',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: TextField(
                controller: _searchController,
                onChanged: provider.filterBooks,
                enabled: true,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.cyan,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.cyan,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                  labelText: 'Search by title or author',
                  labelStyle: TextStyle(color: Color.fromRGBO(189, 189, 189, 1)),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: provider.books.isEmpty
                  ? const Center(
                      child: SpinKitWaveSpinner(
                        waveColor: Colors.cyan,
                        trackColor: Colors.cyan,
                        size: 150,
                        color: Color.fromARGB(255, 47, 85, 224),
                      ),
                    )
                  : provider.filteredBooks.isEmpty
                      ? const Center(child: Text('No books found'))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: provider.filteredBooks.length,
                          itemBuilder: (context, index) {
                            final book = provider.filteredBooks[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: const GradientBoxBorder(
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(51, 206, 255, 0.56),
                                      Color.fromRGBO(55, 244, 250, 1),
                                      Color.fromRGBO(51, 66, 255, 0),
                                      Color.fromRGBO(55, 244, 250, 1),
                                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    BookImage(coverId: book.coverId),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.4,
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            book.title,
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.4,
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            book.author,
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.4,
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            '${book.publishedYear ?? "Unknown"}',
                                            style: const TextStyle(color: Colors.white, fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    ReadButton(provider: provider, book: book, index: index)
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookImage extends StatefulWidget {
  final dynamic coverId;

  const BookImage({Key? key, required this.coverId}) : super(key: key);

  @override
  _BookImageState createState() => _BookImageState();
}

class _BookImageState extends State<BookImage> {
  late Future<String> _imageUrlFuture;

  @override
  void initState() {
    super.initState();
    _imageUrlFuture = Provider.of<HomeViewProvider>(context, listen: false).getImageUrl(widget.coverId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _imageUrlFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SpinKitFadingCube(
            size: 30,
            color: Colors.cyan,
          );
        } else if (snapshot.hasError) {
          return const Icon(Icons.error);
        } else {
          return SizedBox(
              width: 70,
              height: 60,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  snapshot.data!,
                  fit: BoxFit.fill,
                ),
              ));
        }
      },
    );
  }
}

class ReadButton extends StatelessWidget {
  final HomeViewProvider provider;
  final Book book;
  final int index;

  const ReadButton({Key? key, required this.provider, required this.book, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        provider.toggleReadStatus(index);
      },
      child: Container(
        width: 70,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: book.isRead ? Colors.green : Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: book.isRead ? Colors.green : Colors.transparent,
        ),
        child: Text(
          book.isRead ? '✔ Read' : 'Unread',
          style: TextStyle(color: book.isRead ? Colors.white : Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
