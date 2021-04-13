require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'train.rb'
require_relative 'carriage.rb'

class Main
  attr_accessor :trains, :routes
  
  def initialize
    @trains = []
    @routes = []
  end
  
  def start
    loop do
      puts "Выберете действие:"
      start_menu
      case gets.to_i
      when 0
        exit
      when 1
        new_station
      when 2
        new_train
      when 3
        manage_route
      when 4
        assign_route
      when 5
        add_carriage
      when 6
        delete_carriage
      when 7
        load_carriage
      when 8
        move_trains
      when 9
        show_trains_at_stations
      end
    end
  end
  
  private
  TRAIN_TYPE = [CargoTrain, PassengerTrain]
  
  def manage_route
    loop do
      route_menu
      choise = gets.chomp.to_i
      case choise
      when 0
        return
      when 1
        new_route
      when 2
        add_station
      when 3
        delete_station
      end
    end
  end
  
  def show_trains_at_stations
    loop do
      stations_menu
      choise = gets.chomp.to_i
      case choise
      when 0
        return
      when 1
        show_stations
      when 2
        train_at_station
      when 3
        show_carriage
      end
    end
  end
  
  def new_station
    puts "Введите название станции:"
    name = gets.chomp
    Station.new(name)
    puts "Станция #{name} создана."
  end
  
  def new_train
    puts "Выберите тип поезда:\n0 - Грузовой\n1 - Пассажирский"
    train_type = TRAIN_TYPE[gets.chomp.to_i]
    puts "Введите номер поезда:"
    number = gets.chomp
    @trains.push(train_type.new(number))
    puts "Поезд №#{number} создан."
  rescue => e
    puts e.message
    retry
  end
  
  def move_trains
    set_train
    train = @trains[gets.chomp.to_i]
    return "Маршрут не назначен." if train.route.nil?
    puts "Выберите дейтсвие:\n0 - Следующая станция\n1 - Предыдущая станция"
    if gets.chomp.to_i == 0
      train.go_next_station
    else
      train.go_prev_station
    end
    puts "Поезд №#{train.number} прибыл на станцию #{train.current_station.name}"
  end
  
  def new_route
    puts "Введите номерa начальной и конечной станции маршрута через пробел:"
    show_stations
    start, finish = gets.chomp.split.map { |index| Station.all[index.to_i] }
    @routes.push(Route.new(start, finish))
    puts "Маршрут создан."
  end
  
  def add_station
    set_route
    route = @routes[gets.chomp.to_i]
    puts "Выберите станцию, которую нужно добавить:"
    show_stations
    station = Station.all[gets.chomp.to_i]
    route.add(station) unless route.stations.include? station
    puts "Станция добавлена."
  end
  
  def delete_station
    set_route
    route = @routes[gets.chomp.to_i]
    puts "Выберите станцию, которую нужно удалить:"
    show_stations
    station = Station.all[gets.chomp.to_i]
    route.delete(station) if route.stations.include? station
    puts "Станция удалена."
  end
  
  def assign_route
    set_route
    route = @routes[gets.chomp.to_i]
    set_train
    train = @trains[gets.chomp.to_i]
    train.add_route(route)
    puts "Маршрут #{route.stations.first.name} - #{route.stations.last.name} назначен поезду #{train.number}"
  end
  
  def add_carriage
    set_train
    train = @trains[gets.chomp.to_i]
    if train.type.include? "Cargo"
      puts "Введите объем вагона:"
      train.add_carriage(CargoCarriage.new(gets.chomp.to_i))
    else
      puts "Введите количество мест в вагоне:"
      train.add_carriage(PassengerCarriage.new(gets.chomp.to_i))
    end
    puts "Вагон прицеплен."
  end
  
  def delete_carriage
    set_train
    train = @trains[gets.chomp.to_i]
    puts "Вагон №#{train.delete_carriage.object_id} отцеплен."
  end
  
  def load_carriage
    set_train
    train = @trains[gets.chomp.to_i]
    set_carriage(train)
    train.carriages[gets.chomp.to_i].take_place
    puts "Место занято."
  end
  
  def train_at_station
    puts "Выберите станцию:"
    show_stations
    Station.all[gets.chomp.to_i].each_train { |train| puts "Поезд № #{train.number}: Тип - #{train.type}, Количество вагонов - #{train.carriages.length}" }
  end
  
  def show_carriage
    set_train
    train = @trains[gets.chomp.to_i]
    train.each_carriage { |carriage| puts "Вагон №#{carriage.object_id}, Тип - #{carriage.type}, Свободные места - #{carriage.free_place}, Занятые места - #{carriage.taken_place}" } if train.instance_of? PassengerTrain
    train.each_carriage { |carriage| puts "Вагон №#{carriage.object_id}, Тип - #{carriage.type}, Свободный объем - #{carriage.free_place}, Занятый объем - #{carriage.taken_place}" } if train.instance_of? CargoTrain
  end
  
  def show_stations
    Station.all.each.with_index { |station, n| puts "#{n} - #{station.name}"}
  end
  
  def set_route
    puts "Выберите маршрут:"
    @routes.each.with_index { |route, n| puts "#{n}: #{route.stations.first.name} - #{route.stations.last.name}" }
  end
  
  def set_train
    puts "Выберите поезд:"
    @trains.each.with_index { |train, n| puts "#{n} - Поезд №#{train.number}"}
  end
  
  def set_carriage(train)
    puts "Выберите вагон:"
    train.carriages.each.with_index { |carriage, n| puts "#{n} - #{carriage.object_id}"}
  end
  
  def start_menu
    puts "Выход - 0 \nСоздать станцию - 1 \nСоздать поезд - 2 \nСоздать маршрут и управлять станциями - 3 \nНазначить маршрут поезду - 4 \nДобавить вагон к поезду - 5 \nОтцепить вагон от поезда - 6 \nЗанять место в вагоне - 7 \nПереместить поезд по маршруту - 8 \nПросматреть список станций, список поездов на станции, список вагонов - 9."
  end
  
  def route_menu
    puts "Выход - 0 \nСоздать маршрут - 1 \nДобавить станцию в маршрут - 2 \nУдалить станцию из маршрута - 3."
  end
  
  def stations_menu
    puts "Выход - 0 \nПосмотреть список станций - 1 \nПосмотреть список поездов на станции - 2 \nПосмотреть список вагонов - 3."
  end
end

Main.new.start
