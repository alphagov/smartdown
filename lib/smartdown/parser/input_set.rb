module Smartdown
  module Parser
    class InputSet
      attr_reader :coversheet, :questions, :outcomes, :snippets, :scenario_sets

      def initialize(params = {})
        @coversheet = params[:coversheet]
        @questions = params[:questions]
        @outcomes = params[:outcomes]
        @snippets = params[:snippets]
        @scenario_sets = params[:scenario_sets]
      end
    end

    class InputData
      attr_reader :name, :content

      def initialize(name, content)
        @name = name
        @content = content
      end

      def read
        content
      end
    end
  end
end
