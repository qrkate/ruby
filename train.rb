class Station
  attr_accessor :trains
  attr_reader :name

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    @trains << train
  end

  def return_train_type(type)
    @trains.select { |train| train.type == type }
  end

  def departure(train)
    @trains.delete(train)
  end

end

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

class Train
  attr_accessor :speed, :van, :current_station, :number, :type, :route

  def initialize(number, type, van)
    @number = number
    @type = type
    @van = van
    @speed = 0
  end

  def go
    self.speed = 50
  end

  def stop
    self.speed = 0
  end

  def add_van
    self.van += 1 if @speed.zero?
  end

  def delete_van
    self.van -= 1 if @speed.zero?
  end

  def add_route(route)
    self.route = route
    self.current_station = @route.stations.first
    @current_station.add_train(self)
  end

  def go_next_station
    return unless next_station
    self.current_station.departure(self)
    self.current_station = next_station
    self.current_station.add_train(self)
  end

  def go_prev_station
    return unless prev_station
    self.current_station.departure(self)
    self.current_station = prev_station
    self.current_station.add_train(self)
  end

  def next_station
    return if @current_station == @route.stations.last
    next_station = @route.stations[@route.stations.index(@current_station) + 1]
  end

  def prev_station
    return if @current_station == @route.stations.first
    prev_station = @route.stations[@route.stations.index(@current_station) - 1]
  end

end
