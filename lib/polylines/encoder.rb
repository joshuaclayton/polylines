module Polylines
  class Encoder < Base
    def self.encode_points(points, precision = 1e5)
      points_with_deltas = transform_to_array_of_lat_lng_and_deltas(points, precision)
      points_with_deltas.map {|point| encode(point, precision) }.join
    end

    def self.encode(number, precision = 1e5)
      self.new(number).tap do |encoding|
        encoding.step_2 precision
        encoding.step_3
        encoding.step_4
        encoding.step_5
        encoding.step_6
        encoding.step_7
        encoding.step_8
        encoding.step_10
        encoding.step_11
      end.current_value
    end
  end
end
