require_relative 'metamodel'
require 'wheelie/model'
require 'wheelie/wui'
require 'wheelie/navigation'

module Wheelie
  class Parser

    def initialize
      self.metamodel = Wheelie::Metamodel.new
    end

    def parse(path_to_metamodel_file)
      instance_eval File.read(path_to_metamodel_file), path_to_metamodel_file

      metamodel
    end

    def model(name, &block)
      metamodel.add_model Model.new(name, &block)
    end

    def wui(name, options = {}, &block)
      metamodel.add_wui WUI.new(name, options, &block)
    end

    def navigation(name)
      metamodel.set_navigation Navigation.new(name)
    end

    def homepage(wui_name)
      wui = metamodel.get_wui(wui_name) or raise 'WUI not found'
      metamodel.set_home_wui(wui)
    end

    private

    attr_accessor :metamodel

  end
end
