module OpenAssets
  module Cache

    # The base class of cache provider implementation.
    class CacheProviderBase

      attr_reader :db_client

      # Setup table ddl, implements by subclass.
      # @param[CacheBase] cache The cache instance to be set up.
      def setup(cache)
        raise StandardError.new('need setup method implementation.')
      end

      # Execute statements, implements by subclass.
      def execute(sql_statement)
        raise StandardError.new('need execute method implementation.')
      end

      # Execute statements with query result, implements by subclass.
      # The returning result will be normalized into double array.
      def execute_with_result(sql_statement)
        raise StandardError.new('need execute_with_result method implementation.')
      end

      # Get SQL convention for ignoring duplicate inserts, implements by subclass.
      def get_sql_insert_ignore()
        raise StandardError.new('need get_sql_insert_ignore method implementation.')
      end

    end

  end
end