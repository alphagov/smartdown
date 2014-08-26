require 'smartdown/model/flow'
require 'smartdown/model/node'
require 'smartdown/model/element/markdown_heading'
require 'smartdown/model/element/markdown_paragraph'
require 'smartdown/model/element/start_button'
require 'smartdown/model/element/question/multiple_choice'
require 'smartdown/model/element/question/date'
require 'smartdown/model/element/question/salary'
require 'smartdown/model/element/conditional'
require 'smartdown/model/next_node_rules'
require 'smartdown/model/rule'
require 'smartdown/model/predicate/named'
require 'smartdown/model/predicate/equality'
require 'smartdown/model/predicate/set_membership'

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

  def paragraph(content)
    @elements ||= []
    @elements << Smartdown::Model::Element::MarkdownParagraph.new(content)
    @elements.last
  end

  def start_button(content)
    @elements ||= []
    @elements << Smartdown::Model::Element::StartButton.new(content)
    @elements.last
  end

  def multiple_choice(name, options)
    @elements ||= []
    options_with_string_keys = ::Hash[options.map {|k,v| [k.to_s, v]}]
    @elements << Smartdown::Model::Element::Question::MultipleChoice.new(name, options_with_string_keys)
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
    @predicate = predicate
    @outcome = outcome
    @rules ||= []
    instance_eval(&block) if block_given?
    @rules << Smartdown::Model::Rule.new(@predicate, @outcome)
    @rules.last
  end

  def conditional(&block)
    @predicate = nil
    @true_case = nil
    @false_case = nil
    @elements ||= []
    instance_eval(&block) if block_given?
    @elements << Smartdown::Model::Element::Conditional.new(@predicate, @true_case, @false_case)
    @elements.last
  end

  def true_case(&block)
    @outer_elements = @elements
    @elements = []
    instance_eval(&block) if block_given?
    @true_case = @elements
    @elements = @outer_elements
    @true_case
  end

  def false_case(&block)
    @outer_elements = @elements
    @elements = []
    instance_eval(&block) if block_given?
    @false_case = @elements
    @elements = @outer_elements
    @false_case
  end

  def named_predicate(name)
    @predicate = Smartdown::Model::Predicate::Named.new(name)
  end

  def outcome(name)
    @outcome = name
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
