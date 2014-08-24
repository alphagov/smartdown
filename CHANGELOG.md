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
