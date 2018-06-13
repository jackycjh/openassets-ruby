module OpenAssets
  module Cache

    # An object that can be used for caching serialized transaction in a Sqlite database.
    class TransactionCache < CacheBase

      # Return the serialized transaction.
      # @param[String] txid The transaction id.
      # @return[String] The serialized transaction. If not found transaction, return nil.
      def get(txid)
        rows = @db_provider.execute('SELECT SerializedTx FROM Tx WHERE TransactionHash = ?', [txid])
        rows.empty? ? nil : rows[0][0]
      end

      # Saves a serialized transaction in cache.
      # @param[String] txid A transaction id.
      # @param[String] serialized_tx A a hex-encoded serialized transaction.
      def put(txid, serialized_tx)
        @db_provider.execute('INSERT OR REPLACE INTO Tx (TransactionHash, SerializedTx) VALUES (?, ?)', [txid, serialized_tx])
      end
    end

  end
end