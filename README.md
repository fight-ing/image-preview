# 图片分组预览组件 (Grouped Image Preview)

一个功能强大的 Flutter 图片分组预览组件,支持分组切换、图片滑动浏览等功能。

## 功能特性

✨ **核心功能**
- 🖼️ 显示分组图片,宽高比 1:1
- 👆 支持左右滑动切换图片
- 🔄 支持向前或向后切换分组
- 🔗 **跨分组连续滑动**：滑动到分组最后一张时自动切换到下一分组
- 📊 分组标题与图片数量显示(格式:"正面1/3")
- 🎯 SegmentedControl 样式的分组选择器
- ⚡ 点击切换分组时同步滑动图片
- 🎨 优雅的动画效果

## 项目结构

```
lib/
├── models/
│   └── image_group_model.dart    # 图片分组数据模型
├── widgets/
│   └── grouped_image_preview.dart # 图片分组预览组件
├── pages/
│   └── example_page.dart          # 示例页面
└── main.dart                       # 应用入口
```

## 使用方法

### 1. 定义图片分组数据

```dart
import 'package:image_preview/models/image_group_model.dart';

List<ImageGroup> imageGroups = [
  ImageGroup(
    name: '正面',
    images: [
      'https://example.com/image1.jpg',
      'https://example.com/image2.jpg',
      'https://example.com/image3.jpg',
    ],
  ),
  ImageGroup(
    name: '侧面',
    images: [
      'https://example.com/image4.jpg',
      'https://example.com/image5.jpg',
    ],
  ),
  ImageGroup(
    name: '底部',
    images: [
      'https://example.com/image6.jpg',
    ],
  ),
];
```

### 2. 使用组件

```dart
import 'package:image_preview/widgets/grouped_image_preview.dart';

GroupedImagePreview(
  groups: imageGroups,
  initialGroupIndex: 0,
  initialImageIndex: 0,
  onGroupChanged: (groupIndex, imageIndex) {
    print('切换到分组: $groupIndex, 图片: $imageIndex');
  },
  onImageChanged: (groupIndex, imageIndex) {
    print('当前分组: $groupIndex, 图片: $imageIndex');
  },
)
```

## 组件参数

| 参数 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `groups` | `List<ImageGroup>` | ✅ | 图片分组列表 |
| `initialGroupIndex` | `int` | ❌ | 初始分组索引(默认: 0) |
| `initialImageIndex` | `int` | ❌ | 初始图片索引(默认: 0) |
| `placeholder` | `Widget?` | ❌ | 图片加载占位符 |
| `errorWidget` | `Widget?` | ❌ | 图片加载错误占位符 |
| `onGroupChanged` | `Function(int, int)?` | ❌ | 分组切换回调 |
| `onImageChanged` | `Function(int, int)?` | ❌ | 图片切换回调 |

## ImageGroup 模型

```dart
class ImageGroup {
  final String name;           // 分组名称
  final List<String> images;   // 图片列表(支持网络URL和本地资源)

  int get imageCount;          // 获取图片数量
  bool get isEmpty;            // 检查是否为空
  bool get isNotEmpty;         // 检查是否非空
}
```

## 运行示例

1. 克隆项目
```bash
git clone <repository-url>
cd image-preview
```

2. 获取依赖
```bash
flutter pub get
```

3. 运行应用
```bash
flutter run
```

## 使用场景

- 📦 商品检测图片展示(正面、侧面、底部、瑕疵等)
- 🏠 房产图片浏览(客厅、卧室、厨房、卫生间等)
- 📸 相册分组查看
- 🎨 作品集展示
- 📄 文档扫描件分类查看

## 技术亮点

1. **单一连续滚动架构（重构版）**
   - ✅ 所有图片在一个 PageView 中连续滚动
   - ✅ 无边界问题，流畅自然
   - ✅ 彻底解决跨分组滑动时的卡顿和回弹

2. **智能分组联动**
   - 滑动图片时，分组选择器自动更新
   - 点击分组时，自动跳转到该分组的第一张
   - 实时显示当前图片在分组中的位置

3. **优雅的 UI 设计**
   - SegmentedControl 风格的分组选择器
   - 平滑的动画过渡效果（300ms）
   - 1:1 宽高比图片展示

4. **灵活的扩展性**
   - 支持网络图片和本地资源
   - 自定义占位符和错误提示
   - 完善的回调机制（onGroupChanged, onImageChanged）

5. **性能优化**
   - 全局图片索引预计算
   - 高效的分组起始位置查找
   - 流畅的 PageView 滚动体验

## 开发环境

- Flutter SDK: >= 3.0.0
- Dart SDK: >= 3.0.0

## 许可证

MIT License

## 贡献

欢迎提交 Issue 和 Pull Request!