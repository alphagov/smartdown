module Smartdown
  module Model
    module Scenarios
      Scenario = Struct.new(:description, :question_groups, :outcome, :markers, :exact_markers)
    end
  end
end
