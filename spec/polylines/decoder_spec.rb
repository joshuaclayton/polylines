require "spec_helper"

describe Polylines::Decoder, ".decode" do
  it "decodes a single point" do
    expect(Polylines::Decoder.decode("`~oia@")).to be_within(0.00001).of(-179.9832104)
  end

  it "decodes a single point with 1e6 precision" do
    expect(Polylines::Decoder.decode("ruhhvI", 1e6)).to be_within(0.000001).of(-179.9832104)
  end
end

describe Polylines::Decoder, ".decode_polyline" do
  let(:points) { [[38.5, -120.2], [40.7, -120.95], [43.252, -126.453]] }

  context "with default precision" do
    it "decodes a polyline correctly" do
      polyline = "_p~iF~ps|U_ulLnnqC_mqNvxq`@"

      expect(Polylines::Decoder.decode_polyline(polyline)).to eq points
    end
  end

  context "with 1e6 precision" do
    it "decodes a polyline correctly" do
      polyline = "_izlhA~rlgdF_{geC~ywl@_kwzCn`{nI"

      expect(Polylines::Decoder.decode_polyline(polyline, 1e6)).to eq points
    end
  end
end

describe Polylines::Decoder, ".decode_polyline with points that were close together" do
  it "decodes a polyline correctly" do
    points = [[41.35222, -86.04563], [41.35222, -86.04544]]

    expect(Polylines::Decoder.decode_polyline("krk{FdxdlO?e@")).to eq points
  end

  it "decodes a polyline correctly with 1e6 precision" do
    points = [[41.352217, -86.045630], [41.352217, -86.045437]]

    expect(Polylines::Decoder.decode_polyline("q`}zmAzzxbcD?aK", 1e6)).to eq points
  end
end

describe Polylines::Decoder, ".decode_polyline with a value that previously broke" do
  it "decodes a polyline correctly" do
    value = "kbdoH{ioqCoF_j@Lwc@lC{BhNoMzCuJbEm]?wKkBaQmD}EqM_GwFiBfCge@zE_K~SaTdT`L|Da\\\\xJsX|EyJtQgPpXuRjKAtJqBfM[pn@g^nF}G??"

    expect(Polylines::Decoder.decode_polyline(value).length).to eq 27
  end
end
