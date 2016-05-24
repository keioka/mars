require_relative "./probe/base"
require_relative "./probe/weather"
require_relative "./probe/photo"

module Mars
  
  class Probe
   
    attr_reader :weather
    
    def initialize(date)
      @date = date
      @weather = nil
      @photo = nil
    end

    def weather
      @weather ||= Weather.new(@date)
    end

    def photo
      @photo ||= Photo.new(@date)
    end

    def set_date(date)
      @date = date
    end
  end
end
