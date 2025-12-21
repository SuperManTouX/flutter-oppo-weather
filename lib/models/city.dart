// 城市模型类
class City {
  // 城市名称
  final String name;
  
  // 城市位置码 (和风天气API使用的location参数)
  final String location;
  
  // 构造函数
  const City({
    required this.name,
    required this.location,
  });
}
