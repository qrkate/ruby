module Accessors
  def self.included(base)
    base.extend ClassMethods
  end
  
  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        history_var_name = "@#{name}_history".to_sym
        define_method(name) { instance_variable_get(var_name) }
        define_method("#{name}_history") { instance_variable_get(history_var_name) }
        define_method("#{name}=") do |value|
          if instance_variable_get(history_var_name).nil?
            instance_variable_set(history_var_name, [])
          else
          instance_variable_get(history_var_name) << instance_variable_get(var_name)
          end
        instance_variable_set(var_name, value)
        end
      end
    end
  
    def strong_attr_accessor(name, var_class)
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=") do |value|
        if value.instance_of?(var_class)
          instance_variable_set(var_name, value)
        else
          raise "Неверный тип присваемого значения!"
        end
      end
    end
  end
end
