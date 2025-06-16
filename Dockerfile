# Use official Python base image
FROM python:3.11-slim

# Label the maintainer
LABEL authors="ali"

# Set working directory inside container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Upgrade pip and install dependencies
RUN chmod +x ./bin/setup.sh

RUN ./bin/setup.sh

# Expose the port your API runs on (adjust as needed)
EXPOSE 8000

# Define the entrypoint to run your API (adjust if you're using Flask, etc.)
# For example, if you're using FastAPI with uvicorn:
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
