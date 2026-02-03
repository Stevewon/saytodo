import { useEffect, useState } from 'react';
import { useNavigate, useSearchParams } from 'react-router-dom';
import { UserPlus, QrCode } from 'lucide-react';
import api from '../utils/api';

function AddFriend() {
  const [searchParams] = useSearchParams();
  const [user, setUser] = useState<any>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [adding, setAdding] = useState(false);
  const navigate = useNavigate();
  const sqr = searchParams.get('sqr');

  useEffect(() => {
    if (sqr) {
      fetchUser();
    }
  }, [sqr]);

  const fetchUser = async () => {
    try {
      const response = await api.get(`/friends/by-sqr/${sqr}`);
      setUser(response.data);
    } catch (err: any) {
      setError(err.response?.data?.error || '사용자를 찾을 수 없습니다');
    } finally {
      setLoading(false);
    }
  };

  const handleAddFriend = async () => {
    setAdding(true);
    try {
      await api.post('/friends/add-friend', { sqrAddress: sqr });
      alert('친구 추가 완료!');
      navigate('/');
    } catch (err: any) {
      setError(err.response?.data?.error || '친구 추가 실패');
    } finally {
      setAdding(false);
    }
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-indigo-50 to-purple-50 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-indigo-600 mx-auto mb-4"></div>
          <p className="text-gray-600">확인 중...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-50 to-purple-50 flex items-center justify-center p-4">
      <div className="bg-white rounded-2xl shadow-2xl p-8 max-w-md w-full">
        <div className="text-center mb-6">
          <div className="inline-flex items-center justify-center w-16 h-16 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-full mb-4">
            <UserPlus className="w-8 h-8 text-white" />
          </div>
          <h1 className="text-2xl font-bold text-gray-800 mb-2">친구 추가</h1>
        </div>

        {error && !user && (
          <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg text-sm mb-4">
            {error}
          </div>
        )}

        {user && (
          <div className="text-center">
            <div className="bg-indigo-50 rounded-xl p-6 mb-6">
              <QrCode className="w-12 h-12 text-indigo-600 mx-auto mb-3" />
              <p className="text-2xl font-bold text-gray-800 mb-1">{user.nickname}</p>
              <p className="text-sm text-gray-500">{user.secretQRAddress}</p>
            </div>

            {user.isAlreadyFriend ? (
              <div className="bg-yellow-50 border border-yellow-200 text-yellow-700 px-4 py-3 rounded-lg text-sm mb-4">
                이미 친구입니다
              </div>
            ) : (
              <button
                onClick={handleAddFriend}
                disabled={adding}
                className="w-full bg-gradient-to-r from-indigo-500 to-purple-600 text-white px-6 py-3 rounded-lg font-semibold hover:from-indigo-600 hover:to-purple-700 transition-all duration-200 shadow-lg disabled:opacity-50 mb-4"
              >
                {adding ? '추가 중...' : '친구 추가하기'}
              </button>
            )}

            <button
              onClick={() => navigate('/')}
              className="w-full bg-gray-200 text-gray-700 px-6 py-3 rounded-lg font-semibold hover:bg-gray-300 transition-all duration-200"
            >
              돌아가기
            </button>
          </div>
        )}
      </div>
    </div>
  );
}

export default AddFriend;
