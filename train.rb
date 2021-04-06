class Station
   attr_accessor :trains
   attr_reader :name


   def initialize(name)
     @name = name
     @trains = []
   end

   def add_train(train)
     @trains << train
     puts "Поезд №#{train.number} прибыл на станцию #{name}."
   end

   def show_train_type
     self.trains.each do |train|
       if train.type == "Cargo"
         puts "Грузовой поезд № #{train.number}"
       else
        puts "Пассажирский поезд № #{train.number}"
       end
     end
   end

   def departure(train)
     trains.delete(train)
     puts "Поезд №#{train.number} покинул станцию #{name}."
   end

 end

 class Route
   attr_accessor :stations

   def initialize(start, finish)
     @stations = [start, finish]
   end

   def add(station)
     self.stations.insert(-2, station)
     puts "Станция #{station.name} добавлена в маршрут."
   end

   def delete(station)
     if station == @stations[0] || station == @stations[-1]
       puts "Нельзя удалить статровую и/или финишную станцию маршрута."
     else
       self.stations.delete(station)
       puts "Станция #{station.name} удалена из маршрут."
      end
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
     self.route = route
     self.current_station = self.route.stations[0]
     self.current_station.add_train(self)
   end

   def go_next_station
     if self.current_station != self.route.stations[-1]
       self.current_station.departure(self)
       self.current_station = self.route.stations[self.route.stations.index(self.current_station) + 1]
       self.current_station.add_train(self)
     else
       puts "Это конечная станция."
     end
   end

   def go_prev_station
     if self.current_station != self.route.stations[0]
       self.current_station.departure(self)
       self.current_station = self.route.stations[self.route.stations.index(self.current_station) - 1]
       self.current_station.add_train(self)
     else
       puts "Это начальная станция."
     end
   end

   def show_next_station
        if self.current_station == self.route.stations[-1]
         puts "Это последняя станция"
       else
         next_station = self.route.stations[self.route.stations.index(self.current_station) + 1]
         puts "Следущая станция #{next_station.name}"
       end
     end

     def show_prev_station
       if self.current_station == self.route.stations[0]
         puts "Это первая станция"
       else
         prev_station = self.route.stations[self.route.stations.index(self.current_station) - 1]
         puts "Предыдущая станция #{prev_station.name}"
       end
     end

 end
