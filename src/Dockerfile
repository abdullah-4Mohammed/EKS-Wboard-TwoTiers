# Dockerfile

# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install Flask, specified in the requirements
RUN pip install --no-cache-dir Flask

# Expose port 80 for the web app
EXPOSE 80

# Run the Flask app
CMD ["python", "app.py"]
