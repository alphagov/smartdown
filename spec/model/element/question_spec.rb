require 'smartdown/model/element/question'

describe Smartdown::Model::Element::Question do

  let(:elements) { [
    Smartdown::Model::Element::Question::Money.new('10.30'),
    Smartdown::Model::Element::Question::Date.new('2014-10-01')
  ] }

  describe 'constants()' do
    it 'has expected order' do
      expect(described_class.constants).to eq [
        :MultipleChoice,
        :Country,
        :Date,
        :Money,
        :Salary,
        :Text,
        :Postcode
      ]
    end
  end

  describe 'create_question_answer()' do

    context 'with no matching elements' do
      before do
        @question, @answer = described_class.create_question_answer([])
      end

      it 'does not create question or answer' do
        expect(@question).to be_nil
        expect(@answer).to be_nil
      end
    end

    context 'with response value not given' do
      before do
        @question, @answer = described_class.create_question_answer(elements)
      end

      it 'should create question with correct class' do
        expect(@question).to be_a Smartdown::Api::DateQuestion
      end

      it 'should not create answer' do
        expect(@answer).to be_nil
      end
    end

    context 'with response value given' do
      before do
        @question, @answer = described_class.create_question_answer(elements, '2014-10-01')
      end

      it 'should create question with correct class' do
        expect(@question).to be_a Smartdown::Api::DateQuestion
      end

      it 'should create answer with correct class' do
        expect(@answer).to be_a Smartdown::Model::Answer::Date
      end

      it 'should create answer with correct value' do
        expect(@answer.value.to_s).to eq('2014-10-01')
      end
    end
  end
end

