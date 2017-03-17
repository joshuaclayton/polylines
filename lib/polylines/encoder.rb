module Polylines
  class Encoder
    def self.encode_points(points, precision = 1e5)
      result = ""
      last_lat = last_lng = 0
      points.each do |point|
        lat = (point[0] * precision).round / precision
        lng = (point[1] * precision).round / precision
        d_lat = lat - last_lat
        d_lng = lng - last_lng
        chunks_lat = encode(d_lat, precision)
        chunks_lng = encode(d_lng, precision)
        result << chunks_lat << chunks_lng
        last_lat = lat
        last_lng = lng
      end
      result
    end

    def self.encode(num, precision = 1e5)
      num = (num * precision).round
      sgn_num = num << 1
      sgn_num = ~sgn_num if num < 0
      encode_number(sgn_num)
    end

    def self.encode_number(num)
      result = ""
      while num >= 0x20
        result << (0x20 | (num & 0x1f)) + 63
        num = num >> 5
      end
      result << num + 63
    end
    private_class_method :encode_number
  end
end
