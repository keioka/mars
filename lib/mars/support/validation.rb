module Mars
  module Support
    module Validation
      def valid_date(date) 
        to_date(date).to_s
      rescue Mars::MarsError::ArgmentError   
      end

      def to_date(date)
        Date.parse(date)
      end
    end
  end
end

