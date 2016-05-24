require 'spec_helper'

describe Mars::Probe::Photo do

  context "Initialize" do 
    let(:weather) { Mars::Probe::Photo.new() }
    it "should return data" do
      expect(weather).to be_a Mars::Probe::Photo
    end
  end
  
  context "Get" do
    
    let(:photo_valid) { Mars::Probe::Photo.new() }
    let(:photo_valid2) { Mars::Probe::Photo.new(:past, 20) }
    let(:photo_valid3) { Mars::Probe::Photo.new(:today) }
    
    let(:photo_invalid) { Mars::Probe::Photo.new(:past, 2, 2) }
    let(:photo_invalid2) { Mars::Probe::Photo.new(:past) }
    let(:photo_invalid3) { Mars::Probe::Photo.new(:today, 2) }
    let(:photo_invalid4) { Mars::Probe::Photo.new(:toda) }

    it "rest_client method should return Faraday::Connection" do
      expect(photo_valid.send(:rest_client)).to be_a Faraday::Connection
    end
     
    it "should return api_url" do 
      expect(photo_valid.send(:api_url)).to eq("https://api.nasa.gov")
    end

    xit "should return 200" do
      # weather_valid.get
      # expect{ weather_valid.get }.to eq()
    end
 
    context "Validation Valid argument" do
      it "should return Mars::Probe::Photo" do
        expect(photo_valid).to be_a Mars::Probe::Photo
      end
     
      it "should have data" do 
        
        expect(photo_valid.data).not_to be_empty
      end
 
      it "date method should return have :earth_date key" do
        date = :today
        expect(photo_valid.send(:date, {date: date})).to include(:earth_date)
      end
    end

    context "Validation Invalid argument" do
      it "should return Argument Error" do
        expect{ photo_invalid }.to raise_error(Mars::MarsError::ArgumentError)
      end

      it "should return Argument Error" do
        expect{ photo_invalid2 }.to raise_error(Mars::MarsError::ArgumentError)
      end
      
      it "should return Argument Error" do
        expect{ photo_invalid3 }.to raise_error(Mars::MarsError::ArgumentError)
      end

      it "should return Argument Error" do
        expect{ photo_invalid4 }.to raise_error(Mars::MarsError::ArgumentError)
      end
    end
  end

end
