require 'sqlite3'

module OpenAssets
  module Cache

    # The base class of SQLite3 cache implementation.
    class SqliteCacheProvider < CacheProviderBase

      # Initializes the connection to the database, and creates the table if needed.
      # @param[String] path The path to the database file. Use ':memory:' for an in-memory database.
      def initialize(path)
        @db_client = SQLite3::Database.new path
      end

      # Setup table ddl.
      # @param[CacheBase] cache The cache instance to be set up.
      def setup(cache)
        if cache.is_a?(TransactionCache)
          @db_client.execute <<-SQL
            CREATE TABLE IF NOT EXISTS #{cache.table_name}(
                    TransactionHash BLOB,
                    SerializedTx BLOB,
                    PRIMARY KEY (TransactionHash));
          SQL
        elsif cache.is_a?(OutputCache)
          @db_client.execute <<-SQL
            CREATE TABLE IF NOT EXISTS #{cache.table_name}(
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
        elsif cache.is_a?(SSLCertificateCache)
          @db_client.execute <<-SQL
            CREATE TABLE IF NOT EXISTS #{cache.table_name}(
                    Url TEXT,
                    Subject TEXT,
                    ExpireDate TEXT,
                    PRIMARY KEY (Url));
          SQL
        else
          raise StandardError.new("need #{cache.class} table setup implementation.")
        end
      end

      # Execute statements.
      def execute(sql_statement)
        @db_client.execute(sql_statement)
      end

      # Execute statements with query result.
      # The returning result will be normalized into double array.
      def execute_with_result(sql_statement)
        return @db_client.execute(sql_statement)
      end

      # Get SQL convention for ignoring duplicate inserts.
      def get_sql_insert_ignore()
        return 'INSERT OR REPLACE'
      end

    end

  end
end