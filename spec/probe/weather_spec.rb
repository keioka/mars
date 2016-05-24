require 'spec_helper'

describe Mars::Probe::Weather do

  context "Initialize" do 
    let(:weather) { Mars::Probe::Weather.new() }
    it "should return data" do
      expect(weather).to be_a Mars::Probe::Weather
    end
  end
  
  context "Get" do
    
    let(:weather_valid_date) { Mars::Probe::Weather.new(date: "2015-08-25") }
    
    let(:weather_invalid) { Mars::Probe::Weather.new(:past, 2, 2) }
    let(:weather_invalid2) { Mars::Probe::Weather.new(:past) }
    let(:weather_invalid3) { Mars::Probe::Weather.new(:today, 2) }
    let(:weather_invalid4) { Mars::Probe::Weather.new(:toda) }
     

 
    context "Empty" do 
 
      let(:weather_valid) { Mars::Probe::Weather.new() }
      context "Validation" do
        it "should return Mars::Probe::Weather" do
          expect(weather_valid).to be_a Mars::Probe::Weather
        end
      end

      context "Farady" do 
        it "rest_client method should return Faraday::Connection" do
          expect(weather_valid.send(:rest_client)).to be_a Faraday::Connection
        end
  
        it "should return api_url" do 
          expect(weather_valid.send(:api_url)).to eq("http://marsweather.ingenology.com/v1")
        end
      end
 
    end

    # Empty ----- end



    context "Archive" do
      let(:weather_valid2) { Mars::Probe::Weather.new(archive: 20) }
      context "Validation Valid argument" do
              
        it "should return Mars::Probe::Weather" do
          expect(weather_valid2).to be_a Mars::Probe::Weather
        end 

        it "should have data" do
          expect(weather_valid2.data).to eq("")
        end

        it "get_date should have date" do
          expect(weather_valid2.send(:get_date).pop["body"]).to include('terrestrial_date')
        end
      end

      context "Public API" do
        it "count should return data length" do
          expect(weather_valid2.count).to eq(20)
        end 
        
        it "filter should return specific data exclude max_temp_fahrenheit" do 
          expect(weather_valid2.filter(:max_temp).first).not_to include('max_temp_fahrenheit')
        end

        it "filter should return specific data include max_temp" do 
          expect(weather_valid2.filter(:max_temp).first).to include('max_temp')
        end

      end
    end








    context "Date" do
      let(:weather_valid3) { Mars::Probe::Weather.new(date: "2015-08-20") }
      context "Validation Valid argument" do
              
        it "should return Mars::Probe::Weather" do
          expect(weather_valid3).to be_a Mars::Probe::Weather
        end 

        it "should have data" do
          expect(weather_valid3.data).to eq("")
        end

        it "get_date should have date" do
          expect(weather_valid3.send(:get_date)).to include('terrestrial_date')
        end
      end

      context "Public API" do
        it "count should return data length" do
          expect(weather_valid3.count).to eq(1)
        end 
      end

    end









    context "Validation Invalid argument" do
      it "should return Argument Error" do 
        expect{ weather_invalid }.to raise_error(Mars::MarsError::ArgumentError)
      end

      it "should return Argument Error" do
        expect{ weather_invalid2 }.to raise_error(Mars::MarsError::ArgumentError)
      end
      
      it "should return Argument Error" do
        expect{ weather_invalid3 }.to raise_error(Mars::MarsError::ArgumentError)
      end

      it "should return Argument Error" do
        expect{ weather_invalid4 }.to raise_error(Mars::MarsError::ArgumentError)
      end
    end

  end

end
