module Polylines
  class Decoder < Base
    def self.decode_polyline(polyline, precision = 1e5)
      points_with_deltas = transform_to_array_of_lat_lng_and_deltas(polyline,
                                                                    precision)

      [].tap do |points|
        points << [points_with_deltas.shift, points_with_deltas.shift]

        while points_with_deltas.any?
          points << [
            points.last[0] + points_with_deltas.shift,
            points.last[1] + points_with_deltas.shift
          ]
        end
      end
    end

    def self.decode(string, precision = 1e5)
      self.new(string).tap do |decoding|
        decoding.step_11
        decoding.step_10
        decoding.step_8
        decoding.step_7
        decoding.step_6
        decoding.step_5
        decoding.step_4
        decoding.step_3
        decoding.step_2 precision
      end.current_value
    end
  end
end
