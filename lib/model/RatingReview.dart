class RatingReview {
  String id;
  int movieId;
  String email;
  String text;
  double rating;
  DateTime date;

  RatingReview(
      {this.id, this.movieId, this.email, this.text, this.rating, this.date});
}
