/* Tushar Ugale * Technicul.com */
class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({
    required this.imageUrl,
    required this.title,
    required this.description,
  });
}

final slideList = [
  Slide(
      imageUrl: 'assets/images/one.svg',
      title: 'Pay utility bills.',
      description: ''),
  Slide(
      imageUrl: 'assets/images/two.svg',
      title: 'Instant trasnfers.',
      description: ''),
  Slide(
      imageUrl: 'assets/images/three.svg',
      title: 'Tranffer to friends.',
      description: ''),
];
