require 'smartdown/model/flow'
require 'smartdown/model/node'
require 'smartdown/model/element/markdown_heading'
require 'smartdown/model/element/markdown_paragraph'
require 'smartdown/model/element/start_button'
require 'smartdown/model/element/multiple_choice'
require 'smartdown/model/next_node_rules'
require 'smartdown/model/rule'
require 'smartdown/model/predicate/named'
require 'smartdown/model/predicate/equality'
require 'smartdown/model/predicate/set_membership'

module Smartdown
  module Model
    class Builder
      def initialize
        @stack = []
      end

      def build(&block)
        instance_eval(&block)
      end

      def flow(name, &block)
        @stack << {nodes: []}
        yield
        data = @stack.pop
        Flow.new(name, data[:nodes])
      end

      def node(name, &block)
        @stack << {elements: [], front_matter: nil}
        yield
        data = @stack.pop
        @stack.last[:nodes] << Node.new(name, data[:elements], data[:front_matter])
      end

      def heading(content)
        @stack.last[:elements] << Element::MarkdownHeading.new(content)
      end

      def paragraph(content)
        @stack.last[:elements] << Element::MarkdownParagraph.new(content)
      end

      def start_button(content)
        @stack.last[:elements] << Element::StartButton.new(content)
      end

      def multiple_choice(options)
        options_with_string_keys = ::Hash[options.map {|k,v| [k.to_s, v]}]
        @stack.last[:elements] << Element::MultipleChoice.new(nil, options_with_string_keys)
      end

      def next_node_rules(&block)
        @stack << {rules: []}
        yield
        data = @stack.pop
        @stack.last[:elements] << NextNodeRules.new(data[:rules])
      end

      def rule(&block)
        @stack << {predicate: nil, outcome: nil}
        yield
        data = @stack.pop
        @stack.last[:rules] << Rule.new(data[:predicate], data[:outcome])
      end

      def named_predicate(name)
        @stack.last[:predicate] = Predicate::Named.new(name)
      end

      def outcome(name)
        @stack.last[:outcome] = name
      end
    end
  end
end
