# Smartdown task list

## Parser and models

* cover sheet
* questions
 - multiple choice
 - date
 - salary
* multiple questions per node
 - symbolic identifier for each question (like Kramdown e.g. `# My question{#my-question}`)
 - Q: do we need to allow some q's to be optional?

## next node rules

* predicates
 * variable eq X
 * variable in set
 * date predicates ??
  * date op XXX
  * date between XXX and YYY
  * where XXX is either a specific date or a date relative to today
  * op is one of > < >= <=
 * money/salary predicates ??
 * named predicates

   ```
   predicate visiting_for_study? {
     purpose_of_visit is "study"
   }
   ```
* rule definitions
 * simple rule
  `* predicate => outcome`
 * nested rules

   ```
   * predicate1
     * predicate2 => outcome1
     * predicate3 => outcome2
   ```

## Variable interpolation

```
# How long are you planning to %{reason_of_staying} in the UK for?
```

Syntax `%{variable_name}` interpolates the value of the named variable from the state, which will be formatted appropriately for the type (date/money etc).

## Processing

- evaluating predicates in a state context to determine next node, calculating new state
- validation??

Note:
- calculations are probably not needed as they can either be done using an external plugin, or as a named predicate

## Plugin API

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

## Test scenarios (as data)

The main one will be

```
q1: a1
q2: a2
outcome
```

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

- parsing raw input from HTTP POST request (into value primitive String, Money, Salary, Date)
- redirect to canonical url on POST
- parsing raw input from URL fragment of GET request
- decide where responsibility for presenting interpolated values lies, options:
  - presenter does interpolation and parses strings with placeholders
  - presenter does interpolation and parser returns parse tree for dynamic string blocks
  - presenter passed to processor and used by processor to convert values for interpolation
- evaluation of conditional blocks in markdown body .. processor does this?
- Flow repository: loads the smartdown from disk or other place
- ERB html files, integrate with govuk template
- custom ERB html files
- presenter results vary on at what stage of the flow we are
- interpolating tables?

- actually figure out what the rules are of SPL
- actually build the calculator
