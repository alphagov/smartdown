require 'smartdown/model/builder'

module Smartdown
  module Model
    def self.build(&block)
      Builder.new.build(&block)
    end
  end
end
