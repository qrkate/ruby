require_relative 'manufacturing_company.rb'

class Carriage
  include ManufacturingCompany
  attr_accessor :type
end

class CargoCarriage < Carriage
  def initialize
    @type = "Cargo"
  end
end

class PassengerCarriage < Carriage
  def initialize
    @type = "Passenger"
  end
end
