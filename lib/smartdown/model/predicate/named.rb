module Smartdown
  module Model
    module Predicate
      Named = Struct.new(:name) do
        def evaluate(state)
          state.get(name)
        end

        def humanize
          "#{name.to_s.chomp('?')}?"
        end
      end
    end
  end
end
