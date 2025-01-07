# Use a Python image with known vulnerabilities
FROM tompaztrial.jfrog.io/docker-virtual/python:3.8-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1

# Add build arguments for secrets
ARG DEBIAN_USER
ARG DEBIAN_PASSWORD
ARG PIP_USER
ARG PIP_PASSWORD


RUN echo "deb [trusted=yes] https://${DEBIAN_USER}:${DEBIAN_PASSWORD}@tompaztrial.jfrog.io/artifactory/debian-virtual-debian focal main" > /etc/apt/sources.list



# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    python3-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy application code
COPY app.py /app
COPY requirements.txt /app

# Install Python dependencies
RUN pip install --index-url=https://${PIP_USER}:${PIP_PASSWORD}@tompaztrial.jfrog.io/artifactory/api/pypi/python-2-pypi/simple --no-cache-dir -r requirements.txt

# Expose port
EXPOSE 8000

# Run the application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
