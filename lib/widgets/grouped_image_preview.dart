import 'package:flutter/material.dart';
import '../models/image_group_model.dart';

/// 图片分组预览组件 - 重构版
///
/// 新架构：
/// 1. 所有图片在一个连续的 PageView 中滚动（全局滚动视图）
/// 2. 滑动图片时，自动更新分组选择器
/// 3. 点击分组选择器时，跳转到该分组的第一张图片
/// 4. 无边界问题，流畅滑动
class GroupedImagePreview extends StatefulWidget {
  /// 图片分组列表
  final List<ImageGroup> groups;

  /// 初始分组索引
  final int initialGroupIndex;

  /// 初始图片索引
  final int initialImageIndex;

  /// 图片占位符
  final Widget? placeholder;

  /// 图片加载错误时的占位符
  final Widget? errorWidget;

  /// 分组切换回调
  final Function(int groupIndex, int imageIndex)? onGroupChanged;

  /// 图片切换回调
  final Function(int groupIndex, int imageIndex)? onImageChanged;

  const GroupedImagePreview({
    super.key,
    required this.groups,
    this.initialGroupIndex = 0,
    this.initialImageIndex = 0,
    this.placeholder,
    this.errorWidget,
    this.onGroupChanged,
    this.onImageChanged,
  });

  @override
  State<GroupedImagePreview> createState() => _GroupedImagePreviewState();
}

/// 全局图片信息
class _GlobalImageInfo {
  final int globalIndex; // 全局索引
  final int groupIndex; // 所属分组索引
  final int localIndex; // 分组内索引
  final String imagePath; // 图片路径

  _GlobalImageInfo({
    required this.globalIndex,
    required this.groupIndex,
    required this.localIndex,
    required this.imagePath,
  });
}

class _GroupedImagePreviewState extends State<GroupedImagePreview> {
  late PageController _pageController;
  late List<_GlobalImageInfo> _globalImages;
  late int _currentGlobalIndex;
  late int _currentGroupIndex;
  late int _currentLocalIndex;

  @override
  void initState() {
    super.initState();

    // 构建全局图片列表
    _globalImages = _buildGlobalImageList();

    // 计算初始全局索引
    _currentGlobalIndex = _calculateInitialGlobalIndex();
    _currentGroupIndex = widget.initialGroupIndex;
    _currentLocalIndex = widget.initialImageIndex;

    // 初始化 PageController
    _pageController = PageController(initialPage: _currentGlobalIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// 构建全局图片列表（将所有分组的图片平铺）
  List<_GlobalImageInfo> _buildGlobalImageList() {
    final List<_GlobalImageInfo> result = [];
    int globalIndex = 0;

    for (int groupIndex = 0; groupIndex < widget.groups.length; groupIndex++) {
      final group = widget.groups[groupIndex];
      for (int localIndex = 0; localIndex < group.images.length; localIndex++) {
        result.add(_GlobalImageInfo(
          globalIndex: globalIndex,
          groupIndex: groupIndex,
          localIndex: localIndex,
          imagePath: group.images[localIndex],
        ));
        globalIndex++;
      }
    }

    return result;
  }

  /// 计算初始全局索引
  int _calculateInitialGlobalIndex() {
    int globalIndex = 0;
    for (int i = 0; i < widget.initialGroupIndex; i++) {
      globalIndex += widget.groups[i].imageCount;
    }
    globalIndex += widget.initialImageIndex;
    return globalIndex;
  }

  /// 获取分组的起始全局索引
  int _getGroupStartIndex(int groupIndex) {
    int startIndex = 0;
    for (int i = 0; i < groupIndex; i++) {
      startIndex += widget.groups[i].imageCount;
    }
    return startIndex;
  }

  /// 处理页面变化
  void _onPageChanged(int globalIndex) {
    if (globalIndex < 0 || globalIndex >= _globalImages.length) return;

    final imageInfo = _globalImages[globalIndex];
    final oldGroupIndex = _currentGroupIndex;

    setState(() {
      _currentGlobalIndex = globalIndex;
      _currentGroupIndex = imageInfo.groupIndex;
      _currentLocalIndex = imageInfo.localIndex;
    });

    // 回调
    widget.onImageChanged?.call(imageInfo.groupIndex, imageInfo.localIndex);

    // 如果分组变化了，触发分组切换回调
    if (imageInfo.groupIndex != oldGroupIndex) {
      widget.onGroupChanged?.call(imageInfo.groupIndex, imageInfo.localIndex);
    }
  }

  /// 切换到指定分组
  void _switchToGroup(int groupIndex) {
    if (groupIndex < 0 || groupIndex >= widget.groups.length) return;

    final startIndex = _getGroupStartIndex(groupIndex);

    _pageController.animateToPage(
      startIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.groups.isEmpty || _globalImages.isEmpty) {
      return const Center(
        child: Text('暂无图片'),
      );
    }

    return Column(
      children: [
        // 分组选择器
        _buildGroupSelector(),
        const SizedBox(height: 16),

        // 图片预览区域（单一 PageView）
        Expanded(
          child: _buildImagePageView(),
        ),
      ],
    );
  }

  /// 构建分组选择器（SegmentedControl样式）
  Widget _buildGroupSelector() {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: List.generate(widget.groups.length, (index) {
          final group = widget.groups[index];
          final isSelected = index == _currentGroupIndex;

          // 计算当前分组内的图片索引（用于显示）
          final displayIndex = isSelected ? _currentLocalIndex : 0;
          final totalImages = group.imageCount;

          return Expanded(
            child: GestureDetector(
              onTap: () => _switchToGroup(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    '${group.name}${displayIndex + 1}/$totalImages',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? Colors.blue : Colors.grey[700],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  /// 构建图片 PageView（单一连续滚动视图）
  Widget _buildImagePageView() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      itemCount: _globalImages.length,
      itemBuilder: (context, index) {
        final imageInfo = _globalImages[index];
        return _buildImageItem(imageInfo.imagePath);
      },
    );
  }

  /// 构建单个图片项（1:1宽高比）
  Widget _buildImageItem(String imagePath) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildImage(imagePath),
          ),
        ),
      ),
    );
  }

  /// 构建图片组件
  Widget _buildImage(String imagePath) {
    // 判断是网络图片还是本地资源
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return widget.placeholder ?? _buildDefaultPlaceholder();
        },
        errorBuilder: (context, error, stackTrace) {
          return widget.errorWidget ?? _buildDefaultErrorWidget();
        },
      );
    } else {
      // 本地资源图片
      return Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return widget.errorWidget ?? _buildDefaultErrorWidget();
        },
      );
    }
  }

  /// 默认占位符
  Widget _buildDefaultPlaceholder() {
    return Center(
      child: CircularProgressIndicator(
        color: Colors.blue,
      ),
    );
  }

  /// 默认错误占位符
  Widget _buildDefaultErrorWidget() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.broken_image,
          size: 48,
          color: Colors.grey,
        ),
      ),
    );
  }
}
