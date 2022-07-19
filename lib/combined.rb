# frozen_string_literal: true

# class
class Bicycle
  attr_reader :size, :parts

  def initialize(size:, parts:)
    @size = parts
    @parts = parts
  end

  def spares
    parts.spares
  end
end

require 'forwardable'
# class
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

require 'ostruct'
# class
module PartsFactory
  def self.build(config:, parts_class: Parts)
    parts_class.new(
      config.collect { |part_config| create_part(part_config)}
    )
  end

  def self.create_part(part_config)
    OpenStruct.new(
      name: part_config[0],
      description: part_config[1],
      needs_spare: part_config.fetch(2, true)
    )
  end
end

road_config = [
  ['chain', '11-speed'],
  ['tire_size', '23'],
  ['tape_color', 'red']
]
mountain_config = [
  ['chain', '11-speed'],
  ['tire_size', '2.1'],
  ['front_shock', 'Manitou'],
  ['rear_shock', 'Fox', false]
]
recumbent_config = [
  ['chain', '9-speed'],
  ['tire_size', '28'],
  ['flag', 'tall and orange']
]

road_bike = Bicycle.new(
  size: 'L',
  parts: PartsFactory.build(config: road_config)
)
puts road_bike.spares

mountain_bike = Bicycle.new(
  size: 'L',
  parts: PartsFactory.build(config: mountain_config)
)
puts mountain_bike.spares

recumbent_bike = Bicycle.new(
  size: 'L',
  parts: PartsFactory.build(config: recumbent_config)
)
puts recumbent_bike.spares
