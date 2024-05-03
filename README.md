### Webscraping MSC with lambda AWS

Script to perform web scraping on the msc website in python (lambda-AWS). If a cruise is found below the desired value, an email with details of the cruise will be sent.

## Configuration

- All resources are configured for the 'us-east-1' region.
- After creating the resources, confirmation of email subscription is required.
- The scheduler is configured to execute the lambda function every 60 minutes.
- An email will be sent if the cruise price is below `TARGET_VALUE`.
  - The target value is defined in the `main.tf` file under `TARGET_VALUE`.
- Modify the `sns.tf` file to receive emails.
- In the `scraping_service.py` file, the type of search to be performed is defined as follows:
  - `area`: "SOA" (Region: South America)
  - `embkPort`: "SSZ" (Port of Embarkation: Santos)
  - `departureDateFrom`: "01%2F01%2F2025" (January 1, 2025)
  - `departureDateTo`: "31%2F03%2F2025" (March 31, 2025)
  - `passengers`: "2%7C0%7C0%7C0" (Number of passengers: 2 passengers)
  - `nights`: "6%2C7" (Night numbers: 6-7 nights)

## Terraform

- Creates a role for lambda execution.
- Creates a role for scheduler execution.
- Creates a lambda using the ECR image.
- Creates a log group with a retention of 1 day.
- Creates a bucket to use for the remote state of Terraform.
- Creates SNS with email subscription.

## Dockerfile

This Dockerfile sets up a Python environment equipped with Chrome and ChromeDriver, suitable for running web scraping tasks in a container.
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

## Workflow main.yml

- Creates a repository in ECR.
- Builds and pushes the Dockerfile image to ECR.
- Deletes previous images in ECR, leaving only the current image.
- Creates the bucket and enables versioning for the Terraform remote state.
- Deploys resources via Terraform.
- Updates the lambda with the new version of the ECR image.

## Setting Up Secrets and Variables in GitHub

To set up the required credentials, add the following secrets and variables in the 'Secrets and Variables' section:
- `AWS_ACCESS_KEY_ID`
- `AWS_ACCOUNT_ID`
- `AWS_SECRET_ACCESS_KEY`

## Destroying Resources

To destroy all resources, modify the `destroy.yml` file to `true`.