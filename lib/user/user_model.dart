class UserModel {
  UserModel(this.name, this.publicKey, [this.privateKey]);

  String name;
  
  String publicKey;

  String? privateKey;
}