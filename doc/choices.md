# Choices

"Choice" questions (aka. radio buttons)

A choice question allows the user to select a single option from a list of choices.

**NB:** You must define an outcome to render a 'Next Step button'

### Smartdown

```
# Will you pass through UK Border Control?

You might pass through UK Border Control even if you
don't leave the airport - eg your bags aren't checked
through and you need to collect them before
transferring to your outbound flight.

[choice: uk_border_control]
* yes: Yes
* no: No

* uk_border_control is 'yes' => outcome_border_yes
```

### HTML

```html
<form accept-charset="UTF-8" action="/animal-example-multiple/y" method="get">
  <div style="margin:0;padding:0;display:inline">
    <input name="utf8" type="hidden" value="✓">
  </div>
  <div class="current-question" id="current-question">
    <div class="question">
      <h2>Will you pass through UK Border Control?</h2>
      <div class="question-body">
        <p>You might pass through UK Border Control even if you don’t leave the airport -
          eg your bags aren’t checked through and you need to collect them before transferring to your outbound flight.</p>
          <div class="">
            <ul class="options">
              <li>
                <label for="response_0" class="selectable">
                  <input id="response_0" name="response" type="radio" value="yes">
                  Yes
                </label>
              </li>
              <li>
                <label for="response_1" class="selectable">
                  <input id="response_1" name="response" type="radio" value="no">
                  No
                </label>
              </li>
            </ul>
          </div>
        </div>
    </div>

    <div class="next-question">
      <input type="hidden" name="next" value="1"><button type="submit" class="medium button">Next step</button>
    </div>
  </div>
</form>
```

### Outcome

![](http://cl.ly/image/053d1h2u012V/Screen%20Shot%202014-12-04%20at%2012.30.48.png)
