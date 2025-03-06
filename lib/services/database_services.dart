import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:privex/models/chat.dart';
import 'package:privex/models/message.dart';
import 'package:privex/models/user_profile.dart';
import 'package:privex/services/auth_service.dart';
import 'package:privex/utils.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final GetIt _getIt = GetIt.instance;

  CollectionReference? _usersCollection;
  CollectionReference? _chatCollection;

  late AuthService _authService;

  DatabaseService() {
    _setupCollectionReferences();
    _authService = _getIt.get<AuthService>();
  }

  void _setupCollectionReferences() {
    _usersCollection = _firebaseFirestore
        .collection('users')
        .withConverter<UserProfile>(
          fromFirestore:
              (snapshots, _) => UserProfile.fromJson(snapshots.data()!),
          toFirestore: (userProfile, _) => userProfile.toJson(),
        );
    _chatCollection = _firebaseFirestore
        .collection("chats")
        .withConverter<Chat>(
          fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!),
          toFirestore: (chat, _) => chat.toJson(),
        );
  }

  Future<void> createUserProfile({required UserProfile userProfile}) async {
    await _usersCollection?.doc(userProfile.uid).set(userProfile);
  }

  Stream<QuerySnapshot<UserProfile>> getUserPRofiles() {
    return _usersCollection
            ?.where("uid", isNotEqualTo: _authService.user!.uid)
            .snapshots()
        as Stream<QuerySnapshot<UserProfile>>;
  }

  Future<bool> checkChatExists(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final result = await _chatCollection?.doc(chatID).get();
    if (result != null) {
      return result.exists;
    }
    return false;
  }

  Future<void> createNewChat(String uid1, String uid2) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final docRef = _chatCollection!.doc(chatID);
    final chat = Chat(id: chatID, participants: [uid1, uid2], messages: []);
    await docRef.set(chat);
  }

  Future<void> sendChatMessage(
    String uid1,
    String uid2,
    Message message,
  ) async {
    String chatID = generateChatID(uid1: uid1, uid2: uid2);
    final docRef = _chatCollection!.doc(chatID);

    await docRef.update({
      "messages": FieldValue.arrayUnion([message.toJson()]),
    });
  }
}
