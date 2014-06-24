# Smartdown task list

## Parser and models

* cover sheet (0.5 day)
* questions (0.5 day)
 - multiple choice
 - date
 - salary

* multiple questions per node (1 day)
 - symbolic identifier for each question (like Kramdown e.g. `# My question{#my-question}`)
 - Q: do we need to allow some q's to be optional?

## next node rules

* basic predicates (1 day)
 * variable eq X
 * variable in set
* date predicates (1 day)
  * date op XXX
  * date between XXX and YYY
  * where XXX is either a specific date or a date relative to today
  * op is one of > < >= <=
* salary predicates (1 day)
  * salary op X per week
  * op is one of `>` `<` `>=` `<=`
* named predicates (1 day)

  ```
  predicate visiting_for_study? {
   purpose_of_visit is "study"
  }
  ```
* simple rule definitions (1 day)

  `* predicate => outcome`

* nested rule definitions (1 day)

   ```
   * predicate1
     * predicate2 => outcome1
     * predicate3 => outcome2
   ```

## Variable interpolation (1 day: presenter does interpolation and parses strings with placeholders)

```
# How long are you planning to %{reason_of_staying} in the UK for?
```

Syntax `%{variable_name}` interpolates the value of the named variable from the state, which will be formatted appropriately for the type (date/money etc).

## Processing (1 day)

- evaluating predicates in a state context to determine next node, calculating new state

## Plugin API (0.5 day)

A plugin API will be provided to allow more complex calculations to be defined
in an external ruby class. When a flow is loaded, the corresponding plugins are connected to the flow.

The plugin can define symbols in the state which are lazily evaluated.

```ruby

class MyCalculator
  def connect(flow)
    flow.define :some_value, ->(state) { complex_calculation(state.age, state.payday, state.birthday) }
  end
end

my_flow.add_plugin(MyCalculator.new)

```

## Test scenarios (as data) (1 day)

Test scenarios will be stored in a folder. Each file can define one or more scenarios of the form:

```
q1: a1
q2: a2
outcome
```

The tests will be run using a command-line tool which will run each scenario and report any errors.

## SPL frontend

```ruby
class MyController < ActionView::Controller

  def show
    flow = FlowRepository.load(flow_name)
    presenter = SmartdownPresenter.new(flow)
    presenter.evaluate(responses)
    presenter.present!
  end

end
```

- parsing raw input from HTTP POST request (into value primitive String, Money, Salary, Date) (0.5 day)
- redirect to canonical url on POST (0.5 day)
- parsing raw input from URL fragment of GET request (0.5 day)
- Flow repository: loads the smartdown from disk or other place (0.5 day)
- ERB html files, integrate with govuk template (0.5 day)
- presenters and ERB files (5 days)

- assist the writing of smardown (all the time)
- actually build the calculators (2 to 8 days)
