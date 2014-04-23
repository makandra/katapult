require 'wheelie/version'

module Wheelie
  
  def self.driver_root
    File.join File.dirname(__dir__), 'lib', 'wheelie', 'drivers'
  end

end
