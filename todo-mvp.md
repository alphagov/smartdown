# Smartdown task list

Plan: build student finance forms in smartdown

## Parser and models

* cover sheet
* questions
 - multiple choice
* multiple questions per node
 - anticipate this, but don't build yet

## next node rules

* predicates
 * variable eq X
 * variable in set
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

## Test scenarios (as data)

The main one will be

```
q1: a1
q2: a2
outcome
```

## Smart-answer frontend

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

- new rails 4.x app
- put it in bowler etc
- copy/adapt javascript+css+templates
- dummy flow (fake rules/data, only multiple choice questions) to illustrate API
- parsing raw input from HTTP POST request (into value primitive String)
- parsing raw input from URL fragment of GET request
- redirect to canonical url on POST
- Flow repository: loads the smartdown from disk
- puppetize
  - DH to spec out, DS to do with DH help
  - https://github.gds/pages/gds/opsmanual/infrastructure/howto/setting-up-new-rails-app.html?highlight=new%20app
  - rubocop
- panopticon + routing TBC -- content store?

