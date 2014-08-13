require "spec_helper"

describe Polylines::Decoder, ".decode" do
  it "decodes a single point" do
    Polylines::Decoder.decode("`~oia@").should be_within(0.00001).of(-179.9832104)
  end

  it "decodes a single point with 1e6 precision" do
    Polylines::Decoder.decode("ruhhvI", 1e6).should be_within(0.000001).of(-179.9832104)
  end
end

describe Polylines::Decoder, ".decode_polyline" do
  let(:points)   { [[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]] }

  context "with default precision" do
    let(:polyline) { "_p~iF~ps|U_ulLnnqC_mqNvxq`@" }
    it "decodes a polyline correctly" do
      Polylines::Decoder.decode_polyline(polyline).should == points
    end
  end

  context "with 1e6 precision" do
    let(:polyline) { "_izlhA~rlgdF_{geC~ywl@_kwzCn`{nI" }
    it "decodes a polyline correctly" do
      Polylines::Decoder.decode_polyline(polyline, 1e6).should == points
    end
  end
end

describe Polylines::Decoder, ".decode_polyline with points that were close together" do
  it "decodes a polyline correctly" do
    Polylines::Decoder.decode_polyline("krk{FdxdlO?e@").should == [[41.35222, -86.04563],[41.35222, -86.04544]]
  end

  it "decodes a polyline correctly with 1e6 precision" do
    Polylines::Decoder.decode_polyline("q`}zmAzzxbcD?aK", 1e6).should == [[41.352217, -86.045630],[41.352217, -86.045437]]
  end
end
