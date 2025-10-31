# Pollster App (Django project)
Python Django voting system that conducts a series of questions along with many choices. A user will be allowed to vote for that question by selecting a choice. Based on the answer the total votes will be calculated and it will be displayed to the user. Users can also check the result of the total votes for specific questions on the website directly. There is also an admin part of the project. Admin user is allowed to add questions and manage questions in the application. 

# Tech Stack
Python, Django and SQLite. Bash for scripting and Python for programming and scripting.

# Quick Start
cd pollster_project
# Install dependencies
pip3 install pipenv

pipenv shell
# Install django
pipenv install django gunicorn psycopg2-binary

cd pollster
# Serve on localhost:8000
python3 manage.py runserver
