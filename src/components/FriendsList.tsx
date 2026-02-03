import { useEffect, useState } from 'react';
import { MessageCircle, Trash2 } from 'lucide-react';
import api from '../utils/api';
import { Friend } from '../types';
import DirectChat from './DirectChat';

function FriendsList() {
  const [friends, setFriends] = useState<Friend[]>([]);
  const [selectedFriend, setSelectedFriend] = useState<Friend | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchFriends();
  }, []);

  const fetchFriends = async () => {
    try {
      const response = await api.get('/friends/friends');
      setFriends(response.data);
    } catch (error) {
      console.error('Failed to fetch friends:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleDeleteFriend = async (friendId: string) => {
    if (!confirm('친구를 삭제하시겠습니까?')) return;

    try {
      await api.delete(`/friends/friends/${friendId}`);
      setFriends(friends.filter(f => f.id !== friendId));
      if (selectedFriend?.id === friendId) {
        setSelectedFriend(null);
      }
    } catch (error) {
      console.error('Failed to delete friend:', error);
      alert('친구 삭제 실패');
    }
  };

  if (selectedFriend) {
    return (
      <DirectChat 
        friend={selectedFriend} 
        onBack={() => setSelectedFriend(null)} 
      />
    );
  }

  if (loading) {
    return <div className="text-center py-8 text-gray-600">로딩 중...</div>;
  }

  if (friends.length === 0) {
    return (
      <div className="text-center py-12">
        <p className="text-gray-600 mb-4">아직 친구가 없습니다</p>
        <p className="text-sm text-gray-500">QR 스캔으로 친구를 추가하세요</p>
      </div>
    );
  }

  return (
    <div>
      <h2 className="text-2xl font-bold text-gray-800 mb-4">친구 목록</h2>
      <div className="space-y-2">
        {friends.map(friend => (
          <div
            key={friend.id}
            className="flex items-center justify-between p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors"
          >
            <div className="flex-1">
              <p className="font-semibold text-gray-800">{friend.nickname}</p>
              <p className="text-sm text-gray-500">{friend.secret_qr_address}</p>
            </div>
            <div className="flex gap-2">
              <button
                onClick={() => setSelectedFriend(friend)}
                className="p-2 bg-indigo-500 text-white rounded-lg hover:bg-indigo-600 transition-colors"
              >
                <MessageCircle className="w-5 h-5" />
              </button>
              <button
                onClick={() => handleDeleteFriend(friend.id)}
                className="p-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition-colors"
              >
                <Trash2 className="w-5 h-5" />
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

export default FriendsList;
