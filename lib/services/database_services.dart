import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:privex/models/user_profile.dart';
import 'package:privex/services/auth_service.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final GetIt _getIt = GetIt.instance;

  CollectionReference? _usersCollection;

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
}
