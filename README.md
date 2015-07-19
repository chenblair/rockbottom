# rockbottom

Overview
If users are having a bad day, they can submit their story and rate it on how bad they thought their day was. Then, Rock Bottom will try and find another submitted story that’s even worse than the user’s and display it to the user, hopefully making the user feel a bit better.The user (user A) can then accept the story as worse than their own, or swipe to say that that story was not as bad. Then, the person with the not as bad story will be notified that another user has had a worse day and will have the option of reading it.
User Flow
After having a shitty day, the user will open Rock Bottom, where he will be taken to a landing screen that prompts for a story and rating to submit to the Rock Bottom database. Then, based on that rating, Rock Bottom will try to find another story that’s either equally bad or ideally worse that the user’s story and show it to the user. If the user feels that the given story is indeed worse than his own, he can either quit the app or keep scrolling through bad stories by swiping left. Otherwise, he can swipe to the right to signify that the given story isn’t as bad his own, and he will again be taken to a worse story. However, this time, the person whose story was not as bad will be notified that someone else has a worse story than his and will be given the option to read it.
Login Screen
Input a story
Display other’s story with swiping options
Technical
External services
Models
story: id (int), userid, timestamp, body, rating
Views
Schedule?
