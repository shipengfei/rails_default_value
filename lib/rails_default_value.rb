require "rails_default_value/version"

module RailsDefaultValue
  
  module InstanceMethods
    
    def set_defaults
      self.class.default_values.each do |key, value|
        if value.is_a? Proc
          self.send key.to_s, value.call
        else
          self.send("#{key.to_s}=", value) if (self.send(key.to_s).respond_to?(:nil?) and self.send(key.to_s).nil?) or (self.send(key.to_s).respond_to?(:empty?) and self.send(key.to_s).empty?)
        end
      end
    
    end
        
  end
  
  module ClassMethods
    
    @@default_values = {}
    
    def default_values
      @@default_values
    end
  
    def default options
      options.each do |key, value|
        @@default_values[key] = value
      end
      include InstanceMethods
      before_validation :set_defaults, :on => :create
    end
  
    def default? field
      raise Exception.new "No defined dafault value for #{field.to_s.humanize}" unless @@default_values[field]
      @@default_values[field]
    end
  
    
  end
end

ActiveRecord::Base.send :extend, RailsDefaultValue::ClassMethods
