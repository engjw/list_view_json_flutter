class Product {

  String id;
  String name;
  String description;
  String image;
  int price;
  String category;
  String shortdes;

  Product({this.id = "",
      this.category = "",
      this.name = "",
      this.description = "",
      this.image = "",
      this.price = 0,
      this.shortdes = ""});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        category: json['category'],
        name: json['name'],
        description: json['description'],
        image: json['image'],
        price: json['price'],
        shortdes: json['shortdes']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['price'] = this.price;
    data['category'] = this.category;
    data['shortdes'] = this.shortdes;
    return data;
  }

}