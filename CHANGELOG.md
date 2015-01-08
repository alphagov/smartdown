## 0.12.1

Bug: ignore blank line between question headings when building question pages

## 0.12.0

Blank line parsing: parse new lines and maintain number of new lines in markdown
instead of treating them as separtors.

`===` separators for front matter.

Test fix: text failures on change of year to 2015

## 0.11.4

Bug fix: return answer even if postcode is invalid

## 0.11.3

Add postcode question.
Provides the ability to accept postcode value answers.

* postcode question

```[postcode: home]```

Accepts only valid full postcodes.

## 0.11.2

Bug fixes for nodes with no body/post body - now retuns nil instead of "" to
be consitent with the rest of the API

## 0.11.1

Fix bugs with missing elements

If certain optional elements were omitted, the api was throwing an
exception, instead of returning nil - the behaviour prior to 0.11.0

## 0.11.0

More lenient whitespace rules

It is now legal to have any whitespace you like on mandatory blank
lines between smartdown elements. eg. a tab on your blank line will not
longer cause a parsing error.


Nested if statements

If statements can now be nested inside if, else and elsif branches.


Custom markdown tags inside conditionals

It is now possible to include custom markdown tags beginning with the `$`
character inside conditional statements - this is mainly an improvement
for govspeak custom markdown tags.


Markdown not HMTL

The Smartdown API now returns raw markdown instead of html.

## 0.10.0

Date Question range options

You can now specify `to` and `from` options to display questions to
decide which year range they can take, in both absolute and relative
(from current year)
format.

eg

[date: year_of_birth, from: 1990 to: 2012]

or

[date: year_of_birth, from: -10 to: 10]

## 0.9.0

Country questions and data modules

example country question:

```[country: country_of_birth, countries: all_countries]```

```all_countries``` is the name of a method in a data module which
can now be optionally supplied via the flow api as a hash of methods/
lambdas.

The initial state is now also optionally supplied via the flow api.

Eg. what was previously:
  ````
  Flow.new(smartdown_input, initial_state)
  ````
is now:
  ````
  options = {initial_state: initial_state, data_module: data_module}
  Flow.new(smartdown_input, options)
  ````

## 0.8.2

Implement question identifier aliasing.

eg.

```[choice: question1, alias: the_first_question]```

This question may be referred to as question1, or the_first_question
henceforth.

```$ELSEIF``` syntax - can now use elseif clauses in conditionals.


## 0.8.1

Fix bugs in meta_description and need_id for Api::Flow

Implement post_body for Api::Question objects

## 0.8.0

Input validation for smartdown questions, exposes answer objects and invalid responses on State.

Money and salary formatting according to GDS standards

Body and post-body on all Node objects, not just cover sheet

## 0.7.1

Multi-line descriptions for scenarios are supported.

## 0.7.0

Scenario sets on flow: Api::Flow object now has a scenario_sets public method
that lists all scenarios and their questions

Adds support for exposing answers and humanizing them:
* Api::Question object now has an answer method which returns an Answer object.
* Answer objects all have a humanize method which returns the user-friendly version of its value.

## 0.6.0

Add text question.
Provides the ability to accept text value answers.

* text question

```[text: text_question]```

## 0.5.4

Modify Answer API to take value as first attribute, question as optional second attribute.
This allows the use of Answer objects in a plugin context, not just as a answer to a question.

## 0.5.3

Interpolate humanized versions of date and money answers

Fix a bug in the ParseError exception message

## 0.5.2

Fix a bug where `PreviousQuestionPage` would include a page title when it shouldn't.

Minor API fix to methods rendering `govspeak` output (eg `body`, `title`), so that they return nil for empty values, not `""` or `"\n"`.

## 0.5.1

Answers are now parsed into typed objects depending on the question type.


## 0.5.0

Add snippets feature. These are re-usage bits of content.

They're stored in a `snippets/` directory in the flow root, and are called like:
```{{snippet: snippet_name}}```

