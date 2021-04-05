class Station
   attr_accessor :trains
   attr_reader :name


   def initialize(name)
     @name = name
     @trains = {:cargo => [], :passanger => []}
   end

   def add_train(train)
     if train.type == "Cargo"
       self.trains[:cargo] << train.number
     else
       self.trains[:passanger] << train.number
     end
     puts "Поезд №#{train.number} прибыл на станцию #{name}."
   end

   def show_train
     self.trains.each do |type, number|
       number.each {|x| puts "Поезд № #{x}" }
     end
   end

   def show_train_type
     puts "Грузовые поезда:"
     self.trains[:cargo].each { |number| puts "Поезд № #{number}" }
     puts "Всего: #{@trains[:cargo].size}"
     puts "Пассажирские поезда:"
     self.trains[:passanger].each { |number| puts "Поезд № #{number}" }
     puts "Всего: #{@trains[:passanger].size}"
   end

   def departure(train)
     if train.type == "Cargo"
       self.trains[:cargo].delete(train.number)
     else
       self.trains[:passanger].delete(train.number)
     end
     puts "Поезд №#{train.number} покинул станцию #{name}."
   end

 end

 class Route
   attr_accessor :route

   def initialize(start, finish)
     @route = [start, finish]
   end

   def add(station)
     self.route.insert(-2, station)
     puts "Станция #{station.name} добавлена в маршрут."
   end

   def delete(station)
     if station == @route[0] || station == @route[-1]
       puts "Нельзя удалить статровую и/или финишную станцию маршрута."
     else
       self.route.delete(station)
       puts "Станция #{station.name} удалена из маршрут."
      end
   end

   def show_route
     self.route.each {|station| puts "#{station.name}"}
   end

 end

 class Train
   attr_accessor :speed, :van, :current_station, :number, :type, :route

   def initialize(number, type, van)
     @number = number
     @type = type
     @van = van
     @speed = 0
     @route = []
   end

   def go
     self.speed = 50
   end

   def stop
     self.speed = 0
   end

   def add_van
     if self.speed.zero?
       self.van += 1
       puts "Вагон добавлен."
     else
       puts "Нельзя добавить вагон во время движения поезда."
     end
   end

   def delete_van
     if self.speed.zero?
       self.van -= 1
       puts "Вагон отцеплен."
     else
       puts "Нельзя отцепить вагон во время движения поезда."
     end
   end

   def add_route(route)
     self.route = route.route
     self.current_station = self.route[0]
     self.current_station.add_train(self)
   end

   def next_station
     if self.current_station != self.route[-1]
       self.current_station.departure(self)
       self.current_station = self.route[self.route.index(self.current_station) + 1]
       self.current_station.add_train(self)
     else
       puts "Это конечная станция."
     end
   end

   def previous_station
     if self.current_station != self.route[0]
       self.current_station.departure(self)
       self.current_station = self.route[self.route.index(self.current_station) - 1]
       self.current_station.add_train(self)
     else
       puts "Это начальная станция."
     end
   end

   def show_stations
     puts "Текущая станция: #{@current_station.name}"
     puts "Предыдущая станция: #{@route[@route.index(@current_station) - 1].name}" if @current_station != @route[0]
     puts "Следующая станция: #{@route[@route.index(@current_station) + 1].name}" if @current_station != @route[-1]
   end

 end
