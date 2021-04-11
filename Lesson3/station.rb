class Station
  include InstanceCounter
  attr_accessor :trains
  attr_reader :name
  @@stations = []

  def initialize(name)
    @name = name
    @trains = []
    @@stations.push(self)
    register_instance
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
    puts @@stations
  end

end
