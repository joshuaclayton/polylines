module Polylines
  class Base
    attr_reader :current_value, :negative

    def initialize(current_value)
      @current_value = current_value
    end

    def step_2(precision = 1e5)
      @negative = current_value < 0 if encoding?

      encode! { (current_value * precision).round }
      decode! { current_value.to_f/precision }
    end

    def step_3
      return unless negative
      encode! { ~(current_value * -1) + 1 }
      decode! { ~(current_value - 1) * -1 }
    end

    def step_4
      encode! { current_value << 1 }
      decode! { current_value >> 1 }
    end

    def step_5
      return unless negative
      encode! { ~current_value }
      decode! { ~current_value }
    end

    def step_6
      encode! do
        [].tap do |numbers|
          while current_value > 0 do
            numbers.unshift(current_value & 0x1f)
            @current_value >>= 5
          end

          numbers << 0 if numbers.empty?
        end
      end

      decode! do
        current_value.map {|chunk| "%05b" % chunk }.join.tap do |val|
          @negative = val[-1, 1] == "1"
        end.to_i(2)
      end
    end

    def step_7
      encode! { current_value.reverse }
      decode! { current_value.reverse }
    end

    def step_8
      encode! { current_value[0..-2].map {|item| item | 0x20 } << current_value.last }
      decode! { current_value[0..-2].map {|item| item ^ 0x20 } << current_value.last }
    end

    def step_10
      encode! { current_value.map {|value| value + 63 } }
      decode! { current_value.map {|value| value - 63 } }
    end

    def step_11
      encode! { current_value.map(&:chr).join }
      decode! { current_value.split(//).map {|char| char.unpack("U").first } }
    end

    def encode!
      if encoding?
        @current_value = yield
      end
    end

    def decode!
      if decoding?
        @current_value = yield
      end
    end

    def encoding?
      self.is_a?(Polylines::Encoder)
    end

    def decoding?
      self.is_a?(Polylines::Decoder)
    end

    def self.transform_to_array_of_lat_lng_and_deltas(value, precision = 1e5)
      if self == Polylines::Encoder
        delta_latitude, delta_longitude = 0, 0

        shifted_values = value.map{|tuple| tuple.map{|val| (val * precision).round } }
        deltas = shifted_values.inject([]) do |polyline, (latitude, longitude)|
          polyline << latitude - delta_latitude
          polyline << longitude - delta_longitude
          delta_latitude, delta_longitude = latitude, longitude
          polyline
        end
        return deltas.map{|val| val.to_f/precision }
      end

      if self == Polylines::Decoder
        set = []
        return value.split(//).inject([]) do |charset, char|
          set << char

          if ((char.unpack("U").first - 63) & 0x20).zero?
            charset << set.join
            set = []
          end

          charset
        end.map {|charset| decode(charset, precision) }
      end
    end
  end
end
