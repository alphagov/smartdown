require 'parslet/transform'
require 'smartdown/model/front_matter'
require 'smartdown/model/question/multiple_choice'

module Smartdown
  module Parser
    class Transform < Parslet::Transform
      rule(body: subtree(:body)) {
        page_class.new(
          node_name, body, Smartdown::Model::FrontMatter.new({})
        )
      }
      rule(:front_matter => subtree(:attrs), body: subtree(:body)) {
        page_class.new(
          node_name, body, Smartdown::Model::FrontMatter.new(Hash[attrs])
        )
      }
      rule(:front_matter => subtree(:attrs)) {
        [Smartdown::Model::FrontMatter.new(Hash[attrs])]
      }
      rule(:name => simple(:name), :value => simple(:value)) {
        [name.to_s, value.to_s]
      }

      rule(:value => simple(:value), :label => simple(:label)) {
        [value.to_s, label.to_s]
      }

      rule(:multiple_choice => subtree(:choices)) {
        Smartdown::Model::Question::MultipleChoice.new(
          node_name, Hash[choices]
        )
      }
    end
  end
end

