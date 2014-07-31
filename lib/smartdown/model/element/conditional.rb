module Smartdown
  module Model
    module Element
      Conditional = Struct.new(:predicate, :true_case, :false_case)
    end
  end
end
