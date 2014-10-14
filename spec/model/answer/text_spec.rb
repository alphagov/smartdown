describe Smartdown::Model::Answer::Text do
  let(:text_string) { "London" }
  subject(:instance) { described_class.new(text_string) }

  specify { expect(instance.to_s).to eql("London") }
end
