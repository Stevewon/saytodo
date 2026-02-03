import { useEffect, useState, useRef } from 'react';
import { ArrowLeft, Send, Paperclip, Phone, Video } from 'lucide-react';
import { Friend, DirectMessage } from '../types';
import { getSocket } from '../utils/socket';
import { useAuthStore } from '../store/authStore';
import api from '../utils/api';
import { format } from 'date-fns';

interface Props {
  friend: Friend;
  onBack: () => void;
}

function DirectChat({ friend, onBack }: Props) {
  const { user } = useAuthStore();
  const [messages, setMessages] = useState<DirectMessage[]>([]);
  const [inputMessage, setInputMessage] = useState('');
  const [uploading, setUploading] = useState(false);
  const messagesEndRef = useRef<HTMLDivElement>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    const socket = getSocket();
    if (!socket) return;

    socket.emit('join-direct-chat', { friendId: friend.id });

    socket.on('direct-message', (message: DirectMessage) => {
      setMessages(prev => [...prev, message]);
    });

    return () => {
      socket.off('direct-message');
    };
  }, [friend.id]);

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  const handleSend = () => {
    if (!inputMessage.trim()) return;

    const socket = getSocket();
    if (socket) {
      socket.emit('send-direct-message', {
        receiverId: friend.id,
        message: inputMessage.trim(),
      });
      setInputMessage('');
    }
  };

  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;

    setUploading(true);
    const formData = new FormData();
    formData.append('file', file);

    try {
      const response = await api.post('/upload', formData);
      const socket = getSocket();
      if (socket) {
        socket.emit('send-direct-message', {
          receiverId: friend.id,
          fileUrl: response.data.fileUrl,
          fileName: response.data.fileName,
          fileType: response.data.fileType,
        });
      }
    } catch (error) {
      alert('파일 업로드 실패');
    } finally {
      setUploading(false);
    }
  };

  return (
    <div className="flex flex-col h-[600px]">
      <div className="flex items-center justify-between border-b pb-4 mb-4">
        <div className="flex items-center gap-3">
          <button onClick={onBack} className="p-2 hover:bg-gray-100 rounded-lg">
            <ArrowLeft className="w-5 h-5" />
          </button>
          <div>
            <p className="font-bold text-gray-800">{friend.nickname}</p>
            <p className="text-sm text-gray-500">{friend.secret_qr_address}</p>
          </div>
        </div>
        <div className="flex gap-2">
          <button className="p-2 bg-green-500 text-white rounded-lg hover:bg-green-600">
            <Phone className="w-5 h-5" />
          </button>
          <button className="p-2 bg-indigo-500 text-white rounded-lg hover:bg-indigo-600">
            <Video className="w-5 h-5" />
          </button>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto mb-4 space-y-3">
        {messages.map(msg => (
          <div
            key={msg.id}
            className={`flex ${msg.sender_id === user?.id ? 'justify-end' : 'justify-start'}`}
          >
            <div
              className={`max-w-[70%] rounded-lg p-3 ${
                msg.sender_id === user?.id
                  ? 'bg-indigo-500 text-white'
                  : 'bg-gray-100 text-gray-800'
              }`}
            >
              {msg.message && <p className="break-words">{msg.message}</p>}
              {msg.file_url && (
                <a href={msg.file_url} target="_blank" rel="noopener noreferrer" className="underline">
                  {msg.file_name}
                </a>
              )}
              <p className="text-xs mt-1 opacity-75">
                {format(new Date(msg.created_at), 'HH:mm')}
              </p>
            </div>
          </div>
        ))}
        <div ref={messagesEndRef} />
      </div>

      <div className="flex gap-2">
        <input
          type="file"
          ref={fileInputRef}
          onChange={handleFileUpload}
          className="hidden"
        />
        <button
          onClick={() => fileInputRef.current?.click()}
          disabled={uploading}
          className="p-3 bg-gray-200 rounded-lg hover:bg-gray-300"
        >
          <Paperclip className="w-5 h-5" />
        </button>
        <input
          type="text"
          value={inputMessage}
          onChange={(e) => setInputMessage(e.target.value)}
          onKeyPress={(e) => e.key === 'Enter' && handleSend()}
          placeholder="메시지 입력..."
          className="flex-1 px-4 py-3 border-2 border-gray-200 rounded-lg focus:border-indigo-500 focus:outline-none"
        />
        <button
          onClick={handleSend}
          className="p-3 bg-indigo-500 text-white rounded-lg hover:bg-indigo-600"
        >
          <Send className="w-5 h-5" />
        </button>
      </div>
    </div>
  );
}

export default DirectChat;
