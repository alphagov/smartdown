require 'set'

module Smartdown
  class Engine
    class UndefinedValue < StandardError; end

    class State
      def initialize(data = {})
        @data = duplicate_and_normalize_hash(data)
        @data["path"] ||= []
        @data["responses"] ||= []
        @cached = {}
        raise ArgumentError, "must specify current_node" unless has_key?("current_node")
      end

      def has_key?(key)
        @data.has_key?(key.to_s)
      end

      def has_value?(key, expected_value)
        has_key?(key) && fetch(key) == expected_value
      end

      def get(key)
        fetch(key)
      end

      def put(name, value)
        State.new(@data.merge(name.to_s => value))
      end

      def keys
        Set.new(@data.keys)
      end

      def ==(other)
        other.is_a?(self.class) && other.keys == self.keys && @data.all? { |k, v| other.has_value?(k, v) }
      end

    private
      def duplicate_and_normalize_hash(hash)
        ::Hash[hash.map { |key, value| [key.to_s, value] }]
      end

      def fetch(key)
        if has_key?(key)
          @data.fetch(key.to_s)
        else
          raise UndefinedValue, "variable '#{key}' not defined", caller
        end
      end
    end
  end
end
