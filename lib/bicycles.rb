# frozen_string_literal: true

# creates bicycle objects
class Bicycle
  attr_reader :style, :size, :tape_color, :front_shock, :rear_shock

  def initialize(**opts)
    @style = opts[:style]
    @size = opts[:size]
    @tape_color = opts[:tape_color]
    @front_shock = opts[:front_shock]
    @rear_shock = opts[:rear_shock]
  end

  def spares
    if style == :road
      {
        chain: '11-speed',
        tire_size: '23',
        tape_color: tape_color
      }
    else
      {
        chain: '11-speed',
        tire_size: '2.1',
        front_shock: front_shock
      }
    end
  end
end

bike = Bicycle.new(
  style: :road,
  size: 'M',
  tape_color: 'red'
)

puts bike.spares
