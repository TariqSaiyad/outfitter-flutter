
class Item {
  String image;
  String name;
  String type;
  String dressCode;
  String color;
  String category;

  Item(this.image, this.name, this.type, this.dressCode, this.color,
      this.category);

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> m = new Map();
    m['name'] = name;
    m['image'] = image;
    m['type'] = type;
    m['dressCode'] = dressCode;
    m['color'] = color;
    m['category'] = category;
    return m;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type &&
          dressCode == other.dressCode &&
          color == other.color &&
          category == other.category;

  @override
  int get hashCode =>
      name.hashCode ^
      type.hashCode ^
      dressCode.hashCode ^
      color.hashCode ^
      category.hashCode;
}
