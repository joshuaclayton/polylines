module Polylines
  class Encoder < Base
    def self.encode_points(points)
      points_with_deltas = transform_to_array_of_lat_lng_and_deltas(points)
      points_with_deltas.map {|point| encode(point) }.join
    end

    def self.encode(number)
      self.new(number).tap do |encoding|
        encoding.step_2
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
