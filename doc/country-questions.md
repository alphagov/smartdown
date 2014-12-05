# Country Questions

A country question allows the user to select a country from a drop-down list.


### Smartdown

```markdown
# Where did you buy your cat?

[country: cat_purchase_cat, countries: all_countries]

* cat_purchase_cat is 'GB' => some_outcome_related_to_cats_from_great_britain
```

### HTML

```html
<form accept-charset="UTF-8" action="/animal-example-multiple/y" method="get">
  <div style="margin:0;padding:0;display:inline">
    <input name="utf8" type="hidden" value="✓">
  </div>
  <div class="current-question" id="current-question">
    <div class="question">
      <h2>Where did you buy your cat?</h2>
      <div class="question-body">
        <div class="">
          <select id="response" name="response">
            <option value="GB">Great Britain</option>
            <option value="JP">Japan</option>
            <option value="SWE">Sweden</option>
            <option value="IRL">Ireland</option>
          </select>
        </div>
      </div>
    </div>

    <div class="next-question">
      <input type="hidden" name="next" value="1">
      <button type="submit" class="medium button">Next step</button>
    </div>
  </div>
</form>
```

### Outcome

![](http://cl.ly/image/3L1t3I1f1N2t/Screen%20Shot%202014-12-04%20at%2012.01.01.png)


**NB:** `all_countries` in this case is the name of a data-plugin method from smart-answers that will return a hash of country slugs/names. See [this selection for implementation details](https://github.com/alphagov/smart-answers/blob/master/lib/smart_answer/question/country_select.rb)
