require_relative 'instance_counter.rb'
require_relative 'validation.rb'

class Route
  include Validation
  include InstanceCounter
  
  attr_accessor :stations, :start, :finish
  
  validate :start, :type, Station
  validate :finish, :type, Station

  def initialize(start, finish)
    @start, @finish = start, finish
    @stations = []
    validate!
    @stations.push(@start, @finish)
    register_instance
  end
  
  def add(station)
    @stations.insert(-2, station) unless @stations.include? station
  end

  def delete(station)
    return if (@stations.first || @stations.last) == station
    @stations.delete(station)
  end
end
