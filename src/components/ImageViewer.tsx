import { useEffect, useCallback } from 'react';
import { useSwipe } from '../hooks/useSwipe';
import { GlobalImageInfo } from '../types';
import './ImageViewer.css';

interface ImageViewerProps {
  currentImageInfo: GlobalImageInfo | null;
  totalImages: number;
  onNavigate: (direction: 'prev' | 'next') => void;
  onClose: () => void;
}

export function ImageViewer({
  currentImageInfo,
  totalImages,
  onNavigate,
  onClose,
}: ImageViewerProps) {
  const handlePrev = useCallback(() => {
    onNavigate('prev');
  }, [onNavigate]);

  const handleNext = useCallback(() => {
    onNavigate('next');
  }, [onNavigate]);

  const swipeHandlers = useSwipe({
    onSwipeLeft: handleNext,
    onSwipeRight: handlePrev,
    threshold: 50,
  });

  // 键盘导航
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      switch (e.key) {
        case 'ArrowLeft':
          handlePrev();
          break;
        case 'ArrowRight':
          handleNext();
          break;
        case 'Escape':
          onClose();
          break;
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [handlePrev, handleNext, onClose]);

  if (!currentImageInfo) {
    return null;
  }

  const { image, globalIndex } = currentImageInfo;
  const hasPrev = globalIndex > 0;
  const hasNext = globalIndex < totalImages - 1;

  return (
    <div className="image-viewer-overlay" onClick={onClose}>
      <div className="image-viewer-container" onClick={(e) => e.stopPropagation()}>
        {/* 关闭按钮 */}
        <button className="viewer-close-btn" onClick={onClose} aria-label="关闭">
          ✕
        </button>

        {/* 图片计数 */}
        <div className="viewer-counter">
          {globalIndex + 1} / {totalImages}
        </div>

        {/* 上一张按钮 */}
        {hasPrev && (
          <button
            className="viewer-nav-btn viewer-nav-prev"
            onClick={handlePrev}
            aria-label="上一张"
          >
            ‹
          </button>
        )}

        {/* 图片区域 */}
        <div className="viewer-image-container" {...swipeHandlers}>
          <img src={image.url} alt={image.title || ''} className="viewer-image" />
          {image.title && <div className="viewer-title">{image.title}</div>}
          {image.description && (
            <div className="viewer-description">{image.description}</div>
          )}
        </div>

        {/* 下一张按钮 */}
        {hasNext && (
          <button
            className="viewer-nav-btn viewer-nav-next"
            onClick={handleNext}
            aria-label="下一张"
          >
            ›
          </button>
        )}
      </div>
    </div>
  );
}
