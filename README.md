# Smartdown [![Build Status](https://travis-ci.org/alphagov/smartdown.svg?branch=master)](https://travis-ci.org/alphagov/smartdown)

Smartdown is an [external
DSL](http://www.martinfowler.com/bliki/DomainSpecificLanguage.html) for
representing a series of questions and logical rules which determine the order
in which the questions are asked, according to user input.

The language is designed to look like
[Markdown](http://daringfireball.net/projects/markdown/), with some extensions
to allow expression of logical rules, questions and conditional blocks of
text.

It's a work-in-progress so some of the features described in this readme haven't been implemented yet. These are indicated with (tbd).

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
   |   |-- 1.test
   |   |-- 2.test
   |   `-- 3.test
   |-- questions
   |   |-- planning_to_leave_airport.txt
   |   |-- purpose_of_visit.txt
   |   |-- staying_for_how_long.txt
   |   |-- what_passport_do_you_have.txt
   `-- check-uk-visa.txt
```

## General node file syntax

Each file has three parts: front-matter, a model definition, rules/logic. Only the model definition is required.

* **front-matter** defines metadata in the form `property: value`
* the **model definition** is a markdown-like block which defines a flow, question or outcome.
* **rules/logic** defines 'next node' transition rules or other logic/predicate definitions

## Cover sheet node

The cover sheet starts the flow off, its filename should match the flow name, e.g. 'check-uk-visa.txt'.

It has initial 'front matter' which defines metadata for the flow, including
the first question. It then defines the copy for the cover sheet in markdown
format. The h1 title is compulsory and used as the title for the smart answer.

```
meta_description: You may need a visa to come to the UK to visit, study or work.
satisfies_need: 100982
start_with: what_passport_do_you_have

# Check if you need a UK visa

You may need a visa to come to the UK to visit, study or work.
```

## Question nodes

A question model definition has optional front matter, followed by a title and
question type.

The next sections define the various question types

### Multiple choice

```markdown
# Will you pass through UK Border Control?

You might pass through UK Border Control even if you don't leave the airport -
eg your bags aren't checked through and you need to collect them before transferring
to your outbound flight.

* yes: Yes
* no: No
```

### Country (tbd)

```markdown
# What passport do you have?

[country]
```

Presents a drop-down list of countries from the built-in list.

Use front matter to exclude/include countries

```
exclude_countries: country1, country2
include_countries: {country3: "Country 3", country4: "Country 4"}

[country]
```

### Date (tbd)

```markdown
# What is the baby’s due date?

[d/m/y: -1...+1]
```

Asks for a specific date in the given range. Ranges can be expressed as a relative number of years or absolute dates in YYYY-MM-DD format.

### Value (tbd)

```markdown
[value]
```

Asks for an arbitrary text input.

### Money (tbd)

```markdown
[money]
```

Asks for a numerical input which can have decimals and optional thousand-separating commas.

### Salary (tbd)

```markdown
[salary]
```

Asks for salary which can be expressed as either a weekly or monthly money amount. The user chooses between weekly/monthly

### Checkbox (tbd)

```markdown
# Will you pass through UK Border Control?

* [ ] yes: Yes
* [ ] no: No
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

* predicate1
  * predicate2 => outcome1
  * predicate3 => outcome2
```

defines nested rules.

## Predicates

```
variable_name is 'string'
variable_name in {this that the-other}
```

## Conditional blocks in outcomes (tbd)

## Processing model

Each response to a question is assigned to a variable which corresponds to the question name (as determined by the filename).

## Named predicates (tbd)

Named predicates

## Plugin API (tbd)

A plugin API will be provided to allow more complex calculations to be defined
in an external ruby class.

## Software design

The software design can be seen in this diagram:

![Software design](https://raw.githubusercontent.com/alphagov/smartdown/master/doc/design.png)

