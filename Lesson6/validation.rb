module Validation
  def self.included(base)
    base.extend ClassMethod
    base.send :include, InstanceMethod
  end

  module ClassMethod
    attr_accessor :validates

    def validate(name, type, extra = nil)
      @validates ||= []
      @validates << { name: name, type: type, extra: extra }
    end
  end

  module InstanceMethod
    def valid?
      validate!
      true
    rescue
      false
    end
    
    protected
    def validate!
      self.class.validates.each do |validation|
        value = instance_variable_get("@#{validation[:name]}".to_sym)
        method = "#{validation[:type]}".to_sym
        send(method, value, validation[:extra])
      end
    end

    def presence(value, extra)
      raise "Значение не может быть пустым!" if value.nil? || value.empty?
    end

    def format(value, extra)
      raise "Неверный формат значения!" if value !~ extra
    end

    def type(value, extra)
      raise "Неверный тип значения!" unless value.instance_of?(extra)
    end
  end
end
