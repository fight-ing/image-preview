# Image Preview 图片预览组件

一个功能强大的图片预览组件，支持跨分组滑动浏览图片。

## 主要功能

✅ **跨分组滑动** - 可以在不同分组的图片间无缝切换浏览
✅ **分组显示** - 显示当前图片所属的分组信息
✅ **键盘导航** - 支持键盘快捷键操作（左右箭头切换，ESC 关闭）
✅ **触摸支持** - 移动端支持滑动手势切换图片
✅ **响应式设计** - 完美适配各种屏幕尺寸
✅ **灵活配置** - 可自定义是否启用跨分组功能

## 快速开始

1. 克隆仓库
```bash
git clone <repository-url>
cd image-preview
```

2. 打开 `index.html` 在浏览器中查看演示

## 使用方法

### 基本用法

```html
<!-- 引入样式文件 -->
<link rel="stylesheet" href="image-preview.css">

<!-- 创建图片分组 -->
<div class="image-group" data-group="landscape">
    <img src="image1.jpg" alt="图片1" class="preview-trigger">
    <img src="image2.jpg" alt="图片2" class="preview-trigger">
</div>

<div class="image-group" data-group="city">
    <img src="image3.jpg" alt="图片3" class="preview-trigger">
    <img src="image4.jpg" alt="图片4" class="preview-trigger">
</div>

<!-- 引入脚本 -->
<script src="image-preview.js"></script>
<script>
    // 初始化预览器
    const preview = new ImagePreview({
        crossGroup: true, // 启用跨分组滑动
        showGroupInfo: true // 显示分组信息
    });
</script>
```

### 配置选项

| 选项 | 类型 | 默认值 | 说明 |
|-----|------|--------|------|
| `crossGroup` | Boolean | `true` | 是否支持跨分组滑动 |
| `showGroupInfo` | Boolean | `true` | 是否显示分组信息 |
| `triggerSelector` | String | `'.preview-trigger'` | 触发预览的图片选择器 |

### API 方法

```javascript
const preview = new ImagePreview();

// 打开指定索引的图片
preview.open(index);

// 关闭预览
preview.close();

// 上一张图片
preview.prev();

// 下一张图片
preview.next();

// 切换跨分组模式
preview.toggleCrossGroup();

// 获取当前图片信息
preview.getCurrentImage();

// 销毁实例
preview.destroy();
```

## 键盘快捷键

- `←` / `→` - 切换上一张/下一张图片
- `ESC` - 关闭预览窗口

## 移动端支持

在移动设备上，可以使用滑动手势：
- 向左滑动 - 查看下一张图片
- 向右滑动 - 查看上一张图片

## 跨分组滑动说明

当启用 `crossGroup: true` 时：
- 可以在所有图片之间无缝切换
- 从最后一张切换到第一张（循环浏览）
- 显示当前图片所属的分组名称

当禁用 `crossGroup: false` 时：
- 仅在当前分组内的图片间切换
- 不会跨越到其他分组

## 文件结构

```
image-preview/
├── index.html          # 演示页面
├── image-preview.js    # 核心 JavaScript 组件
├── image-preview.css   # 样式文件
└── README.md           # 说明文档
```

## 浏览器支持

- Chrome (最新版本)
- Firefox (最新版本)
- Safari (最新版本)
- Edge (最新版本)
- 移动端浏览器

## 许可证

MIT License

## 更新日志

### v1.0.0 (2025-11-17)
- ✨ 初始版本发布
- ✅ 支持跨分组滑动图片
- ✅ 键盘和触摸手势支持
- ✅ 响应式设计
