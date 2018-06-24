module OpenAssets
  module Cache

    # An object that can be used for caching serialized transaction in a Sqlite database.
    class TransactionCache < CacheBase

      # Initializes the cache table name.
      # @param[Hash] config_tables The configuration for the cache tables.
      def initialize_table_name(config_tables)
        if config_tables.nil? || config_tables[:transaction].nil? || config_tables[:transaction].empty?
          # Default to backward-compatible Tx table.
          @table_name = 'Tx'
        else
          @table_name = config_tables[:transaction]
        end
      end

      # Return the serialized transaction.
      # @param[String] txid The transaction id.
      # @return[String] The serialized transaction. If not found transaction, return nil.
      def get(txid)
        statement = <<-SQL
          SELECT SerializedTx
            FROM #{@table_name}
            WHERE TransactionHash = '#{txid}'
        SQL

        rows = @db_provider.execute_with_result(statement)
        rows.empty? ? nil : rows[0][0]
      end

      # Saves a serialized transaction in cache.
      # @param[String] txid A transaction id.
      # @param[String] serialized_tx A a hex-encoded serialized transaction.
      def put(txid, serialized_tx)
        statement = <<-SQL
          #{@db_provider.get_sql_insert_ignore()}
            INTO #{@table_name} (TransactionHash, SerializedTx)
            VALUES ('#{txid}', '#{serialized_tx}')
        SQL

        @db_provider.execute(statement)
      end

    end

  end
end