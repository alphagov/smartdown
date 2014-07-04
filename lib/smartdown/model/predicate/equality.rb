require 'smartdown/util/hash'
require 'smartdown/errors'

module Smartdown
  module Model
    module Predicate
      Equality = Struct.new(:varname, :expected_value)
    end
  end
end
