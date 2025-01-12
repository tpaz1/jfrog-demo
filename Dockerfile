# Use a Python image with known vulnerabilities
FROM tompaztrial.jfrog.io/docker-virtual/python:3.8-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1

ARG PYPI_USER
ARG PYPI_PASSWORD
ARG DEBIAN_USER
ARG DEBIAN_PASSWORD
ENV DEBIAN_USER=${DEBIAN_USER}
ENV DEBIAN_PASSWORD=${DEBIAN_PASSWORD}
ENV PYPI_USER=${PYPI_USER}
ENV PYPI_PASSWORD=${PYPI_PASSWORD}

# Configure APT sources dynamically
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
RUN pip install --index-url=https://${PYPI_USER}:${PYPI_PASSWORD}@tompaztrial.jfrog.io/artifactory/api/pypi/python-2-pypi/simple --no-cache-dir -r requirements.txt

# Expose port
EXPOSE 8000

# Run the application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
