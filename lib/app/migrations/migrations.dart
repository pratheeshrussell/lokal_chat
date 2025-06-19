class AppMigrations {
  static String dbName = 'lokal_chat.db';
  static int dbVersion = 1;
  static List<String> migrations = [
    """
          CREATE TABLE chat (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            title TEXT,
            pinned Boolean DEFAULT FALSE
          );
    """,

    """
          CREATE TABLE models (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT, 
            model_file TEXT,
            local_path TEXT,
            is_default Boolean DEFAULT FALSE
          );
    """,

    """
          CREATE TABLE chatmessages (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            message TEXT, 
            sentBy TEXT,
            model TEXT,
            createdAt TEXT,
            metadata TEXT,
            chatid INTEGER,
            FOREIGN KEY (chatid) REFERENCES chat(id) ON DELETE CASCADE
          );
    """,

    """
          CREATE INDEX idx_chatmessages_chatid ON 
          chatmessages(chatid);
    """
  ];

}