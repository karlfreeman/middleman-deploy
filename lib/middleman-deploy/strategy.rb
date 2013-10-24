module Middleman::Deploy::Strategy
  class << self
    def find(name)
      strategy = all.find do |strategy| 
        strategy.name.split('::').last.downcase == name.to_s
      end 

      strategy || (raise "#{name} is not supported")
    end

    def all
      constants.collect{|const_name| const_get(const_name)}.select{|const| const.class == Module}
    end
  end
end

Dir["#{File.expand_path('../', __FILE__)}/strategy/*.rb"].each{ |f| require f }
