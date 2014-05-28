module SmartAnswer
  module Question
    class Checkbox < Base
      NONE_OPTION = 'none'
      attr_reader :options

      def initialize(name, options = {}, &block)
        @options = []
        super
      end

      attr_reader :options

      def option(option_slug)
        raise InvalidNode.new("Can't use reserved option name '#{NONE_OPTION}'") if option_slug.to_s == NONE_OPTION
        raise InvalidNode.new("Invalid option specified") unless option_slug.to_s =~ /\A[a-z0-9_-]+\z/
        @options << option_slug.to_s
      end

      def valid_option?(option)
        @options.include?(option)
      end

      def parse_input(raw_input)
        return NONE_OPTION if raw_input.blank? or raw_input == NONE_OPTION
        raw_input = raw_input.split(',') if raw_input.is_a?(String)
        raw_input.each do |option|
          raise SmartAnswer::InvalidResponse, "Illegal option #{option} for #{name}", caller unless valid_option?(option)
        end
        raw_input.sort.join(',')
      end

      def to_response(input)
        input.split(',').reject {|v| v == NONE_OPTION }
      end

      # Returns a predicate function which when given a response
      # returns a boolean indicating whether the response was one
      # of the accepted responses.
      def response_is_one_of(accepted_responses)
        SmartAnswer::Predicate::ResponseIsOneOf.new(accepted_responses)
      end

      def response_has_all_of(required_responses)
        SmartAnswer::Predicate::ResponseHasAllOf.new(required_responses)
      end
    end
  end
end
