module Smartdown
  module Model
    class Flow
      extend Forwardable

      attr_reader :nodes, :coversheet

      def initialize(coversheet, nodes = [])
        @coversheet = coversheet
        @nodes = nodes
      end

      def_delegator :coversheet, :name

      def node(node_name)
        @nodes.find {|n| n.name.to_s == node_name.to_s } || raise("Unable to find #{node_name}")
      end

      def ==(other)
        other.is_a?(self.class) && other.nodes == self.nodes && other.coversheet == self.coversheet
      end
    end
  end
end
