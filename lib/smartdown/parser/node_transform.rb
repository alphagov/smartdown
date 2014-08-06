require 'parslet/transform'
require 'smartdown/model/node'
require 'smartdown/model/front_matter'
require 'smartdown/model/rule'
require 'smartdown/model/nested_rule'
require 'smartdown/model/next_node_rules'
require 'smartdown/model/element/multiple_choice'
require 'smartdown/model/element/start_button'
require 'smartdown/model/element/markdown_heading'
require 'smartdown/model/element/markdown_paragraph'
require 'smartdown/model/element/conditional'
require 'smartdown/model/predicate/equality'
require 'smartdown/model/predicate/set_membership'
require 'smartdown/model/predicate/named'

module Smartdown
  module Parser
    class NodeTransform < Parslet::Transform
      rule(body: subtree(:body)) {
        Smartdown::Model::Node.new(
          node_name, body, Smartdown::Model::FrontMatter.new({})
        )
      }

      rule(h1: simple(:content)) {
        Smartdown::Model::Element::MarkdownHeading.new(content)
      }

      rule(p: simple(:content)) {
        Smartdown::Model::Element::MarkdownParagraph.new(content)
      }

      rule(:start_button => simple(:start_node)) {
        Smartdown::Model::Element::StartButton.new(start_node)
      }

      rule(:front_matter => subtree(:attrs), body: subtree(:body)) {
        Smartdown::Model::Node.new(
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
        Smartdown::Model::Element::MultipleChoice.new(
          node_name, Hash[choices]
        )
      }

      # Conditional with no content in true-case
      rule(:conditional => {:predicate => subtree(:predicate)}) {
        Smartdown::Model::Element::Conditional.new(predicate)
      }

      # Conditional with content in true-case
      rule(:conditional => {
             :predicate => subtree(:predicate),
             :true_case => subtree(:true_case)
           }) {
        Smartdown::Model::Element::Conditional.new(predicate, true_case)
      }

      # Conditional with content in both true-case and false-case
      rule(:conditional => {
             :predicate => subtree(:predicate),
             :true_case => subtree(:true_case),
             :false_case => subtree(:false_case)
           }) {
        Smartdown::Model::Element::Conditional.new(predicate, true_case, false_case)
      }

      rule(:equality_predicate => { varname: simple(:varname), expected_value: simple(:expected_value) }) {
        Smartdown::Model::Predicate::Equality.new(varname, expected_value)
      }

      rule(:set_value => simple(:value)) { value }
      rule(:set_membership_predicate => { varname: simple(:varname), values: subtree(:values) }) {
        Smartdown::Model::Predicate::SetMembership.new(varname, values)
      }

      rule(:named_predicate => simple(:name) ) {
        Smartdown::Model::Predicate::Named.new(name)
      }

      rule(:rule => {predicate: subtree(:predicate), outcome: simple(:outcome_name) } ) {
        Smartdown::Model::Rule.new(predicate, outcome_name)
      }
      rule(:nested_rule => {predicate: subtree(:predicate), child_rules: subtree(:child_rules) } ) {
        Smartdown::Model::NestedRule.new(predicate, child_rules)
      }
      rule(:next_node_rules => subtree(:rules)) {
        Smartdown::Model::NextNodeRules.new(rules)
      }
    end
  end
end

