module Polylines
  class Encoder < Base
    def self.encode_points(points)
      delta_latitude, delta_longitude = 0, 0

      points.inject([]) do |polyline, (latitude, longitude)|
        polyline << encode(latitude - delta_latitude)
        polyline << encode(longitude - delta_longitude)
        delta_latitude, delta_longitude = latitude, longitude
        polyline
      end.join
    end

    def self.encode(number)
      negative = number < 0
      number = step_2(number)
      number = step_3(number) if negative
      number = step_4(number)
      number = step_5(number) if negative

      five_bit_chunks = step_6(number)
      five_bit_chunks = step_7(five_bit_chunks)
      ord_values      = step_8(five_bit_chunks)
      decimal_values  = step_10(ord_values)

      step_11(decimal_values)
    end

    def self.step_2(number)
      (number * 1e5).round
    end

    def self.step_3(number)
      number *= -1
      number = ~number
      number += 1
    end

    def self.step_4(number)
      number << 1
    end

    def self.step_6(number)
      [].tap do |numbers|
        while number > 0 do
          numbers.unshift(number & 0x1f)
          number = number >> 5
        end
      end
    end

    def self.step_8(five_bit_chunks)
      five_bit_chunks[0..-2].map {|chunk| 0x20 | chunk } << five_bit_chunks.last
    end

    def self.step_10(values)
      values.map {|value| value + 63 }
    end

    def self.step_11(values)
      values.map(&:chr).join
    end
  end
end
