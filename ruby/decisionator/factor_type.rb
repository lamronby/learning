class FactorType
    def FactorType.add_item(key,value)
        @hash ||= {}
        @hash[key]=value
    end
   
    def FactorType.const_missing(key)
        @hash[key]
    end   
  
   def FactorType.each
       @hash.each {|key,value| yield(key,value)}
   end
  
   FactorType.add_item :PRO, 1
   FactorType.add_item :CON, 2
end

