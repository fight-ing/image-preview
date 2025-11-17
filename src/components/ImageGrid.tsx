import { ImageItem } from '../types';
import './ImageGrid.css';

interface ImageGridProps {
  images: ImageItem[];
  onImageClick: (index: number) => void;
}

export function ImageGrid({ images, onImageClick }: ImageGridProps) {
  return (
    <div className="image-grid">
      {images.map((image, index) => (
        <div
          key={image.id}
          className="image-grid-item"
          onClick={() => onImageClick(index)}
        >
          <img src={image.url} alt={image.title || ''} className="grid-image" />
          {image.title && <div className="grid-image-title">{image.title}</div>}
        </div>
      ))}
    </div>
  );
}
