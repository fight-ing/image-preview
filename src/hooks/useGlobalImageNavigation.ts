import { useMemo } from 'react';
import { ImageGroup, GlobalImageInfo } from '../types';

export function useGlobalImageNavigation(groups: ImageGroup[]) {
  // 创建全局图片索引映射
  const globalImageMap = useMemo(() => {
    const map: GlobalImageInfo[] = [];
    let globalIndex = 0;

    groups.forEach((group, groupIndex) => {
      group.images.forEach((image, localIndex) => {
        map.push({
          globalIndex,
          groupId: group.id,
          groupIndex,
          localIndex,
          image,
        });
        globalIndex++;
      });
    });

    return map;
  }, [groups]);

  // 获取总图片数量
  const totalImages = globalImageMap.length;

  // 根据全局索引获取图片信息
  const getImageByGlobalIndex = (index: number): GlobalImageInfo | null => {
    if (index < 0 || index >= totalImages) {
      return null;
    }
    return globalImageMap[index];
  };

  // 根据分组ID和本地索引获取全局索引
  const getGlobalIndex = (groupId: string, localIndex: number): number => {
    const info = globalImageMap.find(
      (item) => item.groupId === groupId && item.localIndex === localIndex
    );
    return info ? info.globalIndex : -1;
  };

  // 获取当前分组的全局索引范围
  const getGroupRange = (groupId: string): { start: number; end: number } | null => {
    const groupImages = globalImageMap.filter((item) => item.groupId === groupId);
    if (groupImages.length === 0) {
      return null;
    }
    return {
      start: groupImages[0].globalIndex,
      end: groupImages[groupImages.length - 1].globalIndex,
    };
  };

  return {
    globalImageMap,
    totalImages,
    getImageByGlobalIndex,
    getGlobalIndex,
    getGroupRange,
  };
}
