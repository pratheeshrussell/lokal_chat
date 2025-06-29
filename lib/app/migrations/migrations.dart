class AppMigrations {
  static String dbName = 'lokal_chat.db';
  static int dbVersion = 1;
  static List<String> migrations = [
    // pinned, last_updated will be null or a date milliseconds till epoc
    """
          CREATE TABLE chat (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            title TEXT,
            pinned int DEFAULT NULL,
            lastUpdated int DEFAULT NULL
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

    // createdAt will be a date milliseconds till epoc
    """
          CREATE TABLE chatmessages (
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            message TEXT, 
            sentBy TEXT,
            model TEXT,
            createdAt INT,
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