# Questions

Question pages can contain single or multiple choices, which can lead to outcomes or further questions in a flow.

*Smartdown currently allows multiple questions to be defined per page or 'node', but this
feature has only [recently been introduced](CHANGELOG.md#010) and may still change.*

Example of `question_1_multiple_choice.txt`:

### Smartdown

```
# What type of feline do you have?

# Check the serial number by the tail.

Text before the options.

[choice: question_1]
* lion: Lion
* tiger: Tiger
* cat: Cat

This is an optional note after the question.

* question_1 in {lion tiger} => question_2
* otherwise => outcome_safe_pet
```


### HTML

```html
<h2 class="page-title">What type of feline do you have?</h2>
<div class="step current" data-step="">

  <form accept-charset="UTF-8" action="/animal-example-multiple/y" method="get">
    <div style="margin:0;padding:0;display:inline">
      <input name="utf8" type="hidden" value="✓">
    </div>
    <div class="current-question" id="current-question">
      <div class="question">
        <h2>Check the serial number by the tail.</h2>

        <div class="question-body">
          <p>Text before the options.</p>
            <div class="">
              <ul class="options">
                <li>
                    <label for="response_0" class="selectable">
                      <input id="response_0" name="response" type="radio" value="lion">
                      Lion
                    </label>
                </li>
                <li>
                    <label for="response_1" class="selectable">
                      <input id="response_1" name="response" type="radio" value="tiger">
                      Tiger
                    </label>
                </li>
                <li>
                    <label for="response_2" class="selectable">
                      <input id="response_2" name="response" type="radio" value="cat">
                      Cat
                    </label>
                </li>
            </ul>
            <p>This is an optional note after question.</p>
          </div>
        </div>
      </div>

      <div class="next-question">
        <input type="hidden" name="next" value="1">
        <button type="submit" class="medium button">Next step</button>
      </div>
    </div>
  </form>
</div>
```

### Outcome

![](http://cl.ly/image/0X090G1i3F1k/Screen%20Shot%202014-12-04%20at%2011.31.32.png)
