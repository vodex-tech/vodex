part of 'datasource.dart';

extension Queries on DatasourceBase {
  Query<User> get users => collection<User>();
}