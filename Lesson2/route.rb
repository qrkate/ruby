class Route
  attr_accessor :stations

  def initialize(start, finish)
    @stations = [start, finish]
  end

  def add(station)
    @stations.insert(-2, station) unless @stations.include? station
  end

  def delete(station)
    return if (@stations.first || @stations.last) == station
    @stations.delete(station)
  end

end
