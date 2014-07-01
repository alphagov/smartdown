module Smartdown
  module Model
    class FrontMatter
      def initialize(attributes = {})
        @attributes = attributes
      end

      def method_missing(method_name, *args, &block)
        if has_attribute?(method_name)
          fetch(method_name)
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        has_attribute?(method_name)
      end

      def has_attribute?(name)
        @attributes.has_key?(name.to_s)
      end

      def fetch(name)
        @attributes.fetch(name.to_s)
      end

      def to_hash
        @attributes.dup
      end

      def ==(other)
        other.is_a?(self.class) && self.to_hash == other.to_hash
      end
    end
  end
end
