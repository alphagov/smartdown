# Start Pages

The Start Page 'node' kicks off the user journey. It's the first page a user will see and its filename should match the journey name, e.g. 'apply-for-a-visa.txt'.

On a Start Page you can define additional metadata like a *description*, *published status* and a *link to an existing user need in Maslow*.

It then defines the copy for the start page in markdown format.
The h1 title is compulsory and used as the title throughout the user journey.

A start button then determines which question node is presented first.

Full example:

### Smartdown

```markdown
meta_description: You may need a visa to come to the UK to visit, study or work.
satisfies_need: 100982
status: published

# Check if you need a UK visa

You may need a visa to come to the UK to visit, study or work.

[start: what_passport_do_you_have]
```

### HTML

```html
<meta name="description" content="You may need a visa to come to the UK to visit, study or work.">

...

<header class="page-header group"><div>
    <h1>
      Check if you need a UK visa
    </h1>
  </div>
</header><div class="article-container group">
  <article role="article" class="group"><div class="inner">
      <div class="intro">
          <p>You may need a visa to come to the UK to visit, study or work.</p>

        <p class="get-started">
          <a rel="nofollow" href="/animal-example-simple/y" class="big button">Start now</a>
        </p>
      </div>

    </div>
  </article>
```

### Result

![](http://cl.ly/image/2F2M1z3i2j1d/Screen%20Shot%202014-12-04%20at%2010.46.32.png)
