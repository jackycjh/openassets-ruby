module OpenAssets
  module Cache

    # The base class of cache implementation.
    class CacheBase

      attr_reader :db_provider
      attr_reader :table_name

      # Initializes the connection to the database.
      # @param[Hash] config The configuration for the database connection.
      def initialize(config)
        case config[:cache_provider][:adapter]
        when 'sqlite'
          @db_provider = SqliteCacheProvider.new(config[:cache_provider][:path])
        when 'mysql'
          @db_provider = MysqlCacheProvider.new(config[:cache_provider])
        end

        initialize_table_name(config[:tables])
        @db_provider.setup(self)
      end

      # Initializes the cache table name.
      # @param[Hash] config_tables The configuration for the cache tables.
      def initialize_table_name(config_tables)
        raise StandardError.new('need initialize_table_name method implementation.')
      end

    end

  end
end