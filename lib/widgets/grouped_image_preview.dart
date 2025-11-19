import 'package:flutter/material.dart';
import '../models/image_group_model.dart';

/// 图片分组预览组件
///
/// 功能：
/// 1. 显示分组图片，宽高比1:1
/// 2. 支持左右滑动切换图片
/// 3. 支持向前或向后切换分组
/// 4. 跨分组连续滑动：滑动到分组最后一张时自动切换到下一分组
/// 5. 显示分组标题与图片数量："正面1/3"
/// 6. SegmentedControl样式，可点击切换分组，且同步滑动图片
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

class _GroupedImagePreviewState extends State<GroupedImagePreview> {
  late PageController _pageController;
  late int _currentGroupIndex;
  late int _currentImageIndex;

  // 用于存储每个分组的 PageController
  late Map<int, PageController> _groupPageControllers;

  @override
  void initState() {
    super.initState();
    _currentGroupIndex = widget.initialGroupIndex;
    _currentImageIndex = widget.initialImageIndex;

    // 初始化分组页面控制器
    _pageController = PageController(initialPage: _currentGroupIndex);

    // 初始化每个分组的图片页面控制器
    _groupPageControllers = {};
    for (int i = 0; i < widget.groups.length; i++) {
      _groupPageControllers[i] = PageController(
        initialPage: i == _currentGroupIndex ? _currentImageIndex : 0,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _groupPageControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// 切换到指定分组
  void _switchToGroup(int groupIndex) {
    if (groupIndex == _currentGroupIndex) return;

    setState(() {
      _currentGroupIndex = groupIndex;
      _currentImageIndex = 0;
    });

    _pageController.animateToPage(
      groupIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    widget.onGroupChanged?.call(groupIndex, 0);
  }

  /// 当前分组的图片切换
  void _onImagePageChanged(int imageIndex) {
    setState(() {
      _currentImageIndex = imageIndex;
    });

    widget.onImageChanged?.call(_currentGroupIndex, imageIndex);
  }

  /// 处理跨分组滑动
  bool _handleCrossGroupSwipe(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final metrics = notification.metrics;
      final currentGroup = widget.groups[_currentGroupIndex];

      // 检测是否滑动到最后一张（向右滑）
      if (_currentImageIndex == currentGroup.imageCount - 1 &&
          metrics.pixels >= metrics.maxScrollExtent) {
        // 如果不是最后一个分组，切换到下一个分组
        if (_currentGroupIndex < widget.groups.length - 1) {
          _switchToGroup(_currentGroupIndex + 1);
          return true;
        }
      }

      // 检测是否滑动到第一张（向左滑）
      if (_currentImageIndex == 0 && metrics.pixels <= metrics.minScrollExtent) {
        // 如果不是第一个分组，切换到上一个分组的最后一张
        if (_currentGroupIndex > 0) {
          final previousGroupIndex = _currentGroupIndex - 1;
          final previousGroup = widget.groups[previousGroupIndex];

          setState(() {
            _currentGroupIndex = previousGroupIndex;
            _currentImageIndex = previousGroup.imageCount - 1;
          });

          _pageController.animateToPage(
            previousGroupIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );

          // 跳转到上一个分组的最后一张图片
          Future.delayed(const Duration(milliseconds: 100), () {
            _groupPageControllers[previousGroupIndex]?.jumpToPage(previousGroup.imageCount - 1);
          });

          widget.onGroupChanged?.call(previousGroupIndex, previousGroup.imageCount - 1);
          return true;
        }
      }
    }

    return false;
  }

  /// 当分组页面改变时
  void _onGroupPageChanged(int groupIndex) {
    final controller = _groupPageControllers[groupIndex];
    final imageIndex = controller?.page?.round() ?? 0;

    setState(() {
      _currentGroupIndex = groupIndex;
      _currentImageIndex = imageIndex;
    });

    widget.onGroupChanged?.call(groupIndex, imageIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.groups.isEmpty) {
      return const Center(
        child: Text('暂无图片'),
      );
    }

    return Column(
      children: [
        // 分组选择器
        _buildGroupSelector(),
        const SizedBox(height: 16),

        // 图片预览区域
        Expanded(
          child: _buildImagePreview(),
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
          final imageIndex = index == _currentGroupIndex ? _currentImageIndex : 0;
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
                    '${ group.name}${imageIndex + 1}/$totalImages',
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

  /// 构建图片预览区域
  Widget _buildImagePreview() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: _onGroupPageChanged,
      itemCount: widget.groups.length,
      itemBuilder: (context, groupIndex) {
        final group = widget.groups[groupIndex];

        if (group.isEmpty) {
          return const Center(
            child: Text('该分组暂无图片'),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (groupIndex == _currentGroupIndex) {
              return _handleCrossGroupSwipe(notification);
            }
            return false;
          },
          child: PageView.builder(
            controller: _groupPageControllers[groupIndex],
            onPageChanged: (imageIndex) {
              if (groupIndex == _currentGroupIndex) {
                _onImagePageChanged(imageIndex);
              }
            },
            itemCount: group.imageCount,
            itemBuilder: (context, imageIndex) {
              return _buildImageItem(group.images[imageIndex]);
            },
          ),
        );
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
