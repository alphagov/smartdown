module SmartAnswer
  module Question
    class MultipleChoice < Base
      attr_reader :permitted_options

      def initialize(name, options = {}, &block)
        @permitted_options = []
        super
      end

      def option(transitions, options = {})
        if transitions.is_a?(Hash)
          transitions.each_pair do |option, next_node|
            @permitted_options << option.to_s
            next_node_if(next_node, responded_with(option.to_s))
          end
        else
          [*transitions].each { |option| @permitted_options << option.to_s }
        end
      end

      def options
        @permitted_options
      end

      def valid_option?(option)
        options.include?(option.to_s)
      end

      def parse_input(raw_input)
        raise SmartAnswer::InvalidResponse, "Illegal option #{raw_input} for #{name}", caller unless valid_option?(raw_input)
        super
      end
    end
  end
end
