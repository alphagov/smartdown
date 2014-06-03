module Smartdown
  module Util
    module Hash
      def duplicate_and_normalize_hash(hash)
        ::Hash[hash.map {|k,v| [k.to_s, v]}]
      end
    end
  end
end
