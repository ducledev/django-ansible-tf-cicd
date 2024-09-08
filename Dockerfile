FROM python:3.12

WORKDIR /app

# Install pipenv
RUN pip install --upgrade pip && pip install pipenv

# Copy Pipfile and Pipfile.lock
COPY Pipfile Pipfile.lock /app/

# Install dependencies using pipenv
RUN pipenv install --system --deploy --ignore-pipfile

# Copy project
COPY . /app/

RUN python manage.py collectstatic --noinput

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "django-demo.wsgi:application"]