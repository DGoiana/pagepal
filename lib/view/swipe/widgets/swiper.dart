import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:pagepal/controller/nearby.dart';
import 'package:pagepal/view/swipe/widgets/book_card.dart';

import '../../../model/book.dart';

class Swiper extends StatelessWidget {
  const Swiper({super.key});

  Future<List<BookCard>> getBookCards() async {
    /*
    final bookFetcher = BooksFetcher();
    
    final firstBook = await bookFetcher.searchBookByISBN("0425038912");
    final secondBook = await bookFetcher.searchBookByISBN("1451673310");
    final thirdBook = await bookFetcher.searchBookByISBN("8401434645");
    */

    List<Book> books = await getNearbyUsersBooks();

    return createBookCards(books);
  }

  List<BookCard> createBookCards(List<Book> books) {
    return (books.map((book) => BookCard(book: book))).toList();
  }

  FutureOr<bool> acceptChoice(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    // TODO: DO SOMETHING GIVEN THE DIRECTION OF THE SWIPE

    return true;
  }

  @override
  Widget build(BuildContext context) {
    CardSwiperController cardController = CardSwiperController();

    return FutureBuilder<List<BookCard>?>(
        future: getBookCards(),
        builder:
            (BuildContext context, AsyncSnapshot<List<BookCard>?> bookCards) {
          if (bookCards.hasData) {
            return Column(children: [
              SizedBox(
                height: 400,
                child: CardSwiper(
                  cardsCount: bookCards.data!.length,
                  cardBuilder:
                      (context, index, percentThresholdX, percentThresholdY) =>
                          bookCards.data?[index],
                  duration: const Duration(milliseconds: 200),
                  controller: cardController,
                  allowedSwipeDirection:
                      const AllowedSwipeDirection.only(right: true, left: true),
                  onSwipe: acceptChoice,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildButton(false, cardController),
                    buildButton(true, cardController)
                  ],
                ),
              )
            ]);
          } else if (bookCards.hasError) {
            return SizedBox(
              height: 400,
              child: Text('ERROR BOOK_CARDS: ${bookCards.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFCCD5AE),
              ),
            );
          }
        });
  }

  ElevatedButton buildButton(bool toRight, CardSwiperController controller) {
    return ElevatedButton(
        onPressed: () => controller.swipe(
            toRight ? CardSwiperDirection.right : CardSwiperDirection.left),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(10),
          backgroundColor: const Color(0xFFCCD5AE),
          foregroundColor: const Color(0xFFFEFAE0),
        ),
        child: Icon(
          toRight ? Icons.check : Icons.close,
          size: 50,
        ));
  }
}
