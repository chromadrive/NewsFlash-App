from flask import Flask, jsonify, render_template
import os
import event, cache


app = Flask(__name__)
	
@app.route('/')
def index():
	return render_template('index.html')

@app.route('/feed/')
def get_default_feed():
	try:
		d = event.get_feed(sortBy='relevance', numEvents=35)
	except:
		d = {'error': "Something's gone wrong"}
	return jsonify(d)

@app.route('/search/')
def show_search_options():
	return "Use /search/keyword/[keyword], /search/location/[location], or /search/category/[category]."

@app.route('/search/')
@app.route('/search/keyword/<keyword>')
def get_keyword_search_feed(keyword):
	keyword = keyword.replace('%20', ' ')
	try:
		d = event.get_feed(search=keyword, sortBy='relevance', numEvents=20)
	except:
		d = {'error': "Something's gone wrong"}
	return jsonify(d)

@app.route('/search/')
@app.route('/search/location/<location>')
def get_location_search_feed(location):
	location = location.replace('%20', ' ')
	try:
		d = event.get_feed(location=location, sortBy='relevance', numEvents=20)
	except:
		d = {'error': "Something's gone wrong"}
	return jsonify(d)

@app.route('/search/')
@app.route('/search/category/<category>')
def get_category_search_feed(category):
	try:
		d = event.get_feed(category=category, sortBy='relevance', numEvents=20)
	except:
		d = {'error': "Something's gone wrong"}
	return jsonify(d)

@app.route('/event/<event_uri>')
def get_event(event_uri):
	try:
		d = event.get_event(event_uri)
	except:
		d = {'error': "Something's gone wrong"}
	return jsonify(d)








"""
FOR TESTING: Cached Data
"""

@app.route('/cache/feed/')
def get_cached_default_feed():
	try:
		d = cache.fetch_main_feed()
	except:
		d = {'error': "Something's gone wrong, feed could not be found."}
	return jsonify(d)

@app.route('/cache/search/')
@app.route('/cache/search/keyword/<keyword>')
def get_cached_keyword_search_feed(keyword):
	keyword = keyword.replace('%20', ' ')
	try:
		d = cache.fetch_keyword_search_feed(keyword)
	except:
		d = {'error': "Something's gone wrong, data could not be found."}
	return jsonify(d)

@app.route('/cache/search/')
@app.route('/cache/search/location/<location>')
def get_cached_location_search_feed(location):
	location = location.replace('%20', ' ')
	try:
		d = cache.fetch_location_search_feed(location)
	except:
		d = {'error': "Something's gone wrong, data could not be found."}
	return jsonify(d)

@app.route('/cache/search/')
@app.route('/cache/search/category/<category>')
def get_cached_category_search_feed(category):
	try:
		d = cache.fetch_category_search_feed(category)
	except:
		d = {'error': "Something's gone wrong, data could not be found."}
	return jsonify(d)

@app.route('/cache/event/<event_uri>')
def get_cached_event(event_uri):
	try:
		d = cache.fetch_event(event_uri)
	except:
		d = {'error': "Something's gone wrong, event could not be found."}
	return jsonify(d)






if __name__ == '__main__':
	port = int(os.environ.get("PORT", 5000))
	app.run(host='0.0.0.0', port=port, debug=True)