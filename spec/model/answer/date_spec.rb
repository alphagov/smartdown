require 'smartdown/model/answer/date'
require 'smartdown/model/element/question/date'

describe Smartdown::Model::Answer::Date do
  let(:date_string) { "2014-9-4" }
  let(:question) { Smartdown::Model::Element::Question::Date.new("a_date") }
  subject(:instance) { described_class.new(question, date_string) }

  specify { expect(instance.value).to eql Date.new(2014, 9, 4) }
  specify { expect(instance.to_s).to eql "2014-9-4" }
end
