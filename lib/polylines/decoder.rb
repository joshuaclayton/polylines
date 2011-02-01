module Polylines
  class Decoder < Base
    def self.decode_polyline(polyline)
      set = []

      points_with_deltas = polyline.split(//).inject([]) do |charset, char|
        set << char

        if ((char[0] - 63) & 0x20) == 0
          charset << set.join
          set = []
        end

        charset
      end.map {|charset| decode(charset) }

      points = [[points_with_deltas.shift, points_with_deltas.shift]]

      while points_with_deltas.any?
        new_latitude  = points.last[0] + points_with_deltas.shift
        new_longitude = points.last[1] + points_with_deltas.shift
        points << [new_latitude, new_longitude]
      end

      points
    end

    def self.decode(string)
      decimal_values  = step_11(string)
      decimal_values  = step_10(decimal_values)
      xord_values     = step_8(decimal_values)
      five_bit_chunks = step_7(xord_values)
      binary_string   = step_6(five_bit_chunks)

      negative = binary_string[-1, 1] == "1"

      number = binary_string.to_i(2)
      number = step_5(number) if negative
      number = step_4(number)
      number = step_3(number) if negative
      step_2(number)
    end

    def self.step_2(number)
      number.to_f/1e5
    end

    def self.step_3(number)
      number -= 1
      number = ~number
      number *= -1
    end

    def self.step_4(number)
      number >> 1
    end

    def self.step_6(five_bit_chunks)
      five_bit_chunks.map do |chunk|
        "%05b" % chunk
      end.join
    end

    def self.step_8(decimal_values)
      decimal_values[0..-2].map {|value| 0x20 ^ value } << decimal_values.last
    end

    def self.step_10(values)
      values.map {|value| value - 63 }
    end

    def self.step_11(string)
      string.split(//).map {|char| char[0] }
    end
  end
end
