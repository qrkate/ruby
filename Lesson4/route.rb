class Route
  include InstanceCounter
  attr_accessor :stations

  def initialize(start, finish)
    @stations = [start, finish]
    validate!
    register_instance
  end
  
  def valid?
    validate!
    true
  rescue
    false
  end
  
  def add(station)
    @stations.insert(-2, station) unless @stations.include? station
  end

  def delete(station)
    return if (@stations.first || @stations.last) == station
    @stations.delete(station)
  end
  
  private
  def validate!
    raise "Станции не найдены." unless @stations.all? { |station| station.is_a?(Station) }
  end
end
