module OpenAssets
  module Cache

    class SSLCertificateCache < CacheBase

      def initialize
        cache = OpenAssets.configuration ? OpenAssets.configuration[:cache] : {:cache_provider => 'sqlite', :path => ':memory:'}
        super(cache)
      end

      # Return the subject value which defined by ssl certificate.
      # @param[String] url The URL of asset definition file.
      # @return[String] The subject value. If not found, return nil.
      def get(url)
        statement = <<-SQL
          SELECT Subject, ExpireDate
            FROM SslCertificate
            WHERE Url = '#{url}'
        SQL

        rows = @db_provider.execute_with_result(statement)
        return nil if rows.empty?
        if rows[0][1].to_i < Time.now.to_i
          delete_statement = <<-SQL
            DELETE FROM SslCertificate 
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
            INTO SslCertificate (Url, Subject, ExpireDate) 
            VALUES ('#{url}', '#{subject}', '#{expire_date.to_i}')
        SQL

        @db_provider.execute(statement)
      end

    end

  end
end