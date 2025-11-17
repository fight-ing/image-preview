/**
 * 图片预览组件 - 支持跨分组滑动
 */
class ImagePreview {
    constructor(options = {}) {
        this.options = {
            crossGroup: true, // 是否支持跨分组滑动
            showGroupInfo: true, // 是否显示分组信息
            triggerSelector: '.preview-trigger', // 触发预览的图片选择器
            ...options
        };

        this.images = []; // 所有图片数组
        this.currentIndex = 0; // 当前图片索引
        this.modal = null;
        this.previewImage = null;
        this.imageCounter = null;
        this.imageGroup = null;

        this.init();
    }

    init() {
        this.collectImages();
        this.setupModal();
        this.bindEvents();
    }

    /**
     * 收集所有图片信息（包括分组）
     */
    collectImages() {
        const imageElements = document.querySelectorAll(this.options.triggerSelector);

        imageElements.forEach((img, index) => {
            const group = img.closest('[data-group]');
            const groupName = group ? group.getAttribute('data-group') : 'default';

            this.images.push({
                element: img,
                src: img.src,
                alt: img.alt || `图片 ${index + 1}`,
                group: groupName,
                originalIndex: index
            });
        });
    }

    /**
     * 设置预览模态框
     */
    setupModal() {
        this.modal = document.getElementById('imagePreview');
        this.previewImage = document.getElementById('previewImage');
        this.imageCounter = document.getElementById('imageCounter');
        this.imageGroup = document.getElementById('imageGroup');
    }

    /**
     * 绑定事件
     */
    bindEvents() {
        // 为每个图片添加点击事件
        this.images.forEach((imgData, index) => {
            imgData.element.addEventListener('click', () => {
                this.open(index);
            });
        });

        // 关闭按钮
        const closeBtn = this.modal.querySelector('.preview-close');
        closeBtn.addEventListener('click', () => this.close());

        // 遮罩层点击关闭
        const overlay = this.modal.querySelector('.preview-overlay');
        overlay.addEventListener('click', () => this.close());

        // 上一张按钮
        const prevBtn = this.modal.querySelector('.preview-prev');
        prevBtn.addEventListener('click', () => this.prev());

        // 下一张按钮
        const nextBtn = this.modal.querySelector('.preview-next');
        nextBtn.addEventListener('click', () => this.next());

        // 键盘事件
        document.addEventListener('keydown', (e) => {
            if (!this.modal.classList.contains('active')) return;

            switch(e.key) {
                case 'Escape':
                    this.close();
                    break;
                case 'ArrowLeft':
                    this.prev();
                    break;
                case 'ArrowRight':
                    this.next();
                    break;
            }
        });

        // 触摸滑动支持
        this.setupTouchEvents();
    }

    /**
     * 设置触摸事件支持移动端滑动
     */
    setupTouchEvents() {
        let touchStartX = 0;
        let touchEndX = 0;

        this.modal.addEventListener('touchstart', (e) => {
            touchStartX = e.changedTouches[0].screenX;
        });

        this.modal.addEventListener('touchend', (e) => {
            touchEndX = e.changedTouches[0].screenX;
            this.handleSwipe(touchStartX, touchEndX);
        });
    }

    /**
     * 处理滑动手势
     */
    handleSwipe(startX, endX) {
        const threshold = 50; // 滑动阈值
        const diff = startX - endX;

        if (Math.abs(diff) > threshold) {
            if (diff > 0) {
                // 向左滑动，下一张
                this.next();
            } else {
                // 向右滑动，上一张
                this.prev();
            }
        }
    }

    /**
     * 打开预览
     */
    open(index) {
        this.currentIndex = index;
        this.modal.classList.add('active');
        this.updatePreview();
        document.body.style.overflow = 'hidden'; // 禁止背景滚动
    }

    /**
     * 关闭预览
     */
    close() {
        this.modal.classList.remove('active');
        document.body.style.overflow = ''; // 恢复背景滚动
    }

    /**
     * 上一张图片（支持跨分组）
     */
    prev() {
        if (this.options.crossGroup) {
            // 跨分组：循环到上一张，如果是第一张则到最后一张
            this.currentIndex = (this.currentIndex - 1 + this.images.length) % this.images.length;
        } else {
            // 不跨分组：仅在当前分组内切换
            const currentGroup = this.images[this.currentIndex].group;
            const groupImages = this.images.filter(img => img.group === currentGroup);
            const currentGroupIndex = groupImages.findIndex(img => img.originalIndex === this.images[this.currentIndex].originalIndex);
            const newGroupIndex = (currentGroupIndex - 1 + groupImages.length) % groupImages.length;
            this.currentIndex = this.images.findIndex(img => img.originalIndex === groupImages[newGroupIndex].originalIndex);
        }

        this.updatePreview();
    }

    /**
     * 下一张图片（支持跨分组）
     */
    next() {
        if (this.options.crossGroup) {
            // 跨分组：循环到下一张，如果是最后一张则到第一张
            this.currentIndex = (this.currentIndex + 1) % this.images.length;
        } else {
            // 不跨分组：仅在当前分组内切换
            const currentGroup = this.images[this.currentIndex].group;
            const groupImages = this.images.filter(img => img.group === currentGroup);
            const currentGroupIndex = groupImages.findIndex(img => img.originalIndex === this.images[this.currentIndex].originalIndex);
            const newGroupIndex = (currentGroupIndex + 1) % groupImages.length;
            this.currentIndex = this.images.findIndex(img => img.originalIndex === groupImages[newGroupIndex].originalIndex);
        }

        this.updatePreview();
    }

    /**
     * 更新预览显示
     */
    updatePreview() {
        const currentImage = this.images[this.currentIndex];

        // 更新图片
        this.previewImage.src = currentImage.src;
        this.previewImage.alt = currentImage.alt;

        // 更新计数器
        this.imageCounter.textContent = `${this.currentIndex + 1} / ${this.images.length}`;

        // 更新分组信息
        if (this.options.showGroupInfo) {
            this.imageGroup.textContent = `分组: ${this.getGroupDisplayName(currentImage.group)}`;
            this.imageGroup.style.display = 'block';
        } else {
            this.imageGroup.style.display = 'none';
        }
    }

    /**
     * 获取分组显示名称
     */
    getGroupDisplayName(groupName) {
        const groupNames = {
            'landscape': '风景照片',
            'city': '城市建筑',
            'nature': '自然景观',
            'default': '默认分组'
        };

        return groupNames[groupName] || groupName;
    }

    /**
     * 切换跨分组模式
     */
    toggleCrossGroup() {
        this.options.crossGroup = !this.options.crossGroup;
        console.log(`跨分组滑动: ${this.options.crossGroup ? '已启用' : '已禁用'}`);
    }

    /**
     * 获取当前图片信息
     */
    getCurrentImage() {
        return this.images[this.currentIndex];
    }

    /**
     * 销毁实例
     */
    destroy() {
        // 移除所有事件监听器
        this.images.forEach((imgData) => {
            imgData.element.removeEventListener('click', this.open);
        });

        this.images = [];
        this.currentIndex = 0;
    }
}
