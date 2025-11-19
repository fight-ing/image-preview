import 'package:flutter/material.dart';
import '../models/image_group_model.dart';
import '../widgets/grouped_image_preview.dart';

/// 示例页面 - 展示图片分组预览组件的使用
class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  // 示例数据：图片分组
  late List<ImageGroup> _imageGroups;
  String _currentInfo = '';

  @override
  void initState() {
    super.initState();
    _initImageGroups();
  }

  /// 初始化图片分组数据
  void _initImageGroups() {
    _imageGroups = [
      ImageGroup(
        name: '正面',
        images: [
          'https://picsum.photos/400/400?random=1',
          'https://picsum.photos/400/400?random=2',
          'https://picsum.photos/400/400?random=3',
        ],
      ),
      ImageGroup(
        name: '侧面',
        images: [
          'https://picsum.photos/400/400?random=4',
          'https://picsum.photos/400/400?random=5',
        ],
      ),
      ImageGroup(
        name: '底部',
        images: [
          'https://picsum.photos/400/400?random=6',
          'https://picsum.photos/400/400?random=7',
          'https://picsum.photos/400/400?random=8',
          'https://picsum.photos/400/400?random=9',
        ],
      ),
      ImageGroup(
        name: '瑕疵',
        images: [
          'https://picsum.photos/400/400?random=10',
        ],
      ),
    ];
  }

  /// 分组切换回调
  void _onGroupChanged(int groupIndex, int imageIndex) {
    setState(() {
      _currentInfo = '切换到：${_imageGroups[groupIndex].name} - 第${imageIndex + 1}张';
    });
  }

  /// 图片切换回调
  void _onImageChanged(int groupIndex, int imageIndex) {
    setState(() {
      _currentInfo = '${_imageGroups[groupIndex].name} - 第${imageIndex + 1}张';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('图片分组预览组件'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 状态信息显示
          if (_currentInfo.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                _currentInfo,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),

          // 图片分组预览组件
          Expanded(
            child: GroupedImagePreview(
              groups: _imageGroups,
              initialGroupIndex: 0,
              initialImageIndex: 0,
              onGroupChanged: _onGroupChanged,
              onImageChanged: _onImageChanged,
              placeholder: const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: Container(
                color: Colors.grey[200],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.broken_image,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '图片加载失败',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 使用说明
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '使用说明',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 8),
                _buildInstruction('1. 点击顶部标签切换分组'),
                _buildInstruction('2. 左右滑动查看同组内的图片'),
                _buildInstruction('3. 左右滑动也可切换到相邻分组'),
                _buildInstruction('4. 标签显示格式："分组名 当前/总数"'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstruction(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.blue[700],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
