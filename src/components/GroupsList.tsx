import { useEffect, useState } from 'react';
import { Plus, MessageCircle } from 'lucide-react';
import api from '../utils/api';
import { GroupRoom } from '../types';

function GroupsList() {
  const [groups, setGroups] = useState<GroupRoom[]>([]);
  const [loading, setLoading] = useState(true);
  const [showCreate, setShowCreate] = useState(false);
  const [groupName, setGroupName] = useState('');
  const [memberEmails, setMemberEmails] = useState('');

  useEffect(() => {
    fetchGroups();
  }, []);

  const fetchGroups = async () => {
    try {
      const response = await api.get('/groups/my-rooms');
      setGroups(response.data);
    } catch (error) {
      console.error('Failed to fetch groups:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleCreateGroup = async (e: React.FormEvent) => {
    e.preventDefault();
    
    const emails = memberEmails.split(',').map(e => e.trim()).filter(e => e);
    
    try {
      await api.post('/groups/create', {
        name: groupName,
        memberEmails: emails,
      });
      
      setGroupName('');
      setMemberEmails('');
      setShowCreate(false);
      fetchGroups();
    } catch (error: any) {
      alert(error.response?.data?.error || '그룹 생성 실패');
    }
  };

  if (loading) {
    return <div className="text-center py-8 text-gray-600">로딩 중...</div>;
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-4">
        <h2 className="text-2xl font-bold text-gray-800">그룹 채팅</h2>
        <button
          onClick={() => setShowCreate(!showCreate)}
          className="flex items-center gap-2 bg-indigo-500 text-white px-4 py-2 rounded-lg hover:bg-indigo-600"
        >
          <Plus className="w-4 h-4" />
          그룹 만들기
        </button>
      </div>

      {showCreate && (
        <form onSubmit={handleCreateGroup} className="mb-6 p-4 bg-gray-50 rounded-lg">
          <div className="mb-3">
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              그룹명
            </label>
            <input
              type="text"
              value={groupName}
              onChange={(e) => setGroupName(e.target.value)}
              required
              className="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:border-indigo-500 focus:outline-none"
              placeholder="그룹 이름"
            />
          </div>
          <div className="mb-3">
            <label className="block text-sm font-semibold text-gray-700 mb-2">
              멤버 이메일 (쉼표로 구분)
            </label>
            <input
              type="text"
              value={memberEmails}
              onChange={(e) => setMemberEmails(e.target.value)}
              required
              className="w-full px-4 py-2 border-2 border-gray-200 rounded-lg focus:border-indigo-500 focus:outline-none"
              placeholder="user1@email.com, user2@email.com"
            />
          </div>
          <div className="flex gap-2">
            <button
              type="submit"
              className="flex-1 bg-indigo-500 text-white px-4 py-2 rounded-lg hover:bg-indigo-600"
            >
              생성
            </button>
            <button
              type="button"
              onClick={() => setShowCreate(false)}
              className="flex-1 bg-gray-200 text-gray-700 px-4 py-2 rounded-lg hover:bg-gray-300"
            >
              취소
            </button>
          </div>
        </form>
      )}

      {groups.length === 0 ? (
        <div className="text-center py-12">
          <p className="text-gray-600 mb-4">그룹이 없습니다</p>
          <p className="text-sm text-gray-500">이메일로 친구를 초대하여 그룹을 만드세요</p>
        </div>
      ) : (
        <div className="space-y-2">
          {groups.map(group => (
            <div
              key={group.id}
              className="flex items-center justify-between p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors"
            >
              <div className="flex-1">
                <p className="font-semibold text-gray-800">{group.name}</p>
                <p className="text-sm text-gray-500">
                  멤버 {group.member_count}명 · {group.creator_nickname}
                </p>
              </div>
              <button className="p-2 bg-indigo-500 text-white rounded-lg hover:bg-indigo-600">
                <MessageCircle className="w-5 h-5" />
              </button>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

export default GroupsList;
