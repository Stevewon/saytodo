import { Download, Copy } from 'lucide-react';
import { useAuthStore } from '../store/authStore';
import { useState } from 'react';

function MyQRCode() {
  const { user } = useAuthStore();
  const [copied, setCopied] = useState(false);

  const handleDownload = () => {
    if (!user?.qrCode) return;
    
    const link = document.createElement('a');
    link.download = `securet-qr-${user.nickname}.png`;
    link.href = user.qrCode;
    link.click();
  };

  const handleCopyUrl = () => {
    if (!user?.secretQRAddress) return;
    
    navigator.clipboard.writeText(user.secretQRAddress);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  // Extract token from URL for display
  const getDisplayToken = () => {
    try {
      const url = new URL(user?.secretQRAddress || '');
      const token = url.searchParams.get('token');
      if (token) {
        return token.substring(0, 30) + '...';
      }
    } catch (e) {}
    return user?.secretQRAddress;
  };

  return (
    <div className="text-center">
      <h2 className="text-2xl font-bold text-gray-800 mb-4">내 시큐렛 QR 코드</h2>
      <p className="text-gray-600 mb-6">이 QR 코드를 공유하여 친구를 추가하세요</p>
      
      <div className="bg-white p-6 rounded-xl shadow-lg inline-block mb-6">
        <img src={user?.qrCode} alt="My QR Code" className="w-64 h-64" />
      </div>

      <div className="mb-6 max-w-md mx-auto">
        <div className="bg-indigo-50 rounded-lg p-4">
          <p className="text-xs text-gray-500 mb-1">시큐렛 QR 주소 (Token)</p>
          <p className="text-sm font-mono text-indigo-600 break-all">
            {getDisplayToken()}
          </p>
        </div>
      </div>

      <div className="flex gap-3 justify-center">
        <button
          onClick={handleDownload}
          className="inline-flex items-center gap-2 bg-gradient-to-r from-indigo-500 to-purple-600 text-white px-6 py-3 rounded-lg font-semibold hover:from-indigo-600 hover:to-purple-700 transition-all duration-200 shadow-lg"
        >
          <Download className="w-5 h-5" />
          QR 코드 저장
        </button>
        
        <button
          onClick={handleCopyUrl}
          className="inline-flex items-center gap-2 bg-gray-200 text-gray-700 px-6 py-3 rounded-lg font-semibold hover:bg-gray-300 transition-all duration-200"
        >
          <Copy className="w-5 h-5" />
          {copied ? '복사됨!' : 'URL 복사'}
        </button>
      </div>
    </div>
  );
}

export default MyQRCode;
