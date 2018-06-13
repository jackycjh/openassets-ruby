module OpenAssets
  module Cache
    autoload :CacheBase, 'openassets/cache/cache_base'
    autoload :TransactionCache, 'openassets/cache/transaction_cache'
    autoload :SSLCertificateCache, 'openassets/cache/ssl_certificate_cache'
    autoload :OutputCache, 'openassets/cache/output_cache'
    autoload :CacheProviderBase, 'openassets/cache/cache_provider_base'
    autoload :SqliteCacheProvider, 'openassets/cache/sqlite_cache_provider'
    autoload :MysqlProviderBase, 'openassets/cache/mysql_cache_provider'
  end
end