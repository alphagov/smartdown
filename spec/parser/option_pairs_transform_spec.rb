require 'smartdown/parser/option_pairs_transform'

describe Smartdown::Parser::OptionPairs do
  describe '.transform' do
    subject(:transform) { Smartdown::Parser::OptionPairs.transform(input) }

    context 'blank array' do
      let(:input) { [] }
      it 'returns empty hash' do
        expect(transform).to eql({})
      end
    end

    context 'single array of option pairs hash passed' do
      let(:input) { [{key: 'dog', value: 'woof'}] }
      it 'returns hash containing key value pairs' do
        expect(transform).to eql({'dog' => 'woof'})
      end
    end

    context 'single array of option pairs hash passed' do
      let(:input) { [{key: 'dog', value: 'woof'}, {key: 'cat', value: 'meow'}] }
      it 'returns hash containing key value pairs' do
        expect(transform).to eql({'dog' => 'woof', 'cat' => 'meow'})
      end
    end

    context 'single array of option pairs hash passed value not string' do
      let(:input) { [{key: 'number', value: 1}] }
      it 'returns hash containing key value pairs calling after calling .to_s' do
        expect(transform).to eql({'number' => '1'})
      end
    end

  end
end
