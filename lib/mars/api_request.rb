module Mars
  module API
    module Request 
      def self.rest_client(api_url)
        conn = Faraday.new(:url => api_url) do |faraday|
          faraday.request  :url_encoded             # form-encode POST params
         # faraday.response :logger                  # log requests to STDOUT
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        end
        conn
      end
    end
  end
end
 
