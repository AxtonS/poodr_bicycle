# frozen_string_literal: true

require 'forwardable'
require 'ostruct'

module PartsFactory
  def self.build(config:, parts_class: Parts)
    parts_class.new(config.collect { |part_config| create_part(part_config) })
  end

  def self.create_part(part_config)
    OpenStruct.new(
      name: part_config[0],
      description: part_config[1],
      needs_spare: part_config.fetch(2, true)
    )
  end
end

# bicycle
class Bicycle
  attr_reader :size, :parts

  def initialize(size:, parts:)
    @size = size
    @parts = parts
  end

  def spares
    parts.spares
  end
end

# parts
class Parts
  extend Forwardable
  def_delegators :@parts, :size, :each
  include Enumerable

  def initialize(parts)
    @parts = parts
  end

  def spares
    select(&:needs_spare)
  end
end

# roadbike parts
class RoadBikeParts < Parts
  attr_reader :tape_color

  def post_initialize(**opts)
    @tape_color = opts[:tape_color]
  end

  def local_spares
    { tape_color: tape_color }
  end

  def default_tire_size
    '23'
  end
end

# mountainbike parts
class MountainBikeParts < Parts
  attr_reader :front_shock, :rear_shock

  def post_initialize(**opts)
    @front_shock = opts[:front_shock]
    @rear_shock = opts[:rear_shock]
  end

  def local_spares
    { front_shock: front_shock }
  end

  def default_tire_size
    '2.1'
  end
end

chain = Parts.new(name: 'chain', description: '11-speed')

road_tire = Parts.new(name: 'tire_size', description: '23')

tape = Parts.new(name: 'tape_color', description: 'red')

mountain_tire = Parts.new(name: 'tire_size', description: '2.1')

rear_shock = Parts.new(name: 'rear_shock', description: 'Fox', needs_spare: false)

front_shock = Parts.new(name: 'front_shock', description: 'Manitou')

road_bike_parts = Parts.new([chain, road_tire, tape])


road_config = 
[[ 'chain', '11-speed'],
['tire_size', '23'],
['tape_color', 'red']]

mountain_config =
[
  ['chain', '11-speed'],
  ['tire_size', '2.1'],
  ['front_shock', 'Manitou'],
  ['rear_shock', 'Fox', false]
]

mountain_bike = Bicycle.new(
  size: 'L',
  parts: PartsFactory.build(config: mountain_config)
)

puts mountain_bike.spares.class
puts mountain_bike.spares
