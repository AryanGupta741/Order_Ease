class CategoryUtils{
  final String image;
  final String title;
  final String subtitle;

  CategoryUtils({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

List<CategoryUtils> categoryUtils=[

  CategoryUtils(
      image: "assets/starters.jpeg",
      title: 'Starters',
      subtitle: 'Start from where you like!'
  ),
  CategoryUtils(
      image: "assets/Beverage.jpeg",
      title: 'Baverage',
      subtitle: 'Drink what you like!'
  ),
  CategoryUtils(
      image: "assets/desi.jpeg",
      title: 'Desi Food',
      subtitle: 'Eat what you like!'
  ),
  CategoryUtils(
      image: "assets/cakes.jpeg",
      title: 'Cake',
      subtitle: 'Cut what you like!'
  ),
  CategoryUtils(
      image: "assets/chineese.jpeg",
      title: 'Chineese',
      subtitle: 'Eat what you like!'
  ),
  CategoryUtils(
      image: "assets/desert.jpeg",
      title: 'Desert',
      subtitle: 'Eat sweet what you like!'
  ),
  CategoryUtils(
      image: "assets/Beverage.jpeg",
      title: 'Baverage',
      subtitle: 'Drink what you like!'
  ),
  CategoryUtils(
      image: "assets/cakes.jpeg",
      title: 'Cake',
      subtitle: 'Cut what you like!'
  ),
];

final cart=[
  {
    'image': "assets/fooditem.png",
    'title': 'Cake',
    'subtitle': 'Cut what you like!'
  }
];