require 'mysql2'

module OpenAssets
  module Cache

    # The base class of MySQL cache implementation.
    class MysqlCacheProvider < CacheProviderBase

      # Initializes the connection to the database, and creates the table if needed.
      # @param[Hash] config The config for MySQL connection.
      def initialize(config)
        @db_client = Mysql2::Client.new(config)
      end

      # Setup table ddl.
      # @param[CacheBase] cache The cache instance to be set up.
      def setup(cache)
        if cache.is_a?(TransactionCache)
          @db_client.query <<-SQL
            CREATE TABLE IF NOT EXISTS #{cache.table_name}(
              TransactionHash varchar(128),
              SerializedTx text,
              PRIMARY KEY (TransactionHash));
          SQL
        elsif cache.is_a?(OutputCache)
          @db_client.query <<-SQL
            CREATE TABLE IF NOT EXISTS #{cache.table_name}(
              TransactionHash varchar(128),
              OutputIndex int,
              Value bigint,
              Script varchar(4096),
              AssetId varchar(160),
              AssetQuantity int,
              OutputType int,
              Metadata varchar(2048),
              PRIMARY KEY (TransactionHash, OutputIndex));
          SQL
        elsif cache.is_a?(SSLCertificateCache)
          @db_client.query <<-SQL
            CREATE TABLE IF NOT EXISTS #{cache.table_name}(
              Url varchar(256),
              Subject nvarchar(128),
              ExpireDate nvarchar(64),
              PRIMARY KEY (Url));
          SQL
        else
          raise StandardError.new("need #{cache.class} table setup implementation.")
        end
      end

      # Execute statements.
      def execute(sql_statement)
        @db_client.query(sql_statement)
      end

      # Execute statements with query result.
      # The returning result will be normalized into double array.
      def execute_with_result(sql_statement)
        rows = [[],[]]

        @db_client.query(sql_statement).each_with_index(:as => :array) do |row, i|
          row.each_with_index do |value, j|
            rows[i][j] = value
          end
        end

        # Set rows to a single dimension array if no result.
        rows = [] if rows[0].empty? 
        return rows
      end

      # Get SQL convention for ignoring duplicate inserts.
      def get_sql_insert_ignore()
        return 'INSERT IGNORE'
      end

    end

  end
end