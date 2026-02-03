import { useEffect, useRef, useState } from 'react';
import { Html5Qrcode } from 'html5-qrcode';
import { Camera, AlertCircle } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

function QRScanner() {
  const [isScanning, setIsScanning] = useState(false);
  const [error, setError] = useState('');
  const scannerRef = useRef<Html5Qrcode | null>(null);
  const navigate = useNavigate();
  const elementId = 'qr-scanner';

  const startScanning = async () => {
    try {
      setError('');
      const scanner = new Html5Qrcode(elementId);
      scannerRef.current = scanner;

      await scanner.start(
        { facingMode: 'environment' },
        { fps: 10, qrbox: { width: 250, height: 250 } },
        (decodedText) => {
          try {
            // Check if it's a Securet URL
            const url = new URL(decodedText);
            
            if (url.hostname.includes('securet.kr')) {
              // Extract token from URL
              const token = url.searchParams.get('token');
              
              scanner.stop().then(() => {
                // Pass the full URL
                navigate(`/add-friend?url=${encodeURIComponent(decodedText)}`);
              });
            } else {
              setError('유효한 시큐렛 QR 코드가 아닙니다');
            }
          } catch (e) {
            setError('QR 코드 형식이 올바르지 않습니다');
          }
        },
        () => {}
      );

      setIsScanning(true);
    } catch (err) {
      setError('카메라 권한을 허용해주세요');
      setIsScanning(false);
    }
  };

  const stopScanning = () => {
    if (scannerRef.current) {
      scannerRef.current.stop().then(() => {
        setIsScanning(false);
      });
    }
  };

  useEffect(() => {
    return () => {
      if (scannerRef.current) {
        scannerRef.current.stop();
      }
    };
  }, []);

  return (
    <div className="text-center">
      <h2 className="text-2xl font-bold text-gray-800 mb-4">QR 코드 스캔</h2>
      
      <div 
        id={elementId} 
        className="mx-auto rounded-lg overflow-hidden mb-4"
        style={{ minHeight: isScanning ? '300px' : '0' }}
      />
      
      {error && (
        <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded-lg flex items-center gap-2 text-red-700">
          <AlertCircle className="w-5 h-5" />
          <span className="text-sm">{error}</span>
        </div>
      )}
      
      {!isScanning ? (
        <button
          onClick={startScanning}
          className="inline-flex items-center gap-2 bg-gradient-to-r from-indigo-500 to-purple-600 text-white px-6 py-3 rounded-lg font-semibold hover:from-indigo-600 hover:to-purple-700 transition-all duration-200 shadow-lg"
        >
          <Camera className="w-5 h-5" />
          스캔 시작
        </button>
      ) : (
        <button
          onClick={stopScanning}
          className="bg-red-500 text-white px-6 py-3 rounded-lg font-semibold hover:bg-red-600 transition-all duration-200 shadow-lg"
        >
          스캔 중지
        </button>
      )}
    </div>
  );
}

export default QRScanner;
