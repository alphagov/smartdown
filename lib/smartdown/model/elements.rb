module Smartdown
  module Model
=begin
We had to create this Struct for storing multiple Smartdown::Model elements due
to the syntax used in parsing. 

In the parsing rule below:
```
rule(:markdown_elements) {
  markdown_element.repeat(1, 1) >> 
  (newline.repeat(1).as(:blank_line) >> markdown_element.as(:element)).repeat
}
```

the `(newline.repeat(1).as(:blank_line) >> markdown_element.as(:element)).repeat` snippet creates
a hash with two key/value pairs to transform.

In order to avoid too much verbosity in the NodeTransform, using the markup "element" instead
of relying on the naming given by the markdown element parsing itself means we can catch all those cases
in one generic transform rule:

``` 
rule(blank_line: simple(:blank_line), element: subtree(:element)) {
  Smartdown::Model::Elements.new(
    [
      Smartdown::Model::Element::MarkdownLine.new(blank_line.to_s),
      element,
    ]
  )
}
```

The other alternative would have been to have to add a new rule for every specific kind of markdown element. 
This `Elements` Struct was created to avoid that much verbosity and brittleness in the transform (we would 
have needed to add another `rule (blank_line...., xxxxx....)` every time we add a new type of markdown element)

Last but not least, we couldn't just cast newlines as just any markdown element:

```
rule(:markdown_elements) {
  markdown_element.repeat(1, 1) >> 
  (markdown_element).repeat
}
```
was not an option since we needed to differentiate between newlines that so happened to be inside broader blocks like
frontmatter, rules or conditionals, and newlines that separated plain markdown text...

=end 
    Elements = Struct.new(:elements) 
  end
end
