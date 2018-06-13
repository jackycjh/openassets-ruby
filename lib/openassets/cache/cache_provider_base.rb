require 'sqlite3'

module OpenAssets
  module Cache

    # The base class of cache provider implementation.
    class CacheProviderBase

      attr_reader :db_client

      # Setup table ddl, implements by subclass.
      def setup
        raise StandardError.new('need setup method implementation.')
      end

      # Execute statements, implements by subclass.
      def execute(sql_statement, parameters = [])
        raise StandardError.new('need setup method implementation.')
      end

    end

  end
end