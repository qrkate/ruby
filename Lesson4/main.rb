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
        move_trains
      when 8
        show_trains_at_stations
      when 0
        exit
      end
    end
  end
  
  private
  TRAIN_TYPE = [CargoTrain, PassengerTrain]
  
  def new_station
    puts "Введите название станции:"
    name = gets.chomp
    Station.new(name)
    puts "Станция #{name} создана."
  end
  
  def new_train
    puts "Выберете тип поезда:\n0 - Грузовой\n1 - Пассажирский"
    train_type = TRAIN_TYPE[gets.chomp.to_i]
    puts "Введите номер поезда:"
    number = gets
    @trains.push(train_type.new(number))
    puts "Поезд №#{number} создан."
  rescue => e
    puts e.message
    retry
  end
  
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
    train.add_carriage(CargoCarriage.new) if train.type.include? "Cargo"
    train.add_carriage(PassangerCarriage.new) if train.type.include? "Passanger"
    puts "Вагон прицеплен."
  end
  
  def delete_carriage
    set_train
    train = @trains[gets.chomp.to_i]
    train.delete_carriage(CargoCarriage.new) if train.type.include? "Cargo"
    train.delete_carriage(PassangerCarriage.new) if train.type.include? "Passanger"
    puts "Вагон отцеплен."
  end
  
  def move_trains
    set_train
    train = @trains[gets.chomp.to_i]
    return "Маршрут не назначен." if train.route.nil?
    puts "Выберете дейтсвие:\n0 - Следующая станция\n1 - Предыдущая станция"
    if gets.chomp.to_i == 0
      train.go_next_station
    else
      train.go_prev_station
    end
    puts "Поезд №#{train.number} прибыл на станцию #{train.current_station.name}"
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
        puts "Выберете станцию:"
        show_stations
        Station.all[gets.chomp.to_i].trains.each { |train| puts "Поезд № #{train.number}" }
      end
    end
  end
  
  def set_route
    puts "Выберете маршрут:"
    @routes.each.with_index { |route, n| puts "#{n}: #{route.stations.first.name} - #{route.stations.last.name}" }
  end
  
  def set_train
    puts "Выберете поезд:"
    @trains.each.with_index { |train, n| puts "#{n} - Поезд №#{train.number}"}
  end
  
  def show_stations
    Station.all.each.with_index { |station, n| puts "#{n} - #{station.name}"}
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
    puts "Выберете станцию, которую нужно добавить:"
    show_stations
    station = Station.all[gets.chomp.to_i]
    route.add(station) unless route.stations.include? station
    puts "Станция добавлена."
  end
  
  def delete_station
    set_route
    route = @routes[gets.chomp.to_i]
    puts "Выберете станцию, которую нужно удалить:"
    show_stations
    station = Station.all[gets.chomp.to_i]
    route.delete(station) if route.stations.include? station
    puts "Станция удалена."
  end
  
  def start_menu
    puts "Выход - 0 \nСоздать станцию - 1 \nСоздать поезд - 2 \nСоздать маршрут и управлять станциями - 3 \nНазначить маршрут поезду - 4 \nДобавить вагон к поезду - 5 \nОтцепить вагон от поезда - 6 \nПереместить поезд по маршруту - 7 \nПросматреть список станций и список поездов на станции - 8."
  end
  
  def route_menu
    puts "Выход - 0 \nСоздать маршрут - 1 \nДобавить станцию в маршрут - 2 \nУдалить станцию из маршрута - 3."
  end
  
  def stations_menu
    puts "Выход - 0 \nПосмотреть список станций - 1 \nПосмотреть список поездов на станции - 2."
  end
end

Main.new.start
