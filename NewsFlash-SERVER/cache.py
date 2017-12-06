"""
Utilities to help with caching a current version of the feed
and all the events associated. For testing purposes only (don't want to
exhaust my API credits just yet!)
"""
from flask import Flask, jsonify
import json, pickle
import event

DATA_CACHE_PATH = 'cache/'

"""
List of supported searches:
KEYWORD: "Trump", "iPhone", "Star_Wars", "Black_Friday"
LOCATION: "United_States", "United_Kingdom", "Saudi_Arabia", "China"
CATEGORY: "Society", "Science", "Arts"
"""


def export_main_feed():
    feed_dict = event.get_feed(sortBy='date', numEvents=50)
    with open(DATA_CACHE_PATH + 'feed.pickle', 'wb') as file:
        pickle.dump(feed_dict, file)
    print("Exported " + DATA_CACHE_PATH + 'feed.pickle')

def export_keyword_search_feed(search):
    feed_dict = event.get_feed(search=search, sortBy='relevance', numEvents=20)
    with open(DATA_CACHE_PATH + 'search/search_' + search.replace(' ', '') + '.pickle', 'wb') as file:
        pickle.dump(feed_dict, file)
    print("Exported " + DATA_CACHE_PATH + 'search/search_' + search.replace(' ', '') + '.pickle')

def export_category_search_feed(category):
    feed_dict = event.get_feed(category=category, sortBy='relevance', numEvents=20)
    with open(DATA_CACHE_PATH + 'search/category_' + category + '.pickle', 'wb') as file:
        pickle.dump(feed_dict, file)
    print("Exported " + DATA_CACHE_PATH + 'search/category_' + category + '.pickle')

def export_location_search_feed(location):
    feed_dict = event.get_feed(location=location, sortBy='relevance', numEvents=20)
    with open(DATA_CACHE_PATH + 'search/location_' + location.replace(' ', '') + '.pickle', 'wb') as file:
        pickle.dump(feed_dict, file)
    print("Exported " + DATA_CACHE_PATH + 'search/location_' + location.replace(' ', '') + '.pickle')

def fetch_main_feed():
    data = ""
    with open(DATA_CACHE_PATH + 'feed.pickle', 'rb') as file:
        data = pickle.load(file)
    return data

def fetch_keyword_search_feed(search):
    data = ""
    search = search.replace('+', '_').replace(" ", '_')
    with open(DATA_CACHE_PATH + 'search/search_' + search + '.pickle', 'rb') as file:
        data = pickle.load(file)
    return data

def fetch_location_search_feed(location):
    data = ""
    location = location.replace('+', '_').replace(" ", '_')
    with open(DATA_CACHE_PATH + 'search/location_' + location + '.pickle', 'rb') as file:
        data = pickle.load(file)
    return data

def fetch_category_search_feed(category):
    data = ""
    category = category
    with open(DATA_CACHE_PATH + 'search/category_' + category + '.pickle', 'rb') as file:
        data = pickle.load(file)
    return data

def export_events(uri_list):
    for i in range(len(uri_list)):
        if i % 10 == 0:
            print('Exporting URI #' + str(i))
        uri = uri_list[i]
        event_dict = event.get_event(uri)
        with open(DATA_CACHE_PATH + "events/" + uri + '.pickle', 'wb') as file:
            pickle.dump(event_dict, file)
        print("Exported " + DATA_CACHE_PATH + "events/" + uri + '.pickle')

def fetch_event(event_uri):
    data = ""
    with open(DATA_CACHE_PATH + "events/" + event_uri + '.pickle', 'rb') as file:
        data = pickle.load(file)
    return data

keywords = ["Trump", "iPhone", "Star_Wars", "Black_Friday"]
locations = ["United_States", "United_Kingdom", "Saudi_Arabia", "China"]
categories = ["Society", "Science", "Arts"]

def export_sample_feeds():
    
    # Export main feed
    export_main_feed()
    # Export keyword feeds
    for search in keywords:
        export_keyword_search_feed(search.lower())
    # Export location feeds
    for location in locations:
        export_location_search_feed(location.lower())
    # Export category feeds
    for category in categories:
        export_category_search_feed(category.lower())

    print("Finished exporting all feeds")



#TODO: Export all URIs found in feeds
def get_all_saved_uris():
    print("Getting URIs from main feed")
    all_uris_list = [event['URI'] for event in fetch_main_feed()['events']]
    print(len(all_uris_list))
    for k in keywords:
        print("Getting URIs from", k)
        uri_list = [event['URI'] for event in fetch_keyword_search_feed(k.lower())['events']]
        all_uris_list.extend(uri_list)
        print(len(all_uris_list))
    
    for l in locations:
        print("Getting URIs from", l)
        uri_list = [event['URI'] for event in fetch_location_search_feed(l.lower())['events']]
        all_uris_list.extend(uri_list)
        print(len(all_uris_list))
        
    for c in categories:
        print("Getting URIs from", c)
        uri_list = [event['URI'] for event in fetch_category_search_feed(c.lower())['events']]
        all_uris_list.extend(uri_list)
        print(len(all_uris_list))
        
    return list(set(all_uris_list))

def check_for_summarization_error():
    from os import listdir
    summ_error_list = []
    downloaded_uris = [f.strip('.pickle').replace('ng-', 'eng-') for f in listdir('cache/events/')]
    for u in downloaded_uris:
        try:
            d = fetch_event(u)
            if len(d['event']['summary']) <= 25:
                summ_error_list.append(u)
        except:
            pass
    return summ_error_list

def fetch_undownloaded_uris():
    from os import listdir
    downloaded_uris = [f.strip('.pickle').replace('ng-', 'eng-') for f in listdir('cache/events/')]
    b = [x for x in get_all_saved_uris() if x not in downloaded_uris]
    return b
    
def need_to_redownload():
    return fetch_undownloaded_uris() + check_for_summarization_error()

