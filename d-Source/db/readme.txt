Установка БД "ЕМПО"

1. Проверьте, что SQL2005 сервер имеет режим "Mixed mode" аутентификации.
2. Установите в файле "env.cmd" соответствующие переменные.
   - SQL_SERVER_NAME       - имя сервера
   - SQL_INSTANCE_NAME     - имя экземпляра (если есть)
   - SQL_DB_NAME           - название бд
   - SQL_DBA_USER          - имя админ. пользователя, например "sa"
   - SQL_DBA_USER_PWD      - пароль админ. пользователя, например "Admin1"
   - SQL_DB_OWNER_USER     - имя владельца БД
   - SQL_DB_OWNER_USER_PWD - пароль владельца БД
   - SQL_DB_APP_USER       - имя пользователя приложения
   - SQL_DB_APP_USER_PWD   - пароль пользователя приложения
   - SQL_DIR_DAT           - путь к месту хранения данных БД,
                             например "C:\Program Files\Microsoft SQL Server\MSSQL.1\MSSQL\Data\"
   - SQL_DIR_IDX           - путь к месту хранения индексов БД
   - SQL_DIR_TXT           - путь к месту хранения "больших" данных
   - SQL_DIR_LOG           - путь к месту хранения лога

3. Проверьте, что в БД "ЕМПО" включена опция "Full-Text Search"  