Which will include the `snippets/snippet_name.txt` file into the question/outcome.

## 0.4.0

### Breaking changes

* [Plugins](https://github.com/alphagov/smart-answers/blob/master/lib/smartdown_adapter/plugins.rb) calls now take specific arguments, not just state. Some plugins will need rewriting and their call syntax in a flow updated.

### New features
* Predicate models now provide a `humanize` function, for a friendly representation
* Plugin calls can be used within interpolation
* Plugin calls can be nested

## 0.3.0

* State values can be inserted into smart down text

Given a state, with the key "question_1" as "frogs", the following smartdown:
```
Your pond is full of %{question_1}.
```
will render to
```
Your pond is full of frogs.
```

* add support for initial_state

Additional state keys can be added when instantiating a flow. State objects can either be simple objects, or any object which responds to ```call``` taking ```state``` as an argument eg:

```ruby
initial_state = {
  the_meaning_of_life: 42,
  whats_really_important: ->(state) {
    state.get("the_meaning_of_life") + " rashers of bacon"
  }
}

Smartdown::Api::Flow.new(input, initial_state)
```
and in smartdown

```
# Your recommended breakfast

For breakfast, you should have %{whats_really_important}.
```


## 0.2.1

* date question

```[date: due_date]```

* salary question

```[salary: salary_mother]```

* parse combinations of predicates: ```predicate AND predicate```

* parse predicate comparisons, for dates and integers: ```variable > '5'```, ```variable > '2014-4-23'```

* API changes:
  - question made public on PreviousQuestion
  - coversheet made public on Flow

## 0.2.0

###Simplify Smartdown API

Remove any logic that should belongs to frontend applications. This has a large number of breaking changes and the best way to see what they are is [this smart-answer pull request](https://github.com/alphagov/smart-answers/pull/1079/files
):
* removing a large number of methods from API models (since they are presentation methods)
* implement PreviousQuestion and PreviousQuestionPage
* implement QuestionPage
* no longer assumes that every smartdown page starts with a title: it is considered it has a title if there are more headers than questions, otherwise all headers become question titles

## 0.1.1

### Adds `Smartdown:Api` module

This module acts as a more stable, public inteface to Smartdown.

It hides the internal implementation details, so they can be changed without
introducing backwards incompatible changes so frequently.

Smartdown should now be called by constructing an `input`, and then constructing
your `flow` object.

```ruby
    input = Smartdown::Api::DirectoryInput.new(coversheet_path)
    flow = Smartdown::Api::Flow.new(input)
```

Where `coversheet_path` is a file system path to the coversheet of a Smartdown
package of files. Eg, `smartdown-flow-name/smartdown-flow-name.txt`.

More kinds of input (like plain data) will be made available soon.

## 0.1.0

### Multiple questions per node

This adds support for more than one question to be presented on the same node.

* This doesn't alter the input format, which is still an array of answers - not
grouped by parent question.
* Question nodes now contain one or more questions models


## 0.0.4

### Interpolation

Interpolate a variable from state into Govspeak text.

```
Your state pension age is %{state_pension_age}
```

These values currently come from previous question answers and is te exact value
rather than the human 'label' of the answer.

Once plugins/calculations are added they will support interpolation as well.

### Start button first node

Previously cover pages needed a single `* otherwise =>` next node rule to define
the first question. This can now be done as part of the start button definition.

```
[start_button: what_passport_do_you_have]
```

### Next steps

This is follow on content that appears distinct from the outcome itself, was not
modelled in Smartdown before:

```
[next_steps]
... Govspeak goes here ...
[end_next_steps]
```

### Question variable name definition

Previously this was inferred from the node/file name, now this _must_ be
specified by the question definition, which gives more flexibility and will help
support multiple questions per node.

```
[choice: uk_border_control]
```




## 0.0.3

* support for conditionals
* mandatory 'tag' on choice questions in the form:

```
[choice: question_name]
* opt1: Option one
* opt2: Option two
```
