## Welcome to Vinted!

We, engineers at Vinted, are striving to provide the best solutions for business-side problems which scale, last and require minimal maintenance. Our code is clean, well-tested and flexible and we are not afraid to touch legacy code, re-evaluate it and rework it if necessary. We hope that our new colleagues appreciate the same values and stick to best-practices.

With that in mind, we have prepared 3 tasks for you.

In the provided repository you will find an open PR (due to technical limitations of Github Classrooms, you should open this PR - from the branch implementation to the main branch - and then review this PR), which is a working Vinted app prototype code left by the previously working developer.

It has two basic screens - an item feed screen where the user is able to scroll and see the items. Clicking one of the items,the user is taken to another screen with item details (with future capability of buying it).

Let’s imagine that you have arrived at the Vinted office for the first day of work.

Since you are a new developer working on these screens, your first task is to understand the code. And as the previous developer did not do a hand-over of the code, you should re-evaluate the existing code.

1. *Please write a PR review of new classes (and anything general you notice with the rest of the code), like you would do for a regular PR. As mentioned above, open a new PR from implementation to the main branch.*

Just before you jump into code you are approached by your new and eager to deliver Product Manager who asks you to implement your first feature - the search of items

2. *The user should have an option to input the search phrase by which the provided items in the list are filtered. The most feasible approach would be that results are filtered while typing the search phrase. Open this as a separate PR to the implementation branch.*

It is mid-summer, holiday time, and the designer is hiking in some far away country, the PM of your team trusts your superior design skills and gives you freedom to implement it how you see fit (we know you could make it look amazing, but please don’t over-design this though).

You might want to get a new API to provide the filtered values, but your backender loves to reuse the existing APIs - she whispers that you can just add a new key-value pair to the only one API you use (items). The key is ”search_text” and the value - the string you want to use for filtering.
 
Just before you get your third cup of coffee, a stressed analytics guy comes over with some bad news - one of the most vital and precious analytics events (all the events must be tracked) - tracking the shown items in the feed - is not implemented yet!

3. *Track each item the user has seen while scrolling the item feed - just save the events (item id and timestamp of the event recorded) into a file. Whenever the backend endpoint accepting these events is ready we will send all the accumulated events there. Open this as a separate PR to the implementation branch.*

After he leaves (chanting “no data - no life” to himself as he walks away), you look around - no one else is coming with some unexpected and/or urgent task (disclaimer - it is highly unlikely for the provided situation to be this chaotic in reality. But chaos is a ladder...). You sit down finally having a chance to write some code.