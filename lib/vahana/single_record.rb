module Vahana
  class SingleRecord
    attr_accessor :id
    attr_accessor :value
    attr_accessor :namespace
    
    def initialize id, value, namespace = nil
      @id = id
      @value = value
      @namespace = namespace
    end

  end
end