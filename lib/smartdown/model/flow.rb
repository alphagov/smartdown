module Smartdown
  module Model
    class Flow
      attr_reader :name, :nodes

      def initialize(name, nodes = [])
        @name = name
        @nodes = nodes
      end

      def coversheet
        node(name)
      end

      def node(node_name)
        @nodes.find {|n| n.name.to_s == node_name.to_s } || raise("Unable to find #{node_name}")
      end

      def ==(other)
        other.is_a?(self.class) && other.nodes == self.nodes && other.name == self.name
      end
    end
  end
end
