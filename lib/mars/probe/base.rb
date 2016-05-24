require_relative "../support/validation"
# Base : Abstract Class 
#   + Weather 
#   + Photo
#
module Mars
  include Support::Validation
  class Probe
    class Base
    
      # handle_error(error) :Protected
    # $error -> Faraday::Error::ClientError 
    # 
    # @Returns -> error_message :Void  
  
    def handle_error(error)
      error_message = {}
      begin
        if error.is_a?(Faraday::Error::ClientError) && error.response
          error_message[:status_code] = error.response[:status]
          error_message[:raw_body] = error.response[:body]
        end
      rescue
      end
      error_message
    end 


    # rest_client :Protected
    #  
    # @Returns -> _ :Faraday:Connection  
  
    def rest_client
      if api_url
        Mars::API::Request.rest_client(api_url)
      else
        raise Mars::MarsError, "Could not find API URL path"
      end
    end
    
    private


      # option_validation(option) :Protected
      # $option -> Hash: {start: "2013-08-28", end: "2014-09-21"}  
      # 
      # @Returns -> Void - Parsed response_body  
     def is_hash?(option)

        raise Mars::MarsError::ArgumentError, "Invalid option. It should be Hash" unless option.is_a? Hash
      
     end


      # parse_response(response_body) :Protected
      # $response_body ->  
      # 
      # @Returns ->  _:Hash - Parsed response_body  

      def option_validation_second(option) 
        
          raise Mars::MarsError::ArgumentError, "Today option can not take second argument"            
        end
      end


      # parse_response(response_body) :Protected
      # $response_body ->  
      # 
      # @Returns ->  _:Hash - Parsed response_body  

      def option_validation_one(option)
        if option.
          raise Mars::MarsError::ArgumentError, "Invalid option second argument nil"
         
      end


      # parse_response(response_body) :Protected
      # $response_body ->  
      # 
      # @Returns ->  _:Hash - Parsed response_body  

      def parse_option
        option = {
          today: "latest/",
          past: "archive/"  
        }  
        if @option.any?
          key = @option[0]
          option[key]
        else
          option[:today]
        end
      end
     end
  end
end
