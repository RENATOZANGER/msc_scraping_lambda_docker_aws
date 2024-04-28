# README

### Webscraping MSC with lambda AWS

Script to perform web scraping on the msc website in python (lambda-AWS). Check if the cruise value is below R$5800.00, if so, send an email with cruise details.
*it will be necessary create a SNS and put your email as Subscribing.

### Dockerfile

# Docker Setup for Python Web Scraping

This Dockerfile sets up a Python environment equipped with Chrome and ChromeDriver, suitable for running web scraping tasks in a container.

## Overview

This Dockerfile is split into two stages:
1. **Build stage**: Downloads and unpacks Chrome and ChromeDriver.
2. **Slim stage**: Sets up a minimal environment with necessary libraries and copies the downloaded files from the build stage.

### Build Stage

- **Base Image**: Starts from `python:3.12` which is a Debian-based image with Python pre-installed.
- **Dependencies**: Installs `unzip` and `curl` for downloading and extracting Chrome and ChromeDriver.
- **Download and Extract**:
  - Downloads Chrome and ChromeDriver using `curl` from Google's storage.
  - Unzips both into `/opt/`.
  - Cleans up the temporary files to reduce the image size.

### Slim Stage

- **Base Image**: Uses `python:3.12-slim` to keep the image size minimal.
- **Dependencies**:
  - Installs necessary libraries for running Chrome headlessly.
  - Removes APT lists to keep the image size down after installation.
- **Copy Files**: Copies Chrome and ChromeDriver from the build stage.
- **Python Environment**:
  - Copies the `requirements.txt` file and installs Python dependencies.
  - Copies the project files into the container.

### Final Setup

- **Working Directory**: Sets the working directory to `/project` where the project files are located.
- **Entrypoint**: Configured to use Python for running the AWS Lambda RIC (Runtime Interface Client).
- **Command**: The default command runs the `main.lambda_handler` function.

### Python Script (main.py)

The `main.py` file contains the Lambda function code written in Python. This function uses Selenium to perform web scraping on the provided URL (`https://example.com/`). It initializes a headless Chrome browser using the Chrome browser and Chromedriver binaries, navigates to the specified URL, extracts text content from the HTML, and returns it as the output of the Lambda function.

### Usage

To use this Lambda function, follow these steps:

1. Create a new private repository in Amazon ECR:
- Ex: account_id.dkr.ecr.us-east-1.amazonaws.com/lambda_scraping
2. Retrieve an authentication token and authenticate your Docker client to your registry
- aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin account_id.dkr.ecr.us-east-1.amazonaws.com
3. Build your Docker image
- docker build -t lambda_scraping .
4. Tag your image so you can push
- docker tag lambda_scraping:latest account_id.dkr.ecr.us-east-1.amazonaws.com/lambda_scraping:latest
5. Push this image to your newly created AWS repository
- docker push account_id.dkr.ecr.us-east-1.amazonaws.com/lambda_scraping:latest
6. Create a SNS and use your email in Subscribing.
6. Create a Lambda function in AWS Lambda.
7. Configure the Lambda function to use the container image from the container registry.
9. set the lambda timeout to more than 1 minute
10. click on test