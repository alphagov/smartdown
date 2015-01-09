require 'smartdown/parser/node_parser'
require 'smartdown/parser/node_interpreter'
require 'smartdown/parser/element/money_question'

describe Smartdown::Parser::Element::MoneyQuestion do
  subject(:parser) { described_class.new }

  context 'with question tag' do
    let(:source) { '[money: court_fee]' }

    it 'parses' do
      should parse(source).as(
        money: {
          identifier: 'court_fee',
          option_pairs:[],
        }
      )
    end

    describe 'transformed' do
      let(:node_name) { 'my_node' }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Element::Question::Money.new('court_fee')) }
    end
  end

  context 'with question tag and alias' do
    let(:source) { '[money: court_fee, alias: claim_fee]' }

    it 'parses' do
      should parse(source).as(
        money: {
          identifier: 'court_fee',
          option_pairs: [
            {
              key: 'alias',
              value: 'claim_fee',
            }
          ]
        }
      )
    end

    describe 'transformed' do
      let(:node_name) { 'my_node' }
      subject(:transformed) {
        Smartdown::Parser::NodeInterpreter.new(node_name, source, parser: parser).interpret
      }

      it { should eq(Smartdown::Model::Element::Question::Money.new('court_fee', 'claim_fee')) }
    end
  end

end
