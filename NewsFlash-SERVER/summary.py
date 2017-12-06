import urllib.request, urllib.parse, urllib.error
import requests
import math

import networkx as nx
import numpy as np

from nltk.tokenize.punkt import PunktSentenceTokenizer
from sklearn.feature_extraction.text import TfidfTransformer, CountVectorizer


# Optional: enter your valid SMMRY API key here
#  (probably not necessary)
apiKey = "7579E987F7"


def textrank(document):
    sentence_tokenizer = PunktSentenceTokenizer()
    sentences = sentence_tokenizer.tokenize(document)

    bow_matrix = CountVectorizer().fit_transform(sentences)
    normalized = TfidfTransformer().fit_transform(bow_matrix)

    similarity_graph = normalized * normalized.T

    nx_graph = nx.from_scipy_sparse_matrix(similarity_graph)
    scores = nx.pagerank(nx_graph)
    sentence_array = sorted(((scores[i], s) for i, s in enumerate(sentences)), reverse=True)
    
    sentence_array = np.asarray(sentence_array)
    
    fmax = float(sentence_array[0][0])
    fmin = float(sentence_array[len(sentence_array) - 1][0])
    
    temp_array = []
    # Normalization
    for i in range(0, len(sentence_array)):
        if fmax - fmin == 0:
            temp_array.append(0)
        else:
            temp_array.append((float(sentence_array[i][0]) - fmin) / (fmax - fmin))


    threshold = (sum(temp_array) / len(temp_array)) + 0.2
    
    sentence_list = []

    for i in range(0, len(temp_array)):
        if temp_array[i] > threshold:
            sentence_list.append(sentence_array[i][1])

    seq_list = []
    for sentence in sentences:
        if sentence in sentence_list:
            seq_list.append(sentence)
    
    return seq_list

def summarize(link, length=3):
    url = 'http://api.smmry.com'
    #response = requests.post(url, SM_API_KEY="A1C46D33DF", SM_URL=link, SM_LENGTH=length)
    response = requests.post("http://api.smmry.com/&SM_API_KEY=" + apiKey +\
                            "&SM_KEYWORD_COUNT="+ "8" +"&SM_LENGTH=" + str(length) +\
                            "&SM_URL=" + link)
    result = response.json()
    return {
        'summary': result["sm_api_content"].replace('"', "'"),
        'keywords': result["sm_api_keyword_array"]
    }