require "spec_helper"

describe Polylines::Encoder, ".encode" do
  it "encodes a single point" do
    expect(Polylines::Encoder.encode(-179.9832104)).to eq "`~oia@"
  end

  it "encodes a single point with 1e6 precision" do
    expect(Polylines::Encoder.encode(-179.9832104, 1e6)).to eq "ruhhvI"
  end
end

describe Polylines::Encoder, ".encode_points" do
  let(:points) { [[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]] }

  context "with default precision" do
    it "encodes points correctly" do
      polyline = "_p~iF~ps|U_ulLnnqC_mqNvxq`@"

      expect(Polylines::Encoder.encode_points(points)).to eq polyline
    end
  end

  context "with 1e6 precsion" do
    it "encodes points correctly" do
      polyline = "_izlhA~rlgdF_{geC~ywl@_kwzCn`{nI"

      expect(Polylines::Encoder.encode_points(points, 1e6)).to eq polyline
    end
  end
end

describe Polylines::Encoder, ".encode_points that are very close together" do
  it "encodes points correctly" do
    points = [[41.3522171071184, -86.0456299662023], [41.3522171071183, -86.0454368471533]]

    expect(Polylines::Encoder.encode_points(points)).to eq "krk{FdxdlO?e@"
  end

  it "encodes points correctly with 1e6 precision" do
    points = [[41.3522171071184, -86.0456299662023], [41.3522171071183, -86.0454368471533]]

    expect(Polylines::Encoder.encode_points(points, 1e6)).to eq "q`}zmAzzxbcD?aK"
  end
end

describe Polylines::Encoder, ".encode_points with same results as google's api" do
  it "encodes without rounding errors" do
    points = [[39.13594499,-94.4243478], [39.13558757,-94.4243471]]

    expect(Polylines::Encoder.encode_points(points)).to eq "svzmFdgi_QdA?"
  end
end
