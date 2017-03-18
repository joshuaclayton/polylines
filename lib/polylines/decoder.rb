module Polylines
  class Decoder
    def self.decode_polyline(polyline, precision = 1e5)
      coords = []
      acc = ''
      last_lat = last_lng = 0
      lat_turn = true
      polyline.each_char do |c|
        acc << c
        next unless c.ord < 0x5f
        delta = lat_turn ? last_lat : last_lng
        coord = delta + decode(acc, precision)
        coords << coord
        last_lat = coord if lat_turn
        last_lng = coord unless lat_turn
        lat_turn = !lat_turn
        acc = ''
      end
      coords.each_slice(2).to_a
    end

    def self.decode(string, precision = 1e5)
      result = 1
      shift = 0
      string.each_byte do |b|
        b = b - 63 - 1
        result += b << shift
        shift += 5
      end
      result = (result & 1).nonzero? ? (~result >> 1) : (result >> 1)
      result / precision
    end
  end
end
