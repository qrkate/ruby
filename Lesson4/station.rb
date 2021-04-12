require_relative 'instance_counter.rb'

class Station
  include InstanceCounter
  attr_accessor :trains, :name
  @@stations = []

  def initialize(name)
    @name = name
    @trains = []
    @@stations.push(self)
    register_instance
    validate!
  end
  
  def valid?
    validate!
    true
  rescue
    false
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
  
  def self.all
    @@stations
  end
  
  private
  STATION_NAME = /^[A-ZА-Я]{1}[a-zа-я]+$/
  
  def validate!
    raise "Неверное название станции. Название должно начинаться с заглавной буквы и состоять минимум из двух букв." if @name !~ STATION_NAME
  end
end
