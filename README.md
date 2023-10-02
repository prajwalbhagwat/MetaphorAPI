# MetaphorProject

Project that uses Metaphor's API and a Sentiment Analyzer to explore common sentiment online regarding a user-defined question.

## How to run:

In order to run this project, follow the below steps:

1. Clone the repository
2. Open main.py in MetaphorProject/Metaphor
3. Replace the placeholder API Key with a working Metaphor key.
4. Download with "pip3" the following dependencies: torch, transformers, flask, and metaphor_python
   - Python version used is 3.11
5. Run program with "python3 main.py"
6. Open Xcode Project on Xcode 15.0
7. Launch iOS simulator or use iOS Preview
8. Type question into the TextField bar at the top of the app
9. Click the button below the TextField and watch the app's recommendation appear on the screen.

## How does this work?

This project consists of two portions, a Python Flask server and a client iOS application. The python flask server uses two of Metaphor's endpoints, being "search" and "get contents". For a given question, a search is performed with Metaphor's "search" and then the ids of the search results are collected. The "get contents" endpoint is then used to get the text found on the webpages. A prebuilt sentiment analyzing model is used to get the common sentiment of the text found on the webpages. The sentiments are averaged out to a singular value. If the value is positive, then the sentiment is a positive one, and if the value is negative, then the sentiment is negative, with the magnitude of the value representing how negative or positive the sentiment is on a scale of -1 to 1. The iOS application takes a question written by the user and hits an endpoint on the Python Flask server, providing the question and expecting a resulting sentiment value to be returned.
