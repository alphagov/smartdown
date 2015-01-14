require 'parslet/transform'
require 'smartdown/parser/option_pairs_transform'
require 'smartdown/model/node'
require 'smartdown/model/front_matter'
require 'smartdown/model/elements'
require 'smartdown/model/rule'
require 'smartdown/model/nested_rule'
require 'smartdown/model/next_node_rules'
require 'smartdown/model/element/question/multiple_choice'
require 'smartdown/model/element/question/country'
require 'smartdown/model/element/question/date'
require 'smartdown/model/element/question/salary'
require 'smartdown/model/element/question/text'
require 'smartdown/model/element/question/postcode'
require 'smartdown/model/element/question/money'
require 'smartdown/model/element/start_button'
require 'smartdown/model/element/markdown_heading'
require 'smartdown/model/element/markdown_line'
require 'smartdown/model/element/conditional'
require 'smartdown/model/element/next_steps'
require 'smartdown/model/predicate/equality'
require 'smartdown/model/predicate/set_membership'
require 'smartdown/model/predicate/named'
require 'smartdown/model/predicate/not_operation'
require 'smartdown/model/predicate/and_operation'
require 'smartdown/model/predicate/or_operation'
require 'smartdown/model/predicate/function'
require 'smartdown/model/predicate/comparison/greater_or_equal'
require 'smartdown/model/predicate/comparison/greater'
require 'smartdown/model/predicate/comparison/less_or_equal'
require 'smartdown/model/predicate/comparison/less'

