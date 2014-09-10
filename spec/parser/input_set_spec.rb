require 'smartdown/parser/input_set'
require 'support/flow_input_interface'

describe Smartdown::Parser::InputSet do
  it_should_behave_like "flow input interface"
end

describe Smartdown::Parser::InputData do
  let(:name) { 'a name' }
  let(:data) { 'some smartdown' }
  subject { Smartdown::Parser::InputData.new(name, data) }

  specify { expect(subject.name).to eql name }
  specify { expect(subject.read).to eql data }
end
