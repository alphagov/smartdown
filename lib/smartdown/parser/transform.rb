require 'parslet/transform'
require 'smartdown/model/front_matter'

module Smartdown
  module Parser
    class Transform < Parslet::Transform
      rule(:front_matter => subtree(:attrs), body: subtree(:body)) {
        Smartdown::Model::Coversheet.new(
          nil, body, Smartdown::Model::FrontMatter.new(Hash[attrs])
        )
      }
      rule(:front_matter => subtree(:attrs)) {
        [Smartdown::Model::FrontMatter.new(Hash[attrs])]
      }
      rule(:name => simple(:name), :value => simple(:value)) {
        [name.to_s, value.to_s]
      }
    end
  end
end

