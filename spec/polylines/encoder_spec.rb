require "spec_helper"

describe Polylines::Encoder, ".encode" do
  it "encodes a single point" do
    Polylines::Encoder.encode(-179.9832104).should == "`~oia@"
  end

  it "encodes a single point with 1e6 precision" do
    Polylines::Encoder.encode(-179.9832104, 1e6).should == "ruhhvI"
  end
end

describe Polylines::Encoder, ".encode_points" do
  let(:points)   { [[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]] }

  context "with default precision" do
    let(:polyline) { "_p~iF~ps|U_ulLnnqC_mqNvxq`@" }
    it "encodes points correctly" do
      Polylines::Encoder.encode_points(points).should == polyline
    end
  end

  context "with 1e6 precsion" do
    let(:polyline) { "_izlhA~rlgdF_{geC~ywl@_kwzCn`{nI" }
    it "encodes points correctly" do
      Polylines::Encoder.encode_points(points, 1e6).should == polyline
    end
  end
end

describe Polylines::Encoder, ".encode_points that are very close together" do
  it "encodes points correctly" do
    Polylines::Encoder.encode_points([[41.3522171071184, -86.0456299662023],[41.3522171071183, -86.0454368471533]]).should == "krk{FdxdlO?e@"
  end

  it "encodes points correctly with 1e6 precision" do
    Polylines::Encoder.encode_points([[41.3522171071184, -86.0456299662023],[41.3522171071183, -86.0454368471533]], 1e6).should == "q`}zmAzzxbcD?aK"
  end
end

describe Polylines::Encoder, ".encode_points with same results as google's api" do
  it "encodes without rounding errors" do
    Polylines::Encoder.encode_points([[39.13594499,-94.4243478],[39.13558757,-94.4243471]]).should == "svzmFdgi_QdA?"
  end
end