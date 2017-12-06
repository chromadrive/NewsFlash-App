import traceback
import requests
import urllib.request, urllib.parse, urllib.error
import wikipedia
import json
import summary
from eventregistry import *

# Event Registry API Keys

# Insert your own here!
apiKey = ""

# Initialize Event Registry
er = EventRegistry(apiKey = apiKey)

# Get FEED json
def get_feed(search=None, location=None, category=None, sortBy='relevance', numEvents=20):
	"""
	Inputs: search (search query as a single string), 
			location (string),
			category (string, must be a correct category (see validate_category()))
			sortBy (string, must be one of either 'date', 'score', or 'relevance'. Defaults to relevance.)
			numEvents (integer, how many events you want to get. Default 20)
	"""
	# BUILD REQUEST URL


	url = "http://eventregistry.org/json/event"
	# Validate search/location/query first to make sure nothing is wrong
	search = validate_search(search)
	location = validate_location(location)
	category = validate_category(category)

	url += '?query={"$query":{"$and":['

	# Check if there is anything to search for (keyword, location, or category) 
	if search or location or category:
		if search:
			url += '{"keyword":{"$and":[' + search + ']}},'
		if location:
			url += '{"locationUri":{"$or":["' + location + '"]}},'
		if category:
			url += '{"categoryUri":{"$or":["' + category + '"]}},'
	# Specify english language (multi-language support soon?)
	url += '{"lang":"eng"}]}}'

	# Specify that we want to get events
	url += "&action=getEvents&resultType=events"
	
	# Specify number of events and images
	url += "&eventsCount=" + str(numEvents) + \
	"&eventsEventImageCount=1" + \
	"&eventsStoryImageCount=1"
	
	# Sort by whatever was specified
	if sortBy == 'date':
		url += "&eventsSortBy=date"
	elif sortBy == 'score':
		url += "&eventsSortBy=socialScore"
	else:
		url += "&eventsSortBy=rel"

	# Some other misc settings
	url += "&eventsIncludeEventArticleCounts=false" + \
	"&eventsIncludeEventSocialScore=true" + \
	"&eventsIncludeSourceTitle=false"
	
	# Specify API key
	url += "&apiKey=" + str(apiKey)
	# url += "&callback=JSON_CALLBACK"


	# GET JSON FROM URL

	data = json.loads(urllib.request.urlopen(url).read().decode())
	# Check if there are actually events that exist
	if 'events' not in data.keys():
		# Do some error handling (JSON with error)
		return {'error': "No results match the search conditions."}
	else:
		event_list = []
		for event in data['events']['results']:
			event_dict = {}
			event_dict['URI'] = event['uri']
			event_dict['date'] = event['eventDate']
			try:
				event_dict['image'] = event['images'][0]
			except:
				event_dict['image'] = 'https://dummyimage.com/800x500/808080/808080'
			event_dict['socialScore'] = event['socialScore']
			event_dict['title'] = event['title']['eng']

			try:
				event_dict['location'] = event['location']['country']['label']['eng']
			except:
				event_dict['location'] = 'N/A'
			try:
				event_dict['category'] = event['categories'][0]['label'].split('/')[1]
			except:
				event_dict['category'] = 'N/A'

			event_list.append(dict(event_dict))
		return {"events" : event_list}


def get_event(uri):
	"""
	Input: uri (string representing an Event URI)
	"""
	q = QueryEvent(uri, requestedResult = RequestEventInfo(returnInfo = ReturnInfo(
		articleInfo = ArticleInfoFlags(concepts = True),
        eventInfo = EventInfoFlags(title = True, concepts = True, location = True, date = True, stories = False, socialScore = True, details = True, imageCount = 1))))
	data = er.execQuery(q)
	# Check if event errors
	if 'error' in data[uri].keys():
		return {'error': uri + " is not a valid event URI"}
	if 'newEventUri' in data[uri].keys():
		return {'error': 'Data for event ' + uri + ' has been removed from the database'}
	# Else, build response
	else:
		event_dict = {}
		event_dict['URI'] = data[uri]['info']['uri']
		event_dict['category'] = data[uri]['info']['categories'][0]['label'].split('/')[1]
		event_dict['date'] = data[uri]['info']['eventDate']
		event_dict['image'] = data[uri]['info']['images'][0]
		event_dict['keywords'] = [concept['label']['eng'] for concept in data[uri]['info']['concepts'][:5]]
		event_dict['socialScore'] = data[uri]['info']['socialScore']
		event_dict['title'] = data[uri]['info']['title']['eng']
		try:
			event_dict['location'] = data[uri]['info']['location']['country']['label']['eng']
		except:
			event_dict['location'] = "N/A"
		event_dict['articles'] = fetch_article_urls(er, uri)
		try:
			event_dict['summary'] = summary.summarize(event_dict['articles'][0])['summary']
		except:
			try:
				event_dict['summary'] = summary.summarize(event_dict['articles'][1])['summary']
			except:
				try:
					event_dict['summary'] = summary.summarize(event_dict['articles'][2])['summary']
				except:
					event_dict['summary'] = 'Summarization error'
		return {'event': event_dict}

# UTILITIES

# Validate search query (break up words, capitalize, add commas and quotes)
def validate_search(search):
	if search:
		search = search.replace("_", ' ')
		search = search.replace("+", ' ')
		search = ['"' + word.upper() + '"' for word in search.split()]
		return ','.join(map(str, search))

# Validate location (convert to wikipedia URL)
# don't ask me why we need a wikipedia URL, that's what EventRegistry wants
def validate_location(location):
	if location:
		try:
			# Use Wikipedia API to return the closest page
			wiki_url = str(wikipedia.page(location).url)
			if 'https:' in wiki_url:
				wiki_url = wiki_url.replace('https:', 'http:')
			return wiki_url
		except:
			print ('Location error!', location, "is not a valid location!")
			return None

# Validate category to be one of the ones we have implemented
def validate_category(category):
	if category:
		valid_categories = ['arts', 'business', 'computers', 'games', 'health', 'home', 'recreation',
						'reference', 'science', 'shopping', 'society', 'sports']
		if category.lower() in valid_categories:
			return 'dmoz/' + category.lower().title()
		else:
			print('Category error!', category, "is not a valid category!")
	return None

# Helper function to fetch article URLs from the Python API (RESTful wouldn't work)
def fetch_article_urls(er, uri):
	q = QueryEvent(uri)
	q.setRequestedResult(RequestEventArticleUris(lang = 'eng'))
	eventRes = er.execQuery(q)[uri]
	eventRes = eventRes['articleUris']['results']
	article_url_list = []
	for article_uri in eventRes[:5]:
		q = QueryArticle(article_uri)
		res = er.execQuery(q)
		try:
			article_url_list.append(res[article_uri]['info']['url'])
		except KeyError:
			continue
	return article_url_list
