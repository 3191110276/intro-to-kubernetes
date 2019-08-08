# Use an official Python runtime as a parent image
FROM python:3-alpine

MAINTAINER Michael Maurer "mimaurer@cisco.com"

# Copy the directory contents into the container at /app
COPY ./app /app

# Set the working directory to /app
WORKDIR /app

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Run app.py when the container launches
CMD python app.py runserver -h 0.0.0.0