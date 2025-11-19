/// 图片分组数据模型
class ImageGroup {
  /// 分组名称
  final String name;

  /// 图片列表
  final List<String> images;

  const ImageGroup({
    required this.name,
    required this.images,
  });

  /// 获取图片数量
  int get imageCount => images.length;

  /// 检查是否为空
  bool get isEmpty => images.isEmpty;

  /// 检查是否非空
  bool get isNotEmpty => images.isNotEmpty;
}
