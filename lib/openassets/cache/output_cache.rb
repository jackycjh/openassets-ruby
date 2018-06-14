module OpenAssets
  module Cache

    # An object that can be used for caching coloring transaction output in a Sqlite database.
    class OutputCache < CacheBase

      # Get a cached transaction output
      # @param[String] txid The transaction id.
      # @param[Integer] index The index of the output in the transaction.
      # @return[OpenAssets::Protocol::TransactionOutput] The output for the txid and index provided if it is found in the cache, or nil otherwise.
      def get(txid, index)
        statement = <<-SQL
          SELECT Value, Script, AssetId, AssetQuantity, OutputType, Metadata
            FROM Output
            WHERE TransactionHash = '#{txid}'
              AND OutputIndex = #{index}
        SQL

        rows = @db_provider.execute(statement)
        return nil if rows.empty?
        script = Bitcoin::Script.from_string(rows[0][1])
        OpenAssets::Protocol::TransactionOutput.new(rows[0][0], script, rows[0][2], rows[0][3], rows[0][4], rows[0][5])
      end

      # Put a transaction output
      # @param[String] txid The transaction id.
      # @param[Integer] index The index of the output in the transaction.
      # @param[OpenAssets::Protocol::TransactionOutput] output The output to save.
      def put(txid, index, output)
        statement = <<-SQL
          #{@db_provider.get_sql_insert_ignore()}
            INTO Output (TransactionHash, OutputIndex, Value, Script, AssetId, AssetQuantity, OutputType, Metadata)
            VALUES (
              '#{txid}',
              #{index},
              #{output.value},
              '#{output.script.to_string}',
              '#{output.asset_id}',
              #{output.asset_quantity},
              #{output.output_type},
              '#{output.metadata}'
            )
        SQL

        @db_provider.execute(statement)
      end

    end

  end
end