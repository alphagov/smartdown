module SmartDown
  class NodeTransformer < Parslet::Transform
    rule(:flow_command => simple(:command)) {}
    rule(
      :question_type => simple(:type),
      :question_name => simple(:name)) do
      SmartAnswer::Question::MultipleChoice.new(name)
    end
  end
end
