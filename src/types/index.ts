export interface User {
  id: string;
  email: string;
  nickname: string;
  secretQRAddress: string;
  qrCode: string;
  createdAt?: string;
}

export interface Friend {
  id: string;
  nickname: string;
  secret_qr_address: string;
  added_at: string;
  isOnline?: boolean;
}

export interface DirectMessage {
  id: string;
  sender_id: string;
  sender_nickname: string;
  receiver_id: string;
  message?: string;
  file_url?: string;
  file_name?: string;
  file_type?: string;
  is_read: number;
  created_at: string;
}

export interface GroupRoom {
  id: string;
  name: string;
  creator_id?: string;
  creator_nickname?: string;
  member_count: number;
  last_message?: string;
  created_at: string;
  members?: GroupMember[];
}

export interface GroupMember {
  id: string;
  nickname: string;
  email: string;
}

export interface GroupMessage {
  id: string;
  room_id: string;
  sender_id: string;
  sender_nickname: string;
  message?: string;
  file_url?: string;
  file_name?: string;
  file_type?: string;
  created_at: string;
}

export interface Call {
  from: string;
  fromNickname: string;
  offer: RTCSessionDescriptionInit;
  callType: 'audio' | 'video';
}
