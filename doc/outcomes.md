# Outcomes

**STUB**

Outcomes are the final pages of a user journey. They can include follow on information as `[next_steps]` and external links.  Overall they should give the user a clear indication of their outcome.

Example outcome for a hypothetical 'Buying A Tiger' flow:

### Smartdown

```
# Tigers are fine

You haven't trained with tigers, but you'll be alright, probably.

[next_steps]
### You bought a tiger? Seriously?

[Your nearest hospital](https://gov.uk/hospital)
[end_next_steps]

```

### HTML

```html

<div class="article-container outcome">
  <article class="outcome group">
    <div class="inner group">

      <div class="result-info">
        <div class="summary">
          <h2 class="result-title">Tigers are fine</h2>
        </div>
        <p>You haven’t trained with tigers, but you’ll be alright, probably.</p>
      </div>

      <div class="related next-steps">
        <div class="inner group">
          <h2>Next steps</h2>
          <h3 id="you-bought-a-tiger-seriously">You bought a tiger? Seriously?</h3>
          <p>
            <a rel="external" href="https://gov.uk/hospital">Your nearest hospital</a>
          </p>
        </div>
      </div>

    </div>
  </article>
</div>

<div class="previous-answers ">
  <div class="done-questions">
    <article>
      <thead>
        <tr>
          <th class="previous-answers-title">
            Previous answers
          </th>
          <th class="link-right restart" colspan="2">
            <a href="/animal-example-multiple">Start again</a>
          </th>
        </tr>
      </thead>
      <tbody>
        <tr class="section">
          <td class="section-title">
            What type of feline do you have?
          </td>
          <td>
          </td>
          <td class="link-right">
            <a href="/animal-example-multiple/y/?previous_response=tiger">
              Change<span class="visuallyhidden"> answer to "What type of feline do you have?"</span>
            </a>
          </td>
        </tr>
        <tr>
          <td class="previous-question-title">Check the serial number by the tail.</td>
          <td class="previous-question-body">Tiger</td>
        </tr>

        <tr class="section">
          <td class="section-title">
            How good is your big cat training?
          </td>
          <td></td>
          <td class="link-right">
            <a href="/animal-example-multiple/y/tiger?previous_response_1=no&amp;previous_response_2=no">
              Change<span class="visuallyhidden"> answer to "How good is your big cat training?"</span>
            </a>
          </td>
        </tr>

        <tr>
          <td class="previous-question-title">Are you trained for lions?</td>
          <td class="previous-question-body">No</td>
        </tr>
        <tr>
          <td class="previous-question-title">Are you trained for tigers?</td>
          <td class="previous-question-body">No</td>
        </tr>

      </tbody>
    </article>
  </div>
</div>
```

### Outcome

![](https://s3.amazonaws.com/f.cl.ly/items/1N3p1N0d3p451a0Z192W/Screen%20Shot%202014-12-04%20at%2014.40.31.png)
