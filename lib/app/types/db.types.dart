class ModelEntity {
  int id;
  String name;
  String modelFile;
  String localPath;
  bool isDefault;

  ModelEntity({
    required this.id,
    required this.name,
    required this.modelFile,
    required this.localPath,
    required this.isDefault,
  });

  factory ModelEntity.fromMap(Map<String, dynamic> map) {
    return ModelEntity(
      id: map['id'],
      name: map['name'],
      modelFile: map['model_file'],
      localPath: map['local_path'],
      // SQLite stores booleans as 0/1
      isDefault: (map['is_default'] == 1), 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'model_file': modelFile,
      'local_path': localPath,
      'is_default': isDefault ? 1 : 0,
    };
  }
}

class ChatEntity {
  int id;
  String title;
  bool pinned;

  ChatEntity({
    required this.id,
    required this.title,
    required this.pinned,
  });

  factory ChatEntity.fromMap(Map<String, dynamic> map) {
    return ChatEntity(
      id: map['id'],
      title: map['title'],
      pinned: (map['pinned'] == 1),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'pinned': pinned ? 1 : 0,
    };
  }
}


class ChatMessageEntity {
  int id;
  int chatId;
  String message;
  String sentBy;
  String model;
  String createdAt;
  String metadata;

  ChatMessageEntity({
    required this.id,
    required this.chatId,
    required this.message,
    required this.sentBy,
    required this.model,
    required this.createdAt,
    required this.metadata,
  });

  factory ChatMessageEntity.fromMap(Map<String, dynamic> map) {
    return ChatMessageEntity(
      id: map['id'],
      chatId: map['chatid'],
      message: map['message'],
      sentBy: map['sentBy'],
      model: map['model'],
      createdAt: map['createdAt'],
      metadata: map['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatid': chatId,
      'message': message,
      'sentBy': sentBy,
      'model': model,
      'createdAt': createdAt,
      'metadata': metadata,
    };
  }
}
