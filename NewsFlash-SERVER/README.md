# NewsFlash Backend Server

Backend for the NewsFlash app, written in Python and hosted on Heroku. Built with Flask and a whole lot of other stuff.

_Part of a CS198-001 Project by [@chromadrive](github.com/chromadrive) [@zeyanaAM](github.com/zeyanaam) and [@aaronhoby](github.com/aaronhoby)_

## Super Duper Important Info!

The code included in this folder is incomplete (as I do not have access to one of the computers I used to write part of the API at the time of submission) and may not properly compile. Please refer to our distribution version on our dedicated server repo for reference and more information: [https://github.com/chromadrive/NewsFlash-backend](https://github.com/chromadrive/NewsFlash-backend)

Also, this API is hosted live at [http://newsapp-backend2.herokuapp.com/](http://newsapp-backend2.herokuapp.com/) ! Works better than building this source and running it yourself :)

## Usage

- `/feed/` returns the JSON representation of the frontpage feed.
- `/search/[TYPE]/[QUERY]` returns the JSON representation of a searched feed. `[TYPE]` can be either Keyword, Location, or Category, where words are seperated by either `_` or `%20`
 - See notes on valid categories below
- `/event/[URI]` takes in an event URI of the form `lang-####` and returns a JSON representation of the article.

## Format
Feeds (main feed, search):

- `events`
  -  For each event:
  -  `URI`
  -  `category`
  -  `date`
  -  `image`
  -  `location`
  -  `socialScore`
  -  `title`

Events:

- `event`
  - `title`
  - `URI`
  - `articles` (a list of strings)
  - `category`
  - `date`
  - `image`
  - `keywords` (a list of strings)
  - `location`
  - `socialScore`
  - `summary`

- If a query can't be resolved or otherwise errors, then the API will return only an `error` entry stating the error


## Cache

For testing purposes, we've cached a version of the backend with events around 11/28-12/2. It can be accessed by putting `/cache/` in front of every call (for example, accessing an event would be `/cache/event/[URI]`. 

Some searches are also cached:

- Keyword: `Trump`, `iPhone`, `Star Wars`, `Black Friday`
- Location: `United States`, `United Kingdom`, `Saudi Arabia`, `China`
- Category: `Society`, `Science`, `Arts`

Remember to replace spaces with `_` or `%20`!

## Installation and Operation
0) Make sure you have a working Python 3.5 or higher installation, this won't work on anything lower.

1) Install NLTK and download the `stopwords` corpus. There are plenty of instructions on how to do this online.

2) Install all the stuff in `requirements.txt` (preferably in a virtualenv). You can do this with `pip3 install -r requirements.txt`

3) Open `event.py`, and at the top, insert your EventRegistry API key as a string into the `apiKey = ` field.

4) Run `web.py` (preferably Docker, but `python3 web.py` also works), and navigate to `http://0.0.0.0:5000/` on your web browser.