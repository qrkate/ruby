module InstanceCounter
  def self.included(base)
    base.extend ClassMethod
    base.send :include, InstanceMethod
  end
  
  module ClassMethod
    attr_accessor :instances
    
    def instances
      @instances ||= 0
    end
  end
  
  module InstanceMethod
    private
    
    def register_instance
      self.class.instances += 1
    end
  end
end
