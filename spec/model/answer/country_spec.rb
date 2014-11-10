describe Smartdown::Model::Answer::Country do
  let(:text_string) { "United Kingdom" }
  subject(:instance) { described_class.new(text_string) }

  specify { expect(instance.to_s).to eql("United Kingdom") }
end
