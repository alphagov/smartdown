module SmartAnswer
  class Node
    attr_reader :name, :title

    def initialize(name, title)
      @name = name
      @title = title
    end

    def outcome?
      false
    end

    def question?
      false
    end
  end
end
