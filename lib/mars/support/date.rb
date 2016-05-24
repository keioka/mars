module Mars
  module Support
    class Date
      attr_reader :date
      def initilaize(date)
        @date = nil
        parse(date)
      end

      def parse(date)
        if date == :today
          @date = today
        elsif date == :yesterday
          @date = yesterday
        elsif date.to_a Integer
          @date = get_date(date) 
        else
          raise Mars::MarseError::ArgumentError, " Invalid Argument Error"
        end
      end
      
      def today
        Date.today
      end

      def yesterday
        today - 1
      end

      def get_date(n)
        today - n
      end

      def to_s
        raise Mars::MarsError if @date.nil? 
        @date.strftime("%Y-%m-%d")
      end
    end
  end
end
