import { useState, useEffect } from 'react';
import { QrCode, Users, MessageCircle, LogOut, UserPlus, Scan } from 'lucide-react';
import { useAuthStore } from '../store/authStore';
import { initSocket, disconnectSocket } from '../utils/socket';
import MyQRCode from '../components/MyQRCode';
import FriendsList from '../components/FriendsList';
import GroupsList from '../components/GroupsList';
import QRScanner from '../components/QRScanner';

type Tab = 'friends' | 'groups' | 'myqr' | 'scan';

function Dashboard() {
  const { user, logout } = useAuthStore();
  const [activeTab, setActiveTab] = useState<Tab>('friends');

  useEffect(() => {
    const socket = initSocket();
    
    return () => {
      disconnectSocket();
    };
  }, []);

  const handleLogout = () => {
    disconnectSocket();
    logout();
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-indigo-50 to-purple-50">
      {/* Header */}
      <div className="bg-gradient-to-r from-indigo-500 to-purple-600 text-white shadow-lg">
        <div className="max-w-4xl mx-auto px-4 py-4 flex items-center justify-between">
          <div>
            <h1 className="text-xl font-bold">{user?.nickname}</h1>
            <p className="text-sm text-indigo-100">{user?.secretQRAddress}</p>
          </div>
          <button
            onClick={handleLogout}
            className="flex items-center gap-2 bg-white bg-opacity-20 hover:bg-opacity-30 px-4 py-2 rounded-lg transition-all"
          >
            <LogOut className="w-4 h-4" />
            로그아웃
          </button>
        </div>

        {/* Tab Navigation */}
        <div className="max-w-4xl mx-auto px-4">
          <div className="flex gap-2 pb-2">
            <button
              onClick={() => setActiveTab('friends')}
              className={`flex items-center gap-2 px-4 py-2 rounded-t-lg transition-all ${
                activeTab === 'friends'
                  ? 'bg-white text-indigo-600'
                  : 'bg-white bg-opacity-10 text-white hover:bg-opacity-20'
              }`}
            >
              <Users className="w-4 h-4" />
              친구
            </button>
            <button
              onClick={() => setActiveTab('groups')}
              className={`flex items-center gap-2 px-4 py-2 rounded-t-lg transition-all ${
                activeTab === 'groups'
                  ? 'bg-white text-indigo-600'
                  : 'bg-white bg-opacity-10 text-white hover:bg-opacity-20'
              }`}
            >
              <MessageCircle className="w-4 h-4" />
              그룹
            </button>
            <button
              onClick={() => setActiveTab('myqr')}
              className={`flex items-center gap-2 px-4 py-2 rounded-t-lg transition-all ${
                activeTab === 'myqr'
                  ? 'bg-white text-indigo-600'
                  : 'bg-white bg-opacity-10 text-white hover:bg-opacity-20'
              }`}
            >
              <QrCode className="w-4 h-4" />
              내 QR
            </button>
            <button
              onClick={() => setActiveTab('scan')}
              className={`flex items-center gap-2 px-4 py-2 rounded-t-lg transition-all ${
                activeTab === 'scan'
                  ? 'bg-white text-indigo-600'
                  : 'bg-white bg-opacity-10 text-white hover:bg-opacity-20'
              }`}
            >
              <Scan className="w-4 h-4" />
              QR 스캔
            </button>
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="max-w-4xl mx-auto p-4">
        <div className="bg-white rounded-2xl shadow-xl p-6 min-h-[500px]">
          {activeTab === 'friends' && <FriendsList />}
          {activeTab === 'groups' && <GroupsList />}
          {activeTab === 'myqr' && <MyQRCode />}
          {activeTab === 'scan' && <QRScanner />}
        </div>
      </div>
    </div>
  );
}

export default Dashboard;
