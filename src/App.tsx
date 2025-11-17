import { useState, useCallback, useEffect } from 'react';
import { GroupSelector } from './components/GroupSelector';
import { ImageGrid } from './components/ImageGrid';
import { ImageViewer } from './components/ImageViewer';
import { useGlobalImageNavigation } from './hooks/useGlobalImageNavigation';
import { ImageGroup } from './types';
import { sampleData } from './data/sampleData';
import './App.css';

function App() {
  const [groups] = useState<ImageGroup[]>(sampleData);
  const [selectedGroupId, setSelectedGroupId] = useState<string | null>(
    groups.length > 0 ? groups[0].id : null
  );
  const [viewerOpen, setViewerOpen] = useState(false);
  const [currentGlobalIndex, setCurrentGlobalIndex] = useState<number>(-1);

  const {
    globalImageMap,
    totalImages,
    getImageByGlobalIndex,
    getGlobalIndex,
  } = useGlobalImageNavigation(groups);

  // 当全局索引变化时，自动更新选中的分组
  useEffect(() => {
    if (currentGlobalIndex >= 0 && currentGlobalIndex < totalImages) {
      const imageInfo = getImageByGlobalIndex(currentGlobalIndex);
      if (imageInfo && imageInfo.groupId !== selectedGroupId) {
        setSelectedGroupId(imageInfo.groupId);
      }
    }
  }, [currentGlobalIndex, totalImages, getImageByGlobalIndex, selectedGroupId]);

  // 处理分组选择
  const handleGroupSelect = useCallback((groupId: string) => {
    setSelectedGroupId(groupId);
  }, []);

  // 处理图片点击
  const handleImageClick = useCallback(
    (localIndex: number) => {
      if (!selectedGroupId) return;

      const globalIndex = getGlobalIndex(selectedGroupId, localIndex);
      if (globalIndex >= 0) {
        setCurrentGlobalIndex(globalIndex);
        setViewerOpen(true);
      }
    },
    [selectedGroupId, getGlobalIndex]
  );

  // 处理全局导航
  const handleNavigate = useCallback(
    (direction: 'prev' | 'next') => {
      const newIndex =
        direction === 'prev' ? currentGlobalIndex - 1 : currentGlobalIndex + 1;

      if (newIndex >= 0 && newIndex < totalImages) {
        setCurrentGlobalIndex(newIndex);
      }
    },
    [currentGlobalIndex, totalImages]
  );

  // 关闭查看器
  const handleCloseViewer = useCallback(() => {
    setViewerOpen(false);
  }, []);

  // 获取当前选中分组
  const selectedGroup = groups.find((g) => g.id === selectedGroupId);

  // 获取当前图片信息
  const currentImageInfo =
    currentGlobalIndex >= 0 ? getImageByGlobalIndex(currentGlobalIndex) : null;

  return (
    <div className="app">
      <header className="app-header">
        <h1>图片预览 - 全局滑动</h1>
        <p className="app-subtitle">
          支持跨分组滑动浏览，自动切换分组选择
        </p>
      </header>

      <main className="app-main">
        <GroupSelector
          groups={groups}
          selectedGroupId={selectedGroupId}
          onGroupSelect={handleGroupSelect}
        />

        {selectedGroup && (
          <div className="group-content">
            <h3 className="group-content-title">
              {selectedGroup.name}
              <span className="group-content-count">
                {selectedGroup.images.length} 张图片
              </span>
            </h3>
            <ImageGrid
              images={selectedGroup.images}
              onImageClick={handleImageClick}
            />
          </div>
        )}

        {!selectedGroup && groups.length === 0 && (
          <div className="empty-state">暂无图片分组</div>
        )}
      </main>

      {viewerOpen && currentImageInfo && (
        <ImageViewer
          currentImageInfo={currentImageInfo}
          totalImages={totalImages}
          onNavigate={handleNavigate}
          onClose={handleCloseViewer}
        />
      )}
    </div>
  );
}

export default App;
