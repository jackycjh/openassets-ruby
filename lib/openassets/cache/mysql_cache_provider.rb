require 'sqlite3'

module OpenAssets
  module Cache

    # The base class of MySQL cache implementation.
    class MysqlCacheProvider < CacheProviderBase

      # Initializes the connection to the database, and creates the table if needed.
      # @param[Hash] config The config for MySQL connection.
      def initialize(config)
        @db_client = Mysql2::Client.new(config)
        setup
      end

      # TODO: Setup table ddl.
      def setup
        raise StandardError.new('need setup method implementation.')
      end

    end

  end
end