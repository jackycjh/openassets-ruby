module OpenAssets
  module Cache

    class SSLCertificateCache < CacheBase

      def initialize
        cache_config = OpenAssets.configuration ?
                       OpenAssets.configuration[:cache] :
                       {:cache_provider => {:adapter => 'sqlite', :path => ':memory:'}}
        super(cache_config)
      end

      # Initializes the cache table name.
      # @param[Hash] config_tables The configuration for the cache tables.
      def initialize_table_name(config_tables)
        if config_tables.nil? || config_tables[:ssl_cert].nil? || config_tables[:ssl_cert].empty?
          # Default to backward-compatible SslCertificate table.
          @table_name = 'SslCertificate'
        else
          @table_name = config_tables[:ssl_cert]
        end
      end

      # Return the subject value which defined by ssl certificate.
      # @param[String] url The URL of asset definition file.
      # @return[String] The subject value. If not found, return nil.
      def get(url)
        statement = <<-SQL
          SELECT Subject, ExpireDate
            FROM #{@table_name}
            WHERE Url = '#{url}'
        SQL

        rows = @db_provider.execute_with_result(statement)
        return nil if rows.empty?
        if rows[0][1].to_i < Time.now.to_i
          delete_statement = <<-SQL
            DELETE FROM #{@table_name}
              WHERE Url = '#{url}'
          SQL

          @db_provider.execute(delete_statement)
          nil
        else
          rows[0][0]
        end
      end

      # Saves a serialized transaction in cache.
      # @param[String] url The URL of asset definition file.
      # @param[String] subject The SSL Certificate subject value.
      # @param[Time] expire_date The expire date of SSL Certificate.
      def put(url, subject, expire_date)
        statement = <<-SQL
          #{@db_provider.get_sql_insert_ignore()} 
            INTO #{@table_name} (Url, Subject, ExpireDate) 
            VALUES ('#{url}', '#{subject}', '#{expire_date.to_i}')
        SQL

        @db_provider.execute(statement)
      end

    end

  end
end