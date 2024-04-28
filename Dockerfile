# Python:3.12 base image for building the Docker image
FROM python:3.12 as build

# Update the list of available packages and install the unzip and curl packages
# Download chrome-linux64.zip and chromedriver-linux64.zip Version:121.0.6167.184
# Unzip the chrome-linux64.zip and chromedriver-linux64.zip files in /opt/
# free up disk space in /tmp
RUN apt-get update && apt-get install -y unzip curl && \
    curl -Lo "/tmp/chromedriver-linux64.zip" "https://storage.googleapis.com/chrome-for-testing-public/121.0.6167.184/linux64/chromedriver-linux64.zip" && \
    curl -Lo "/tmp/chrome-linux64.zip" "https://storage.googleapis.com/chrome-for-testing-public/121.0.6167.184/linux64/chrome-linux64.zip" && \
    unzip /tmp/chromedriver-linux64.zip -d /opt/ && \
    unzip /tmp/chrome-linux64.zip -d /opt/ && \
    rm -rf /tmp/*

FROM python:3.12-slim

# Install the graphics libraries required to run Chrome in a headless environment
RUN apt-get update && \
    apt-get install -y unzip curl \
        libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 libxcomposite1 \
        libasound2 libxrandr2 libxcursor1 libxext6 libxfixes3 \
        libxi6 libxrender1 libxtst6 ca-certificates fonts-liberation \
        libappindicator1 libnss3 lsb-release xdg-utils && \
    rm -rf /var/lib/apt/lists/*

# Copy Chrome binaries to the final image
COPY --from=build /opt/chrome-linux64 /opt/chrome
# Copy the Chrome driver (Chromedriver) to the final image
COPY --from=build /opt/chromedriver-linux64 /opt/
# Install python dependencies and avoid cache creation
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the app source code
COPY project /project
WORKDIR /project

# Sets the default entry point for container execution
ENTRYPOINT ["/usr/local/bin/python", "-m", "awslambdaric"]

# Defines the default command to be executed when the container starts
CMD [ "main.lambda_handler" ]
