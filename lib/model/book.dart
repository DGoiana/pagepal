import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:pagepal/controller/images_fetcher.dart';
class Book {
  Book({
    required this.authors,
    required this.genres,
    required this.isbn,
    required this.lang,
    required this.pubYear,
    required this.title,
    required this.image,
  });

  final List<dynamic> authors;
  final List<dynamic> genres;
  final Image image;
  final String isbn;
  final String lang;
  final String pubYear;
  final String title;


//Get a Book class instance from firebase 
    static Future<Book> createBookFromFirestore (
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) async {

    final data = snapshot.data();

    
    Future<Image> img = ImageFetcher.getImageByISBN(data?['isbn']);
    

    return Book(
      authors: data?['authors'],
      genres: data?['genres'],
      image: await img,
      isbn: data?['isbn'],
      lang: data?['language'],
      pubYear: data?['publicationYear'],
      title: data?['title'],
    );
  }

//TODO possivelmente util para colocar na database
/*
Map<String, dynamic> toFirestore() {
    return {
      if (author != null) "author": author,
      if (genres != null) "genres": genres,
      if (isbn != null) "isbn": isbn,
      if (lang != null) "language": lang,
      if (pubYear != null) "publicationYear": pubYear,
      if (title != null) "title": title,
      if (image != null) "image": image
    };
  }
  */
}
