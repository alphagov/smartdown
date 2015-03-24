# Glossary
## General node file syntax

Each file has three parts: front-matter, a model definition, rules/logic. Only the model definition is required.

* **front-matter** defines metadata in the form `property: value`. Note: this
  does not support full YAML syntax.
* the **model definition* is a markdown-like block which defines a flow,
  question or outcome.
* **rules/logic** defines 'next node' transition rules or other
  logic/predicate definitions

### Date

```markdown
## What is the baby’s due date?

[date: baby_due_date]
```

To control the range of years selected you can supply 2 optional arguments to date questions: `from` and `to`.
These can take the form of absolute values, eg.

```markdown
[date: baby_due_date, from: 2010, to: 2015]
```

Or relative values (from the current year), eg.

```markdown
[date: baby_due_date, from: -4, to: 1]
```

The default values for `from` and `to` are relative years: `-1` and `3` respectively.

### Text

```markdown
[text: text_value]
```

Asks for an arbitrary text input.

### Salary

```markdown
[salary: salary_value]
```

### Money
```markdown
[money: money_value]
```

## Aliases

An alias lets you referrer to any question identifier by its question intentifer or its alias.

```markdown
## Are you Clark Kent?

[choice: clark_kent, alias: superman]
* yes: Yes
* no: No
```

## Next steps

Markdown to be displayed as part of an outcome to direct the users to other information of potential interest to them.

```markdown
[next_steps]
* Any kind of markdown
[A link](https://gov.uk/somewhere)
[end_next_steps]
```

## Next node rules

Logical rules for transitioning to the next node are defined in 'Next node' section. This is declared using a markdown h1 'Next node'.

There are two constructs for defining rules:

```
# Next node

* predicate => outcome
```

defines a conditional transition

```
# Next node

* reddish?
  * yellowish? => orange
  * blueish? => purple
```

defines nested rules.

In the example above the node `orange` would be selected if both `reddish?` and `yellowish?` were true.

## Predicates

As well as 'named' predicates which might be defined by a plugin or other
mechanism, there's also a basic expression language for predicates.

The currently supported operations are:

```
variable_name is 'string'
variable_name in {this that the-other}
```

### Date comparison predicates (tbd)

```
date_variable_name >= '14/07/2014'
date_variable_name < '14/07/2014'
```

### Logical connectives

There are operators that can be used to combine predicates, or invert
their value. Namely NOT, OR and AND.

eg.

```
variable_name is 'string' OR NOT variable name is 'date'
```

`OR` connectives join a sequence of predicates and will return true if
any of them evaluate to true, otherwise false.

`AND` connectives join a sequence of predicates and will return true if
all of them evaluate to true, otherwise false.

`NOT` connectives will invert the return value of a predicate. ie turn
true to false and vice versa. They have high precedence so bind to a single
predicate in chain eg in:

```
NOT variable_name is 'lovely name' OR variable_name is 'special name'
```

The implied parentheses around the experssion are:

```
(NOT variable_name is 'lovely name') OR variable_name is 'special name'
```

For more information on Logical Connectives see:

http://en.wikipedia.org/wiki/Logical_connective


## Processing model

Each response to a question is assigned to a variable which corresponds to the
question name (as determined by the filename).

## Conditional blocks in outcomes

The syntax is:

```markdown

$IF pred?

Text if true

more text if you like

$ENDIF
```

You can also have an else clause:

```markdown

$IF pred?

Text if true

$ELSE

Text if false

$ENDIF
```

It's required to have a blank line between each if statement and the next paragraph of text, in other words this would be **invalid**:

```markdown

$IF pred?
Text if true
$ENDIF
```

Similarly, it is also possible to specify an elseif clause. These can be
chained together indefinitely. It is also possible to keep an else
clause at the end like so:

```markdown
$IF pred1?

Text if pred1 true

$ELSEIF pred2?

Text if pred1 false and pred2 true

$ELSEIF pred3?

Text if pred1 and pred2 false, and pred3 true

$ELSE

Text if pred1, pred2, pred3 are false

$ENDIF
```

It is also possible to nest if statements: like so.

```markdown

$IF pred1?

$IF pred2?

Text if both true

$ENDIF

$ENDIF
```

## Interpolation

It's possible to interpolate values from calculations, responses to questions, plugins etc.

Interpolations are currently supported into headings and paragraphs using the following syntax:

```markdown

# State pension age calculation for %{name}

Your state pension age is %{state_pension_age}.
```

## Snippets

Snippets work like partials, to re-use common text. They can be block or inline,
can be called recursivelty and can contain interpolation and conditional logic

They're called like so:

```
## My header

Markdown copy..

{{snippet: my_snippet}}

More copy...
```

Where `snippet_name` is in a `snippets/` directory in the flow root with a `.txt`
extension, eg `my-flow-name/snippets/my_snippet.txt`.

The contents of `my_snippet` will be inserted into the outcome/question.

###Snippet Organisation

You can organise related snippets into a sub-directory of arbitrary depth

For example:

```
## My header

Markdown copy..

{{snippet: my_sub_directory/my_snippet}}

More copy...
```
Where `snippet_name` is in a `snippets/` directory in the flow root with a `.txt` extension, eg `my-flow-name/snippets/my_sub_directory/my_snippet.txt`.

## Markers

Markers are used to mark areas in a question/outcome for testing and are exposed as an array on the Api::Node object

For example

```
$IF i_am_a_predicate

{{marker: i_am_only_exposed_if_predicate_evaluates_to_true}}

$ELSE

{{marker: i_am_only_exposed_if_predicate_evaluates_to_false}}

$ENDIF

{{marker: i_am_always_exposed}}

```

##Code terminology

####Answers vs responses

The words 'answers' and 'responses' are used for various variable names and method names throughout the gem.
Both are used to describe an answer to a question, but indicate two different formats:
* ```response``` is used for raw string inputs
* ```answer``` is used for Model::Answer objects

## Software design

The initial plan for software design can be seen in this diagram:

![Software design](https://raw.githubusercontent.com/alphagov/smartdown/master/doc/design.png)