module Smartdown
  module Parser
    class NodeTransform < Parslet::Transform

      rule(body: subtree(:body)) {
        Smartdown::Model::Node.new(
          node_name, body, Smartdown::Model::FrontMatter.new({})
        )
      }

      rule(blank_line: simple(:blank_line), element: subtree(:element)) {
        Smartdown::Model::Elements.new(
          [
            Smartdown::Model::Element::MarkdownLine.new(blank_line.to_s),
            element,
          ]
        )
      }

      rule(h1: simple(:content)) {
        Smartdown::Model::Element::MarkdownHeading.new(content.to_s)
      }

      rule(:line => simple(:content)) {
        Smartdown::Model::Element::MarkdownLine.new(content.to_s)
      }

      rule(:blank => simple(:content)) {
        Smartdown::Model::Element::MarkdownLine.new(content.to_s)
      }

      rule(:blank_line => simple(:content)) {
        Smartdown::Model::Element::MarkdownLine.new(content.to_s)
      }

      rule(:start_button => simple(:start_node)) {
        Smartdown::Model::Element::StartButton.new(start_node.to_s)
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

      rule(:url => simple(:url), :label => simple(:label)) {
        [url.to_s, label.to_s]
      }

      rule(:multiple_choice => {identifier: simple(:identifier), :option_pairs => subtree(:option_pairs), options: subtree(:choices)}) {
        Smartdown::Model::Element::Question::MultipleChoice.new(
          identifier.to_s,
          Hash[choices],
          Smartdown::Parser::OptionPairs.transform(option_pairs).fetch('alias', nil),
        )
      }

      rule(:country => {identifier: simple(:identifier), :option_pairs => subtree(:option_pairs)}) {
        country_data_method = Smartdown::Parser::OptionPairs.transform(option_pairs).fetch('countries', nil)
        country_hash = data_module[country_data_method].call
        Smartdown::Model::Element::Question::Country.new(
          identifier.to_s,
          country_hash,
          Smartdown::Parser::OptionPairs.transform(option_pairs).fetch('alias', nil)
        )
      }

      rule(:date => {identifier: simple(:identifier), :option_pairs => subtree(:option_pairs)}) {
        transformed_option_pairs = Smartdown::Parser::OptionPairs.transform(option_pairs)
        Smartdown::Model::Element::Question::Date.new(
          identifier.to_s,
          transformed_option_pairs.fetch('from', nil),
          transformed_option_pairs.fetch('to', nil),
          transformed_option_pairs.fetch('alias', nil),
        )
      }

      rule(:salary => {identifier: simple(:identifier), :option_pairs => subtree(:option_pairs)}) {
        Smartdown::Model::Element::Question::Salary.new(
          identifier.to_s,
          Smartdown::Parser::OptionPairs.transform(option_pairs).fetch('alias', nil)
        )
      }

      rule(:text => {identifier: simple(:identifier), :option_pairs => subtree(:option_pairs)}) {
        Smartdown::Model::Element::Question::Text.new(
          identifier.to_s,
          Smartdown::Parser::OptionPairs.transform(option_pairs).fetch('alias', nil)
        )
      }

      rule(:postcode => {identifier: simple(:identifier), :option_pairs => subtree(:option_pairs)}) {
        Smartdown::Model::Element::Question::Postcode.new(
          identifier.to_s,
          Smartdown::Parser::OptionPairs.transform(option_pairs).fetch('alias', nil)
        )
      }

      rule money: { identifier: simple(:identifier), option_pairs: subtree(:option_pairs) } {
        Smartdown::Model::Element::Question::Money.new(
          identifier.to_s,
          Smartdown::Parser::OptionPairs.transform(option_pairs).fetch('alias', nil)
        )
      }

      rule(:next_steps => { content: simple(:content) }) {
        Smartdown::Model::Element::NextSteps.new(content.to_s)
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
        Smartdown::Model::Predicate::Equality.new(varname.to_s, expected_value.to_s)
      }

      rule(:set_value => simple(:value)) { value }

      rule(:set_membership_predicate => { varname: simple(:varname), values: subtree(:values) }) {
        Smartdown::Model::Predicate::SetMembership.new(varname.to_s, values)
      }

      rule(:named_predicate => simple(:name) ) {
        Smartdown::Model::Predicate::Named.new(name.to_s)
      }

      rule(:otherwise_predicate => simple(:name) ) {
        Smartdown::Model::Predicate::Otherwise.new
      }

      rule(:and_operation => {first_predicate: subtree(:first_predicate), and_predicates: subtree(:and_predicates) }) {
        Smartdown::Model::Predicate::AndOperation.new([first_predicate]+and_predicates)
      }

      rule(:or_operation => {first_predicate: subtree(:first_predicate), or_predicates: subtree(:or_predicates) }) {
        Smartdown::Model::Predicate::OrOperation.new([first_predicate]+or_predicates)
      }

      rule(:not_operation => {predicate: subtree(:predicate)}) {
        Smartdown::Model::Predicate::NotOperation.new(predicate)
      }

      rule(:function_argument => simple(:argument)) { argument.to_s }

      rule(:function_predicate => { name: simple(:name), arguments: subtree(:arguments) }) {
        Smartdown::Model::Predicate::Function.new(name.to_s, Array(arguments))
      }

      rule(:function_predicate => { name: simple(:name) }) {
        Smartdown::Model::Predicate::Function.new(name.to_s, [])
      }

      rule(:comparison_predicate => { varname: simple(:varname),
                                       value: simple(:value),
                                       operator: simple(:operator)
                                     }) {
        case operator
        when "<="
          Smartdown::Model::Predicate::Comparison::LessOrEqual.new(varname.to_s, value.to_s)
        when "<"
          Smartdown::Model::Predicate::Comparison::Less.new(varname.to_s, value.to_s)
        when ">="
          Smartdown::Model::Predicate::Comparison::GreaterOrEqual.new(varname.to_s, value.to_s)
        when ">"
          Smartdown::Model::Predicate::Comparison::Greater.new(varname.to_s, value.to_s)
        else
          raise "Comparison operator not recognised"
        end
      }

      rule(:rule => {predicate: subtree(:predicate), outcome: simple(:outcome_name) } ) {
        Smartdown::Model::Rule.new(predicate, outcome_name.to_s)
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

