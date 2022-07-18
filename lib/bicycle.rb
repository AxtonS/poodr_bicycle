# frozen_string_literal: true

# calculates ratio and gear inches
class Gear
  attr_reader :chainring, :cog

  def initialize(chainring:, cog:)
    @chainring = chainring
    @cog = cog
  end

  def gear_inches(diameter)
    ratio * diameter
  end

  def ratio
    chainring / cog.to_f
  end
end

# calculates diameter and circumference
class Wheel
  attr_reader :rim, :tire, :gear

  def initialize(rim:, tire:, chainring:, cog:)
    @rim = rim
    @tire = tire
    @gear = Gear.new(chainring: chainring, cog: cog)
  end

  def diameter
    rim + (tire * 2)
  end

  def gear_inches
    gear.gear_inches(diameter)
  end

  def circumference
    diameter * Math::PI
  end
end

puts Wheel.new(
  rim: 26,
  tire: 1.5,
  chainring: 52,
  cog: 11
).gear_inches

# prepares trips
class Trip
  attr_reader :bicycles, :customers, :vehicle

  def prepare(preparers)
    preparers.each { |preparer| preparer.prepare_trip(self) }
  end
end

# prepares bicycles
class Mechanic
  def prepare_trip(trip)
    trip.bicycles.each { |bicycle| prepare_bicycle(bicycle) }
  end

  def prepare_bicycle(bicycle); end
end

# buys food
class TripCoordinator
  def prepare_trip(trip)
    buy_food(trip.customers)
  end
end

# prepares cars
class Driver
  def prepare_trip(trip)
    vehicle = trip.vehicle
    gas_up(vehicle)
    fill_water_tank(vehicle)
  end
end
