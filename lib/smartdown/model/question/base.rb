module Smartdown
  module Model
    module Question
      class Base
        attr_accessor :name, :body

        def initialize(name, options = {})
          @name = name
          @body = options[:body] || ""
        end
      end
    end
  end
end
