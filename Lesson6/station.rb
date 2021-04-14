require_relative 'instance_counter.rb'
require_relative 'accessors.rb'
require_relative 'validation.rb'

class Station
  include InstanceCounter
  include Accessors
  include Validation
  
  STATION_NAME = /^[A-ZА-Я]{1}[a-zа-я]+$/
  
  attr_accessor :name, :trains
  
  @@stations = []
  
  validate :name, :format, STATION_NAME

  def initialize(name)
    @name = name
    @trains = []
    @@stations.push(self)
    register_instance
    validate!
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
  
  def each_train
    @trains.each { |train| yield train } if block_given?
  end
end
