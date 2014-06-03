require 'smartdown/model/question/base'
require 'model/question/shared_examples'

describe Smartdown::Model::Question::Base do
  subject {
    Smartdown::Model::Question::Base.new(name, body: body)
  }

  it_behaves_like "a question"
end
