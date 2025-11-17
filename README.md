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

# 图片预览 - 全局滑动

一个支持跨分组全局滑动的图片预览应用，使用 React + TypeScript 构建。

## ✨ 核心功能

### 🌍 全局图片滑动
- **跨分组浏览**：滑动图片时不受分组限制，可以从一个分组无缝切换到下一个分组
- **自动分组切换**：当滑动到其他分组的图片时，分组选择器会自动更新
- **统一索引管理**：所有图片通过全局索引统一管理，实现真正的"全局滑动"

### 🎯 交互方式
- **触摸滑动**：移动端支持触摸滑动切换图片
- **鼠标拖拽**：桌面端支持鼠标拖拽操作
- **键盘导航**：
  - `←` 上一张图片
  - `→` 下一张图片
  - `ESC` 关闭预览
- **按钮点击**：左右导航按钮快速切换

### 📱 响应式设计
- 完美适配移动端和桌面端
- 自适应不同屏幕尺寸
- 优雅的动画过渡效果

## 🚀 快速开始

### 安装依赖

```bash
npm install
```

### 启动开发服务器

```bash
npm run dev
```

### 构建生产版本

```bash
npm run build
```

### 预览生产构建

```bash
npm run preview
```

## 📁 项目结构

```
src/
├── components/          # React 组件
│   ├── GroupSelector    # 分组选择器
│   ├── ImageGrid        # 图片网格
│   └── ImageViewer      # 图片查看器（支持全局滑动）
├── hooks/               # 自定义 Hooks
│   ├── useGlobalImageNavigation  # 全局图片导航逻辑
│   └── useSwipe         # 滑动手势处理
├── data/                # 示例数据
│   └── sampleData.ts    # 示例图片分组数据
├── types.ts             # TypeScript 类型定义
├── App.tsx              # 主应用组件
└── main.tsx             # 应用入口
```

## 🎨 核心实现

### 1. 全局图片索引

使用 `useGlobalImageNavigation` Hook 将所有分组的图片统一管理：

```typescript
// 为每张图片创建全局索引
const globalImageMap = [
  { globalIndex: 0, groupId: 'group-1', localIndex: 0, ... },
  { globalIndex: 1, groupId: 'group-1', localIndex: 1, ... },
  { globalIndex: 2, groupId: 'group-1', localIndex: 2, ... },
  { globalIndex: 3, groupId: 'group-2', localIndex: 0, ... },  // 跨组
  ...
]
```

### 2. 自动分组切换

通过监听全局索引变化，自动更新当前选中的分组：

```typescript
useEffect(() => {
  if (currentGlobalIndex >= 0) {
    const imageInfo = getImageByGlobalIndex(currentGlobalIndex);
    if (imageInfo && imageInfo.groupId !== selectedGroupId) {
      setSelectedGroupId(imageInfo.groupId);  // 自动切换分组
    }
  }
}, [currentGlobalIndex]);
```

### 3. 滑动手势识别

`useSwipe` Hook 实现了触摸和鼠标拖拽的统一处理：

```typescript
const swipeHandlers = useSwipe({
  onSwipeLeft: handleNext,   // 下一张
  onSwipeRight: handlePrev,  // 上一张
  threshold: 50,             // 滑动阈值
});
```

## 📝 使用示例

### 定义图片分组

```typescript
const groups: ImageGroup[] = [
  {
    id: 'group-1',
    name: '风景摄影',
    images: [
      {
        id: 'img-1',
        url: 'https://example.com/image1.jpg',
        title: '山脉日出',
        description: '壮丽的山脉在晨光中苏醒',
      },
      // 更多图片...
    ],
  },
  // 更多分组...
];
```

### 应用特点

1. **无缝切换**：从分组1的最后一张图片滑动，直接进入分组2的第一张
2. **状态同步**：分组选择器始终显示当前图片所属的分组
3. **流畅体验**：优化的动画和过渡效果

## 🛠️ 技术栈

- **React 18** - UI 框架
- **TypeScript** - 类型安全
- **Vite** - 构建工具
- **CSS3** - 样式和动画

## 📄 许可证

MIT License

