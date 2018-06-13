require 'sqlite3'

module OpenAssets
  module Cache

    # The base class of cache implementation.
    class CacheBase

      attr_reader :db_provider

      # Initializes the connection to the database.
      # @param[Hash] config The configuration for the database connection.
      def initialize(config)
        case config[:cache_provider]
        when 'sqlite'
          @db_provider = SqliteCacheProvider.new(config[:path])
        when 'mysql'
          @db_provider = MysqlCacheProvider.new(config)
        end
      end

    end

  end
end