require 'smartdown/engine/interpolator'
require 'smartdown/engine/state'

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
        multiple_choice({})
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
end
