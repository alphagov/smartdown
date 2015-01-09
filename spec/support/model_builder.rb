require 'smartdown/model/flow'
require 'smartdown/model/node'
require 'smartdown/model/element/markdown_heading'
require 'smartdown/model/element/markdown_line'
require 'smartdown/model/element/start_button'
require 'smartdown/model/element/question'
require 'smartdown/model/element/question/multiple_choice'
require 'smartdown/model/element/question/date'
require 'smartdown/model/element/question/salary'
require 'smartdown/model/element/question/text'
require 'smartdown/model/element/conditional'
require 'smartdown/model/next_node_rules'
require 'smartdown/model/rule'
require 'smartdown/model/predicate/named'
require 'smartdown/model/predicate/equality'
require 'smartdown/model/predicate/set_membership'
require 'smartdown/model/predicate/and_operation'
require 'smartdown/model/predicate/comparison/greater_or_equal'
require 'smartdown/model/predicate/comparison/less_or_equal'
require 'smartdown/model/predicate/comparison/greater'
require 'smartdown/model/predicate/comparison/less'

class ModelBuilder
  def flow(name, &block)
    @nodes = []
    instance_eval(&block) if block_given?
    Smartdown::Model::Flow.new(name, @nodes)
  end

  def node(name, &block)
    @nodes ||= []
    @elements = []
    @front_matter = nil
    instance_eval(&block) if block_given?
    @nodes << Smartdown::Model::Node.new(name, @elements, @front_matter)
    @nodes.last
  end

  def heading(content)
    @elements ||= []
    @elements << Smartdown::Model::Element::MarkdownHeading.new(content)
    @elements.last
  end

  def line(content)
    @elements ||= []
    @elements << Smartdown::Model::Element::MarkdownLine.new(content)
    @elements.last
  end

  def start_button(content)
    @elements ||= []
    @elements << Smartdown::Model::Element::StartButton.new(content)
    @elements.last
  end

  def multiple_choice(name, options, question_alias=nil)
    @elements ||= []
    options_with_string_keys = ::Hash[options.map {|k,v| [k.to_s, v]}]
    @elements << Smartdown::Model::Element::Question::MultipleChoice.new(name, options_with_string_keys, question_alias)
    @elements.last
  end

  def date(name)
    @elements ||= []
    @elements << Smartdown::Model::Element::Question::Date.new(name)
    @elements.last
  end

  def next_steps(urls)
    @elements ||= []
    urls_with_string_keys = ::Hash[urls.map {|k,v| [k.to_s, v]}]
    @elements << Smartdown::Model::Element::NextSteps.new(urls_with_string_keys)
    @elements.last
  end

  def next_node_rules(&block)
    @rules = []
    instance_eval(&block) if block_given?
    @elements << Smartdown::Model::NextNodeRules.new(@rules)
    @elements.last
  end

  def rule(predicate = nil, outcome = nil, &block)
    @predicate = [predicate].compact
    @outcome = [outcome].compact
    @rules ||= []
    instance_eval(&block) if block_given?
    @rules << Smartdown::Model::Rule.new(@predicate.pop, @outcome.pop)
    @rules.last
  end

  def conditional(&block)
    @predicate ||= []
    @true_case ||= []
    @false_case ||= []
    @elements ||= []
    instance_eval(&block) if block_given?
    @elements << Smartdown::Model::Element::Conditional.new(@predicate.pop, [@true_case.pop], [@false_case.pop])
    @elements.last
  end

  def true_case(&block)
    instance_eval(&block) if block_given?
    @true_case << @elements.pop
    @true_case.last
  end

  def false_case(&block)
    instance_eval(&block) if block_given?
    @false_case << @elements.pop
    @false_case.last
  end

  def named_predicate(name)
    @predicate << Smartdown::Model::Predicate::Named.new(name)
  end

  def set_membership_predicate(varname, values)
    @predicate << Smartdown::Model::Predicate::SetMembership.new(varname, values)
  end

  def outcome(name)
    @outcome << name
  end

  module DSL
    def model_builder
      ModelBuilder.new
    end

    def build_flow(name, &block)
      model_builder.flow(name, &block)
    end
  end
end
