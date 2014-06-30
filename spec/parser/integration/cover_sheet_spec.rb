require 'smartdown/parser/node_interpreter'
require 'smartdown/model/element/start_button'

describe "interpreting a cover sheet containing a start button" do
  let(:source) { <<-SOURCE
meta_description: My coversheet

# Cover sheet

This is the cover sheet

[start: first_question?]
SOURCE
}
  let(:interpreter) { Smartdown::Parser::NodeInterpreter.new("my_node", source) }
  subject(:node) { interpreter.interpret }

  it "should have front_matter" do
    expect(node.front_matter.meta_description).to eq("My coversheet")
  end

  let(:start_button_element) do
    Smartdown::Model::Element::StartButton.new("first_question?")
  end

  it "should have start button element" do
    expect(node.elements).to include(start_button_element)
  end

end
