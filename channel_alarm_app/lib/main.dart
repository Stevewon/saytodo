import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'providers/auth_provider.dart';
import 'providers/channel_provider.dart';
import 'providers/message_provider.dart';
import 'providers/schedule_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/channel/channel_list_screen.dart';
import 'config/theme.dart';
import 'services/call_notification_service.dart';
import 'models/message_model.dart';
import 'models/scheduled_alarm_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Firebase 초기화 (나중에 설정)
  // await Firebase.initializeApp();
  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ChannelProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
      ],
      child: MaterialApp(
        title: 'Channel Alarm',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        navigatorKey: _navigatorKey,
        home: Builder(
          builder: (context) {
            final auth = Provider.of<AuthProvider>(context);
            final messageProvider = Provider.of<MessageProvider>(context, listen: false);
            final scheduleProvider = Provider.of<ScheduleProvider>(context, listen: false);
            
            // 전화 알림 서비스 초기화
            if (auth.isAuthenticated) {
              CallNotificationService().initialize(context);
              
              // 🔥 새 메시지 수신 시 자동으로 전화 알람!
              messageProvider.onNewMessage = (Message message) {
                String messageType;
                switch (message.type) {
                  case MessageType.voice:
                    messageType = 'voice';
                    break;
                  case MessageType.video:
                    messageType = 'video';
                    break;
                  case MessageType.youtube:
                    messageType = 'youtube';
                    break;
                  default:
                    messageType = 'voice';
                }
                
                // 즉시 전화 알람 표시!
                CallNotificationService().showIncomingCallNotification(
                  channelName: 'Channel',
                  senderName: message.senderName,
                  messageType: messageType,
                  mediaUrl: message.mediaUrl,
                  youtubeUrl: message.content,
                );
              };
              
              // 🔥 예약된 알람 트리거 시 자동으로 전화 알람!
              scheduleProvider.onAlarmTriggered = (ScheduledAlarm alarm) {
                String messageType;
                switch (alarm.type) {
                  case ScheduleType.voice:
                    messageType = 'voice';
                    break;
                  case ScheduleType.video:
                    messageType = 'video';
                    break;
                  case ScheduleType.youtube:
                    messageType = 'youtube';
                    break;
                }
                
                // 예약 시간에 자동으로 전화 알람!
                CallNotificationService().showIncomingCallNotification(
                  channelName: alarm.channelName,
                  senderName: alarm.ownerName,
                  messageType: messageType,
                  mediaUrl: alarm.mediaUrl,
                  youtubeUrl: alarm.content,
                );
              };
            }
            
            if (auth.isLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            
            if (auth.isAuthenticated) {
              return const ChannelListScreen();
            }
            
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
