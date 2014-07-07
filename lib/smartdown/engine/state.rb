require 'smartdown/util/hash'

module Smartdown
  class Engine
    class UndefinedValue < StandardError; end

    class State
      include Smartdown::Util::Hash

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
    end
  end
end
