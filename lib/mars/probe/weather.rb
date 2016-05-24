# Mars::Probe::Weather
# Mars::Probe::Weather.new(date: :today) 
# Mars::Probe::Weather.new(date: "2016-08-12")
# Mars::Probe::Weather.new(latest_dates: 10)
# Mars::Probe::Weather.new(start: "2016-08-28", end: "2015-03-25")
# mars = Mars::Probe::Weather.new(start: "2016-08-28", end: "2015-03-25")

# Public API
#   + mars.max_temp
#   + mars.max_temp_fahrenheit
#   + mars.min_temp
#   + mars.min_temp_fahrenheit
#   + mars.pressure
#   + mars.count

module Mars
  class Probe
    class Weather < Base
      attr_reader :data
      
      ## initialize(*options) 
      # @*option: Array - option ex.(:today), (:past, 20)
      # 
      # => _: Void
 
      def initialize(option={})
         
        # @option = option #Hash
        @params = {} # String
        @page = 1 # Int
        @data = [] #ArrayP
        set_option(option)
        set_initial_data
      end
 
      # max_temp() : Public 
      #   + return date and max_temp
      # => _: [{}]
 
      def max_temp
        filter(:max_temp)
      end
 

      # max_temp_fahrenheit() : Public 
      #   + return date and max_temp_fahrenheit
      # => _: [{}]
 
      def max_temp_fahrenheit
        filter(:max_temp_fahrenheit)
      end      
  

      # min_temp() : Public
      #   + return date and min_temp
      # => _: [{}] 
 
      def min_temp
        filter(:min_temp) 
      end
 

      # min_temp_fahrenheit() : Public 
      #   + return date and min_temp_fahrenheit
      # => _: [{}]
 
      def min_temp_fahrenheit
        filter(:min_temp_fahrenheit)
      end
 

      # pressure() : Public
      #   + return date and pressure
      # => _: [{}]
 
      def pressure
        filter(:pressure) 
      end
 

      # count() : Public 
      #   
      # => _: Int
 
      def count
        @data.count
      end
  

      # filter(*option) : Public 
      # @*option: Array
      #
      # => _: [{}]
     
      def filter(*option)
        
        # Todo - Refactoring

        filter_option = [:max_temp, :max_temp_fahrenheit, :min_temp, :min_temp_fahrenheit, :pressure]
        
        raise Mars::MarsError::ArgumentError, "Invalid argument #{option.join(" ")}" unless option.any?{|op| filter_option.include?(op)}
           
        result = []
        @data.each do |obj|
          hash = {}
           
          hash['terrestrial_date'] = obj['terrestrial_date']  
          option.map!(&:to_s).each do |op|
            hash[op] = obj[op]
          end 

          result << hash
        end     
        result 
      end


      private

      # get() : Private 
      # 
      # => _: Void
 
      def get
        if @params.empty?
          response = get_latest 
        elsif @params.keys.include?(:page)
          response = get_page
        elsif @params.any?          
          response = get_date
        end 
      rescue => e  
        handle_error(e)
      end
 

      # get_latest() : Private 
      # 
      # => _: Void
 
      def get_latest
        response = rest_client.get do |req|
          req.url '/v1/latest/'
          req.params['format'] = 'json'
        end
        parse_response(response)
      end

 
      # get_page() : Private
      # 
      # => _: Void
 
      def get_page
        (1..@params[:page]).each do |n|
           response = rest_client.get do |req|
             req.url '/v1/archive/', :page => n
             req.params['format'] = 'json'
           end
           parse_response(response)
        end
      end
 
 
      # get_date() : Private 
      #   + Send request 
      #   + 
      # => _: Void
      
      def get_date
        response = rest_client.get do |req|
          req.url '/v1/archive/'
          req.params['format'] = 'json'
          @params.each do |key, value|
             req.params[key] = value  
          end   
        end
        parse_response(response)
      end


      def set_initial_data
        get
      end

 
      # set_option(option) : Private 
      # 
      # => _: Void

      def set_option(option)   
        if option_valid?(option)
          case option.keys.first
            when :start
              start(option)
            when :date
              date(option)
            when :archive
              archive(option)
          end
        end   
      end
 

      # option_valid?(option) : Private 
      # @option: Hash{ Symbol: AnyObject }
      #   + is_hash?: Validate option
      #   + Accept :start, :end, :date, :archive keys
      #   + If it is not the one of the acceptable key, raise Error
      #   + If option is Empty, return true
      #
      # => _: Boolean 

      def option_valid?(option)
        is_hash?(option)
        key = [:start, :end, :date, :archive]
        return true unless option.nil?
        option.keys.each do |op|
          raise Mars::MarsError::ArgumentError, "Invalide option key #{op}" unless key.include?(op)
        end
      end
 

      # is_hash?(option) : Private 
      # @option: Hash {Symbol: AnyObject}
      #
      # => _: Void

      def is_hash?(option) #Void
        raise Mars::MarsError::ArgumentError, "Invalid argument #{option}.It should be hash like { latest_date: 20 }" unless option.is_a?(Hash)
      end
       

      # start(option) : Private 
      # @option: Hash {Symbol: Date string}
      #   + Validate date string 
      #   + If it is valid, put the value to @params
      #   + Not, raise Error
      #
      # => _:Void

      def start(option) #-> Void
        start_date = option[:start]
        Date.parse(start_date)
        @params[:terrestrial_date_start] = start_date

        end_date = option[:end]
        Date.parse(end_date)
        @params[:terrestrial_date_end] = end_date
      rescue => e
        raise Mars::MarsError::ArgumentError, "Invalid Value"   
      end
 

      # date(option) : Public
      # @option: Hash { Symbol: String }
      #   + option.value should be valid date
      #   + If not, raise error
      #   + Contain parsed option to @params
      # 
      # => _:Void
      

      def date(option) #-> Void
        date = option[:date]
        d = Date.parse(date)
        @params[:terrestrial_date_start] = d.to_s
        @params[:terrestrial_date_end] = (d+2).to_s
      rescue => e
        raise Mars::MarsError::ArgumentError, "Invalid Value"
      end
 

      # archive(option) : Private 
      # @option: Hash {Symbol: Int}
      #   + Calculate amount of page
      #   + Each call returns 10 object
      #   + If user retrives 20 date, this method should call 2 pages.
      #   + If 25 data, this should call (2 page + 1 extra page) 3 pages
      #   + Contain amount of pages to @params 
      #
      # => _:Void
                               
      def archive(option)
        n = option[:archive]
        page = n % 10 == 0 ? n / 10 : n / 10 + 1 
        # 100 / 10 data per request = 10 times request
        @params[:page] = page
      end
      

      # option_url() : Private 
      #   + if @params is nil, return default path "latest"
      # => _:String

      def option_url 
        if @params == nil 
          "latest"
        end
      end
 
 
      # base_api_url(): Private
      #   +
      # => _:String   
 
      def api_url
        "http://marsweather.ingenology.com/v1" 
      end
 

      # parse_response(response_body)
      #   + Parse response
      #   + Translate to Json
      #   + If response is nil raise Error
      #   + Push to Array
      #
      # => _:Void 
 
      def parse_response(response_body)
        if response_body 
          body = JSON.parse(response_body.body)
          if body.nil? || body.empty?
            raise Mars::MarsError, "Couldn't get body. Server may get trouble" 
          end
          body["results"].each do |obj|
            @data << obj
          end
        else 
          raise Mars::MarsError, "API Request Failed"
        end
      end
 
    end
  end
end
