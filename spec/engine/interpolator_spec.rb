# encoding: utf-8
#TODO: this "require" for money is here for now since there is no associated question type for money yet
require 'smartdown/model/answer/money'
require 'smartdown/engine/interpolator'
require 'smartdown/engine/state'
require 'parslet'
require 'date'

describe Smartdown::Engine::Interpolator do
  subject(:interpolator) { described_class.new }

  let(:example_name) { "Neil" }

  let(:state) {
    Smartdown::Engine::State.new(
      current_node: node.name,
      name: example_name
    )
  }

  let(:interpolated_node) { interpolator.call(node, state) }

  let(:node) {
    Smartdown::Model::Node.new("example", elements)
  }

  context "a node with no elements" do
    let(:elements) { [] }

    it "returns the node unchanged" do
      expect(interpolator.call(node, state)).to eq(node)
    end
  end

  context "a node with elements with no interpolations" do
    let(:node) {
      model_builder.node("example") do
        heading("a heading")
        paragraph("some_stuff")
        conditional do
          named_predicate "pred?"
          true_case do
            paragraph("True case")
          end
          false_case do
            paragraph("False case")
          end
        end
        multiple_choice("example", {})
        next_node_rules
      end
    }

    it "returns the node unchanged" do
      expect(interpolated_node).to eq(node)
    end
  end

  context "a node with a paragraph containing an interpolation" do
    let(:elements) { [Smartdown::Model::Element::MarkdownParagraph.new('Hello %{name}')] }

    it "interpolates the name into the paragraph content" do
      expect(interpolated_node.elements.first.content).to eq("Hello #{example_name}")
    end
  end

  context "a node with a heading containing an interpolation" do
    let(:elements) { [Smartdown::Model::Element::MarkdownHeading.new('Hello %{name}')] }

    it "interpolates the name into the paragraph content" do
      expect(interpolated_node.elements.first.content).to eq("Hello #{example_name}")
    end
  end

  context "a paragraph containing function call" do
    let(:elements) { [Smartdown::Model::Element::MarkdownParagraph.new('%{double(number)}')] }
    let(:state) {
      Smartdown::Engine::State.new(
        current_node: node.name,
        number: 10,
        double: ->(number) { number * 2 }
      )
    }
    it "interpolates the result of the function call" do
      expect(interpolated_node.elements.first.content).to eq("20")
    end
  end

  context "a paragraph containing function call with two arguments" do
    let(:elements) { [Smartdown::Model::Element::MarkdownParagraph.new('%{multiply(number other_number)}')] }
    let(:state) {
      Smartdown::Engine::State.new(
          current_node: node.name,
          number: 10,
          other_number: 2,
          multiply: ->(number, other_number) { number * other_number }
      )
    }
    it "interpolates the result of the function call" do
      expect(interpolated_node.elements.first.content).to eq("20")
    end
  end

  context "a paragraph containing a date answer" do
    let(:elements) { [Smartdown::Model::Element::MarkdownParagraph.new('%{date_answer}')] }
    let(:state) {
      Smartdown::Engine::State.new(
          current_node: node.name,
          date_answer: Smartdown::Model::Answer::Date.new("2014-1-1")
      )
    }
    it "interpolates the result of the function call" do
      expect(interpolated_node.elements.first.content).to eq("1 January 2014")
    end
  end

  context "a paragraph containing a money answer" do
    let(:elements) { [Smartdown::Model::Element::MarkdownParagraph.new('%{money_answer}')] }
    let(:state) {
      Smartdown::Engine::State.new(
          current_node: node.name,
          money_answer: Smartdown::Model::Answer::Money.new(1233.32523)
      )
    }
    it "interpolates the result of the function call" do
      expect(interpolated_node.elements.first.content).to eq("£1,233.33")
    end
  end
end
