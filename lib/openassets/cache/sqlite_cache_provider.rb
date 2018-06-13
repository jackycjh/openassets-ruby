require 'sqlite3'

module OpenAssets
  module Cache

    # The base class of SQLite3 cache implementation.
    class SqliteCacheProvider < CacheProviderBase

      # Initializes the connection to the database, and creates the table if needed.
      # @param[String] path The path to the database file. Use ':memory:' for an in-memory database.
      def initialize(path)
        @db_client = SQLite3::Database.new path
        setup
      end

      # Setup table ddl.
      def setup
        @db_client.execute <<-SQL
          CREATE TABLE IF NOT EXISTS Tx(
                  TransactionHash BLOB,
                  SerializedTx BLOB,
                  PRIMARY KEY (TransactionHash));
        SQL

        @db_client.execute <<-SQL
          CREATE TABLE IF NOT EXISTS Output(
                  TransactionHash BLOB,
                  OutputIndex INT,
                  Value BigInt,
                  Script BLOB,
                  AssetId BLOB,
                  AssetQuantity INT,
                  OutputType INT,
                  Metadata BLOB,
                  PRIMARY KEY (TransactionHash, OutputIndex));
        SQL

        @db_client.execute <<-SQL
          CREATE TABLE IF NOT EXISTS SslCertificate(
                  Url TEXT,
                  Subject TEXT,
                  ExpireDate TEXT,
                  PRIMARY KEY (Url));
        SQL
      end

      # Execute statements.
      def execute(sql_statement, parameters = [])
        return @db_client.execute(sql_statement, parameters)
      end

      # Get SQL convention for ignoring duplicate inserts.
      def get_sql_insert_ignore()
        return 'INSERT OR REPLACE'
      end

    end

  end
end