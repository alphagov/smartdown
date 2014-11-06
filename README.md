# Smartdown [![Build Status](https://travis-ci.org/alphagov/smartdown.svg?branch=master)](https://travis-ci.org/alphagov/smartdown)

Smartdown is an [external
DSL](http://www.martinfowler.com/bliki/DomainSpecificLanguage.html) for
representing a series of questions and logical rules which determine the order
in which the questions are asked, according to user input.

The language is designed to look like
[Markdown](http://daringfireball.net/projects/markdown/), with some extensions
to allow expression of logical rules, questions and conditional blocks of
text.

## Overview

A single smartdown flow has a cover sheet, a set of questions, a set of
outcomes and a set of test scenarios. Cover sheets, questions and outcomes are
all types of node. A node represents a single user interaction (normally a web
page, but in other media may be presented differently).

Each question and outcome is held in a separate file. The name of the files
are used to identify each question. Here's an example of the check-uk-visa
flow:

```
-- check-uk-visa
   |-- outcomes
   |   |-- general_y.txt
   |   |-- joining_family_m.txt
   |   |-- joining_family_y.txt
   |   |-- marriage.txt
   |   |-- medical_n.txt
   |   |-- medical_y.txt
   |   `-- ...
   |-- scenarios
   |   |-- 1.txt
   |   |-- 2.txt
   |   `-- 3.txt
   |-- questions
   |   |-- planning_to_leave_airport.txt
   |   |-- purpose_of_visit.txt
   |   |-- staying_for_how_long.txt
   |   |-- what_passport_do_you_have.txt
   `-- check-uk-visa.txt
```

## General node file syntax

Each file has three parts: front-matter, a model definition, rules/logic. Only the model definition is required.

* **front-matter** defines metadata in the form `property: value`. Note: this
  does not support full YAML syntax.
* the **model definition* is a markdown-like block which defines a flow,
  question or outcome.
* **rules/logic** defines 'next node' transition rules or other
  logic/predicate definitions

## Cover sheet node

The cover sheet starts the flow off, its filename should match the flow name,
e.g. 'check-uk-visa.txt'.

It has initial 'front matter' which defines metadata for the flow. It then
defines the copy for the cover sheet in markdown format. The h1 title is
compulsory and used as the title for the smart answer.

A start button determines which question node is presented first.

```
meta_description: You may need a visa to come to the UK to visit, study or work.
satisfies_need: 100982

# Check if you need a UK visa

You may need a visa to come to the UK to visit, study or work.

[start_button: what_passport_do_you_have]
```

## Question nodes

Question nodes follow the same standard structure outlined above.

Smartdown currently allows multiple questions to be defined per node, but this
feature has only [recently been introduced](CHANGELOG.md#010) and may still change.

The next sections define the various question types available.

Note that at present only the 'choice' question type has been implemented.
Unimplemented question types are marked with **(tbd)** in the heading. For
these question types, consider this documentation to be a proposal of how they
might work.

### "Choice" questions (aka. radio buttons)

A choice question allows the user to select a single option from a list of choices.

```markdown
## Will you pass through UK Border Control?

You might pass through UK Border Control even if you don't leave the airport -
eg your bags aren't checked through and you need to collect them before transferring
to your outbound flight.

[choice: uk_border_control]
* yes: Yes
* no: No
```

### Date

```markdown
## What is the baby’s due date?

[date: baby_due_date]
```

### Text

```markdown
[text: text_value]
```

Asks for an arbitrary text input.

### Salary

```markdown
[salary: salary_value]
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

## Scenarios

Scenarios are meant to be run as test to check that a Smartdown flow behaves
in a certain way given some input data.

###Scenario files

There can be as many scenario files as one wishes, with no restriction on name. Each
scenario file should contain scenarios written as documented below.

###Format

Each scenario is made of:
* a description (optional)
* list of questions pages (each question page starts with a -), inside which questions to answers are defined
* name of the outcome

```
# Description
- name_of_q1_p1: answer_to_q1_p1
- name_of_q1_p2: answer_to_q1_p2
  name_of_q2_p2: answer_to_q2_p2
outcome_the_result

# Descriptions
# can have several lines
- name_of_q1_p1: answer_to_q1_p1_2
- name_of_q1_p3: answer_to_q1_p3
  name_of_q2_p3: answer_to_q2_p3
outcome_the_other_result
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

