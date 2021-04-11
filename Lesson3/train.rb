class Train
  include InstanceCounter
  include ManufacturingCompany
  attr_accessor :speed, :carriages, :current_station, :number, :type, :route
  @@trains = {}
  
  def initialize(number)
    @number = number
    @type = self.class::TYPE
    @carriages = []
    @speed = 0
    @@trains[number] = self
    register_instance
  end

  def go
    self.speed = 50
  end

  def stop
    self.speed = 0
  end

  def add_carriage(carriage)
    return unless @speed.zero?
    @carriages.push(carriage) if carriage.type == @type
  end

  def delete_carriage(carriage)
    return unless @speed.zero?
    @carriages.delete(carriage) if carriage.type == @type
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
  
  def self.find(number)
    @@trains[number]
  end
  
  private
  # потому что методы используются внутри класса, не нужны для вызова вне его

  def next_station
    return if @current_station == @route.stations.last
    next_station = @route.stations[@route.stations.index(@current_station) + 1]
  end

  def prev_station
    return if @current_station == @route.stations.first
    prev_station = @route.stations[@route.stations.index(@current_station) - 1]
  end

end

class CargoTrain < Train
    TYPE = "Cargo"
    
end

class PassengerTrain < Train
    TYPE = "Passenger"
    
end

