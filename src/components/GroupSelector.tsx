import { ImageGroup } from '../types';
import './GroupSelector.css';

interface GroupSelectorProps {
  groups: ImageGroup[];
  selectedGroupId: string | null;
  onGroupSelect: (groupId: string) => void;
}

export function GroupSelector({
  groups,
  selectedGroupId,
  onGroupSelect,
}: GroupSelectorProps) {
  return (
    <div className="group-selector">
      <h2 className="group-selector-title">图片分组</h2>
      <div className="group-list">
        {groups.map((group) => (
          <button
            key={group.id}
            className={`group-item ${selectedGroupId === group.id ? 'active' : ''}`}
            onClick={() => onGroupSelect(group.id)}
          >
            <span className="group-name">{group.name}</span>
            <span className="group-count">{group.images.length}</span>
          </button>
        ))}
      </div>
    </div>
  );
}
