export interface ImageItem {
  id: string;
  url: string;
  title?: string;
  description?: string;
}

export interface ImageGroup {
  id: string;
  name: string;
  images: ImageItem[];
}

export interface GlobalImageInfo {
  globalIndex: number;
  groupId: string;
  groupIndex: number;
  localIndex: number;
  image: ImageItem;
}
