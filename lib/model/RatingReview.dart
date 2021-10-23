class RatingReview {
  String id;
  String uid;
  int movieId;
  String email;
  String text;
  double rating;
  DateTime date;
  String photoURL;
  RatingReview(
      {this.id,
      this.uid,
      this.movieId,
      this.email,
      this.text,
      this.rating,
      this.date,
      this.photoURL});
}
