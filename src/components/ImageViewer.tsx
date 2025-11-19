import { useEffect, useCallback, useState, useRef } from 'react';
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
  const [isTransitioning, setIsTransitioning] = useState(false);
  const [imageLoaded, setImageLoaded] = useState(false);
  const [direction, setDirection] = useState<'prev' | 'next' | null>(null);
  const previousIndexRef = useRef<number>(-1);

  // 重置加载状态当图片变化时
  useEffect(() => {
    if (currentImageInfo && previousIndexRef.current !== currentImageInfo.globalIndex) {
      setImageLoaded(false);
      setIsTransitioning(true);
      previousIndexRef.current = currentImageInfo.globalIndex;

      // 动画完成后重置状态
      const timer = setTimeout(() => {
        setIsTransitioning(false);
        setDirection(null);
      }, 300);

      return () => clearTimeout(timer);
    }
  }, [currentImageInfo]);

  const handlePrev = useCallback(() => {
    if (!isTransitioning) {
      setDirection('prev');
      onNavigate('prev');
    }
  }, [onNavigate, isTransitioning]);

  const handleNext = useCallback(() => {
    if (!isTransitioning) {
      setDirection('next');
      onNavigate('next');
    }
  }, [onNavigate, isTransitioning]);

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

  // 图片加载完成处理
  const handleImageLoad = useCallback(() => {
    setImageLoaded(true);
  }, []);

  if (!currentImageInfo) {
    return null;
  }

  const { image, globalIndex } = currentImageInfo;
  const hasPrev = globalIndex > 0;
  const hasNext = globalIndex < totalImages - 1;

  // 计算动画类名
  const getImageClassName = () => {
    const classes = ['viewer-image'];

    if (isTransitioning) {
      classes.push('viewer-image-transitioning');
      if (direction === 'next') {
        classes.push('viewer-image-slide-in-right');
      } else if (direction === 'prev') {
        classes.push('viewer-image-slide-in-left');
      }
    }

    if (!imageLoaded) {
      classes.push('viewer-image-loading');
    }

    return classes.join(' ');
  };

  return (
    <div className="image-viewer-overlay" onClick={onClose}>
      <div className="image-viewer-container" onClick={(e) => e.stopPropagation()}>
        {/* 关闭按钮 */}
        <button className="viewer-close-btn" onClick={onClose} aria-label="关闭">
          ✕
        </button>

        {/* 图片计数 */}
        <div className="viewer-counter">
          <span>{globalIndex + 1} / {totalImages}</span>
        </div>

        {/* 上一张按钮 */}
        {hasPrev && (
          <button
            className="viewer-nav-btn viewer-nav-prev"
            onClick={handlePrev}
            disabled={isTransitioning}
            aria-label="上一张"
          >
            ‹
          </button>
        )}

        {/* 图片区域 */}
        <div
          className={`viewer-image-container ${isTransitioning ? 'transitioning' : ''}`}
          {...swipeHandlers}
        >
          {!imageLoaded && (
            <div className="viewer-loading">
              <div className="viewer-loading-spinner"></div>
            </div>
          )}
          <img
            src={image.url}
            alt={image.title || ''}
            className={getImageClassName()}
            onLoad={handleImageLoad}
            style={{ opacity: imageLoaded ? 1 : 0 }}
          />
          {imageLoaded && (
            <>
              {image.title && <div className="viewer-title">{image.title}</div>}
              {image.description && (
                <div className="viewer-description">{image.description}</div>
              )}
            </>
          )}
        </div>

        {/* 下一张按钮 */}
        {hasNext && (
          <button
            className="viewer-nav-btn viewer-nav-next"
            onClick={handleNext}
            disabled={isTransitioning}
            aria-label="下一张"
          >
            ›
          </button>
        )}
      </div>
    </div>
  );
}
