# Mars::Probe::Photo.new(date: :today) 
# Mars::Probe::Photo.new(date: "2016-08-12")
# Mars::Probe::Photo.new(latest_dates: 10)
# Mars::Probe::Photo.new(start: "2016-08-28", end: "2015-03-25")
# mars = Mars::Probe::Weather.new(start: "2016-08-28", end: "2015-03-25")

API_KEY = "H4OVrVDdn57o3x0GZGS0GnfzoZmTj61Bampr4jO8"
URL= "/mars-photos/api/v1/rovers/curiosity/photos"

module Mars
  class Probe
    class Photo < Base
      attr_reader :data
      # Mars::Probe::Photo.new(:today)
      # Mars::Probe::Photo.new(:past, 10)
      def initialize(option={})
        @params = {}
        @page = 1
        @data = []
        set_option(option)
        set_initial_date
      end

      def set_initial_date
        get
      end

      def get 
        if @params.empty?
          response = get_latest
        elsif @params.keys.include?(:page)
          response = get_page
        elsif @parmas.keys.include?(:start)
          response = get_range_date
        elsif @params.any?         
          response = get_date
        end 
      rescue => e  
        handle_error(e)
      end
 

      # get_latest() : Private 
      # 
      # => return: Void
 
      def get_latest
        response = rest_client.get do |req|
          req.url URL
          req.params['earth_date'] = (Date.today - 2).to_s       
          req.params['api_key'] = API_KEY
        end
        parse_response(response)
      end

 
      # get_page() : Private
      # 
      # => return: Void
 
      def get_page
        (0..@params[:page]).each do |n|
           date = (Date.today - n).to_s 
           response = rest_client.get do |req|
             req.params['earth_date'] = date 
             req.params['api_key'] = API_KEY 
           end
           parse_response(response)
        end
      end


      def get_range_date 
        date_start = Date.parse(@params[:terrestrial_date_start])
        date_end = Date.parse(@params[:terrestrial_date_end])
        (date_start..date_end).each do |d|
          response = rest_client.get do |req|
             req.params['earth_date'] = d.to_s
             req.params['api_key'] = API_KEY
          end
          parse_response(response)
        end
      end
 
 
      # get_date() : Private 
      # 
      # => return: Void
      
      def get_date
        response = rest_client.get do |req|
          req.url URL
          @params.each do |key, value|
            req.params[key.to_s] = value  
            req.params['api_key'] = API_KEY
          end   
        end
        parse_response(response)
      end


      private 
      
      def option_valid?(option)
        is_hash?(option)
        key = [:start, :end, :date, :archive]
        return true unless option.nil?
        option.keys.each do |op|
          raise Mars::MarsError::ArgumentError, "Invalide option key #{op}" unless key.include?(op)
        end
      end

      def set_option(option)   
        if option_valid?(option)
          date(date: :today) if option.nil?
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
 
      def is_hash?(option)
        raise Mars::MarsError::ArgumentError, "Invalid argument #{option}.It should be hash like { latest_date: 20 }" unless option.is_a?(Hash) 
      end 
      

      def get_request
        conn = rest_client
        conn.get do |req|                
          req.url '/api/v1/rovers/curiosity/photos'
          req.params['earth_date'] = date("")
        end
      end
      

      def date(option)
        date = option[:date]
        if date == :today 
          d = Date.today
        else
          d = Date.parse(date)
        end
        @params[:earth_date] = d.to_s
        @params
      end


      def archive(option)
        n = option[:archive]
        raise Mars::MarsError::ArgumentError, "Argument of archive should be Integer" unless n.to_a? Integer
        @params[:page] = n
      end


      def start(date)
        
        start_date = option[:start]
        Date.parse(start_date)
        @params[:terrestrial_date_start] = start_date

        end_date = option[:end]
        Date.parse(end_date)
        @params[:terrestrial_date_end] = end_date

      rescue => e
        raise Mars::MarsError::ArgumentError, "Invalid Value"   
      end


      def api_url
        base_url
      end 

      def base_url
        "https://api.nasa.gov"
      end
 
      def parse_response(response_body)
        if response_body 
          body = JSON.parse(response_body.body)
          if body.nil? || body.empty?
            raise Mars::MarsError, "Couldn't get body. Server may get trouble" 
          end
          body["photos"].each do |obj|
            @data << obj
          end
        else 
          raise Mars::MarsError, "API Request Failed"
        end
      end
 

    end
  end
end
