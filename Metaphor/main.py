from metaphor_python import Metaphor
from transformers import pipeline
from flask import Flask, request
import re

app = Flask(__name__)
API_ACCESS_KEY = "XXXX"
sentiment_pipeline = pipeline("sentiment-analysis")
metaphor_client = Metaphor(API_ACCESS_KEY)


@app.route('/')
def hello():
    return 'Hello, World!'


@app.route('/getSentiment', methods=['GET'])
def getSentiment():

    question = request.args.get('question')

    if not question:
        return "No question was provided!"

    response = metaphor_client.search(
        question, use_autoprompt=True)

    ids = [res.id for res in response.results]

    # for result in response.results:
    #     print(result.title, result.url)

    response = metaphor_client.get_contents(ids)

    texts = [(content.title, re.sub('<[^<]+?>', '', content.extract))
             for content in response.contents]

    sentiments = []

    for text in texts:
        sentiments.append(sentiment_pipeline(text[0]))
        sentiments.append(sentiment_pipeline(text[1][:512]))

    sentiment_val = 0

    for obj in sentiments:
        if obj[0]['label'] == 'POSITIVE':
            sentiment_val += obj[0]['score']
        elif obj[0]['label'] == 'NEGATIVE':
            sentiment_val -= obj[0]['score']

    sentiment_val /= len(sentiments)
    # print(sentiment_val)

    print(f"The common sentiment for the question \"{question}\" is",
          'positive' if sentiment_val >= 0 else 'negative', "with a leaning score of", sentiment_val)

    return str(sentiment_val)


if __name__ == '__main__':
    app.run(host='localhost', port=8080)
