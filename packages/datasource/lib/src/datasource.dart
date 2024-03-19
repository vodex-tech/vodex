import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datasource/src/base.dart';
import 'package:datasource/src/cache.dart';

abstract class DatasourceBase {
  List<Type> get cachedTypes;

  List<FirestoreModel> get registeredModels;

  late final _cache = Cache(supportedTypes: cachedTypes);

  final _instance = FirebaseFirestore.instance;

  CollectionReference<T> collection<T extends BaseModel>() {
    try {
      if (T.toString() == (BaseModel).toString()) {
        throw Exception();
      }
      final model = registeredModels.firstWhere((e) => e is FirestoreModel<T>)
          as FirestoreModel<T>;
      return _instance.collection(model.collection).withConverter(
            fromFirestore: (snapshot, _) => model.fromMap(snapshot.data()!),
            toFirestore: (data, _) => data.toMap(),
          );
    } catch (e) {
      throw 'Collection not found for type $T';
    }
  }

  Future<T?> get<T extends BaseModel>(String id) async {
    final cached = _cache.get<T>(id);
    if (cached != null) {
      return cached;
    }
    final res = await collection<T>().doc(id).get();
    return _cache.set(id, res.data());
  }

  Future<void> put<T extends BaseModel>(T data) async {
    if (data.id.isEmpty) throw 'ID cannot be empty';
    if (_cache.supportedTypes.contains(T)) {
      _cache.set(data.id, data);
    }
    await collection<T>().doc(data.id).set(data, SetOptions(merge: true));
  }

  Future<void> delete<T extends BaseModel>(T data) async {
    await collection<T>().doc(data.id).delete();
  }
}

typedef ModelConverter<T> = T Function(Map<String, dynamic> data);

class FirestoreModel<T extends BaseModel> {
  final String collection;
  final ModelConverter<T> fromMap;

  FirestoreModel(
    this.fromMap, {
    String? collection,
  }) : collection = collection ?? '${T.toString().toLowerCase()}s';
}
