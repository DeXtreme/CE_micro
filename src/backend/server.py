import random
from flask import Flask, jsonify

app = Flask(__name__)

wise_sayings = [
    "The only true wisdom is in knowing you know nothing. - Socrates",
    "The only way to do great work is to love what you do. - Steve Jobs",
    "In the middle of difficulty lies opportunity. - Albert Einstein",
    "The only thing we have to fear is fear itself. - Franklin D. Roosevelt",
    "Life is really simple, but we insist on making it complicated. - Confucius",
    "Happiness depends upon ourselves. - Aristotle",
    "It is during our darkest moments that we must focus to see the light. - Aristotle Onassis",
    "The greatest glory in living lies not in never falling, but in rising every time we fall. - Nelson Mandela",
    "The journey of a thousand miles begins with one step. - Lao Tzu",
    "To be yourself in a world that is constantly trying to make you something else is the greatest accomplishment. - Ralph Waldo Emerson",
    "Don't count the days, make the days count. - Muhammad Ali",
    "Believe you can and you're halfway there. - Theodore Roosevelt",
    "Our lives begin to end the day we become silent about things that matter. - Martin Luther King Jr.",
    "The only limit to our realization of tomorrow will be our doubts of today. - Franklin D. Roosevelt",
    "The unexamined life is not worth living. - Socrates",
    "The best way to predict the future is to create it. - Peter Drucker",
    "In three words I can sum up everything I've learned about life: it goes on. - Robert Frost",
    "Success is not final, failure is not fatal: it is the courage to continue that counts. - Winston Churchill",
    "You miss 100% of the shots you don't take. - Wayne Gretzky",
    "The harder I work, the luckier I get. - Samuel Goldwyn",
    "Do not go where the path may lead, go instead where there is no path and leave a trail. - Ralph Waldo Emerson",
    "Life is 10% what happens to us and 90% how we react to it. - Charles R. Swindoll",
    "The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt",
    "The true sign of intelligence is not knowledge but imagination. - Albert Einstein"
]

@app.route('/')
def get_saying():
    return jsonify({
        "saying" : random.choice(wise_sayings)
    })

@app.after_request
def apply_cors(response):
    response.headers["Access-Control-Allow-Origin"] = "*"
    return response

if __name__ == "__main__":
    app.run(host="0.0.0.0")
