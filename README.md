# Smartdown

Smartdown is an [external
DSL](http://www.martinfowler.com/bliki/DomainSpecificLanguage.html) for
representing a series of questions and logical rules which determine the order
in which the questions are asked, according to user input.

The language is designed to look like
[Markdown](http://daringfireball.net/projects/markdown/), with some extensions
to allow expression of logical rules, questions and conditional blocks of
text.

## Overview

A single smartdown flow has a set of questions, logical rules and outcomes.

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
   |-- check-uk-visa.txt
   |-- planning_to_leave_airport.txt
   |-- purpose_of_visit.txt
   |-- staying_for_how_long.txt
   `-- what_passport_do_you_have.txt
```

## General file syntax

Each file follows the same approximate file syntax:

```
flow = front-matter question-definition rules
```

## Cover sheet

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

## Questions

A question definition may have front-matter metadata

## Conditional blocks

## Processing model

