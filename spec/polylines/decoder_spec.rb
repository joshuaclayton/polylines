require "spec_helper"

describe Polylines::Decoder, ".decode" do
  it "decodes a single point" do
    Polylines::Decoder.decode("`~oia@").should be_within(0.00001).of(-179.9832104)
  end
end

describe Polylines::Decoder, ".decode_polyline" do
  let(:polyline) { "_p~iF~ps|U_ulLnnqC_mqNvxq`@" }
  let(:points)   { [[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]] }

  it "decodes a polyline correctly" do
    Polylines::Decoder.decode_polyline(polyline).should == points
  end
end
