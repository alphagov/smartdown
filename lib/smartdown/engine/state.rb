require 'set'

module Smartdown
  class Engine
    class UndefinedValue < StandardError; end

    class State
      def initialize(data = {})
        @data = duplicate_and_normalize_hash(data)
        @data["path"] ||= []
        @data["responses"] ||= []
        raise ArgumentError, "must specify current_node" unless has_key?("current_node")
      end

      def has_key?(name)
        @data.has_key?(name.to_s)
      end

      def get(name)
        raise UndefinedValue unless has_key?(name)
        @data[name.to_s]
      end

      def put(name, value)
        State.new(@data.merge(name.to_s => value))
      end

      def keys
        Set.new(@data.keys)
      end

      def ==(other)
        other.is_a?(self.class) && other.keys == self.keys && @data.all? { |k, v| other.get(k) == v }
      end

    private
      def duplicate_and_normalize_hash(hash)
        ::Hash[hash.map { |key, value| [key.to_s, value] }]
      end
    end
  end
end
