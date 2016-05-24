require 'spec_helper'

describe Mars::Probe do
  context "Initialize" do 
    let(:mars){ Mars::Probe.new(date: "2015-08-28") }
    it "should be instance of Mars::Probe" do
      expect(mars).to be_a Mars::Probe
    end
  end
end
