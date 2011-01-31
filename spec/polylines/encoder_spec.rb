require "spec_helper"

describe Polylines::Encoder, ".encode" do
  it "encodes a single point" do
    Polylines::Encoder.encode(-179.9832104).should == "`~oia@"
  end
end

describe Polylines::Encoder, ".encode_points" do
  let(:polyline) { "_p~iF~ps|U_ulLnnqC_mqNvxq`@" }
  let(:points)   { [[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]] }

  it "encodes points correctly" do
    Polylines::Encoder.encode_points(points).should == polyline
  end
end
