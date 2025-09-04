FROM python:3.12-slim

# Install system dependencies including distutils for Python 3.12
RUN apt-get update && \
    apt-get install -y gcc libpq-dev python3.12-venv python3.12-distutils && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN python -m ensurepip --upgrade && pip install --no-cache-dir --upgrade pip

# Install Django
RUN pip install django==3.2

# Copy application code
COPY . .

# Expose the port
EXPOSE 8000

# Start Django app
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
