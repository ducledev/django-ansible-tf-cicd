FROM python:3.12

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=django_demo.settings

WORKDIR /app

# Install pipenv
RUN pip install --upgrade pip && pip install pipenv

# Copy Pipfile and Pipfile.lock
COPY Pipfile Pipfile.lock /app/

# Install dependencies using pipenv
RUN pipenv install --system --deploy --ignore-pipfile

# Copy project
COPY . /app/

# Debug: List contents of /app
RUN ls -la /app

# Debug: Print Python path
RUN python -c "import sys; print(sys.path)"

# Debug: Try to import Django
RUN python -c "import django; print(django.__file__)"

RUN mkdir -p /app/staticfiles

# Run collectstatic with verbose output
RUN python manage.py collectstatic --noinput -v 2

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "django-demo.wsgi:application"]