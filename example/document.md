---
title: "PANDOC example"
author: Ynn
date: 2018-03-19
subject: "Markdown"
tags: [Markdown, Example]
subtitle: "This is a short example"
titlepage: true
titlepage-color: ffffff
titlepage-text-color: 0065bd
titlepage-rule-color: 0065bd
titlepage-rule-height: 15
---

![](images/LaTeX_logo.svg)

# Pandoc with citeproc-hs

-   [@nonexistent]

-   @nonexistent

-   @item1 says blah.

-   @item1 [p. 30] says blah.

-   @item1 [p. 30, with suffix] says blah.

-   @item1 [-@item2 p. 30; see also @item3] says blah.

-   In a note.[^1]

-   A citation group [see @item1 p. 34-35; also @item3 chap. 3].

-   Another one [see @item1 p. 34-35].

-   And another one in a note.[^2]

-   Citation with a suffix and locator [@item1 pp. 33, 35-37, and nowhere else].

-   Citation with suffix only [@item1 and nowhere else].

-   Now some modifiers.[^3]

-   With some markup [*see* @item1 p. **32**].

# References

[^1]: A citation without locators [@item3].

[^2]: Some citations [see @item2 chap. 3; @item3; @item1].

[^3]: Like a citation without author: [-@item1], and now Doe with a locator [-@item2 p. 44].
