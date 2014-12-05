# Scenarios

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
