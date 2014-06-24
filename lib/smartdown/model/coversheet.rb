module Smartdown
  module Model
    class Coversheet
      attr_accessor :name, :front_matter

      def initialize(name, body_blocks, front_matter)
        @name = name
        @body_blocks = body_blocks
        @front_matter = front_matter
      end

      def title
        h1s.first.to_s.strip
      end

      def h1s
        @body_blocks.map { |block| block.fetch(:h1, nil) }.compact
      end

      def body
        @body_blocks[1..-1].map { |block| block.values.first }.compact.join("\n")
      end
    end
  end
end
