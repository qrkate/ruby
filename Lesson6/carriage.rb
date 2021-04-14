require_relative 'manufacturing_company.rb'

class Carriage
  include ManufacturingCompany
  attr_accessor :type, :place, :free_place
  
  def initialize(place)
    @place = place.to_i
    @free_place = @place
  end
  
  def take_place
    @free_place -= 1 unless @free_place == 0
  end
  
  def taken_place
    @place - @free_place
  end
end

class CargoCarriage < Carriage
  def initialize(place)
    @type = "Cargo"
    super
  end
end

class PassengerCarriage < Carriage
  def initialize(place)
    @type = "Passenger"
    super
  end
end
