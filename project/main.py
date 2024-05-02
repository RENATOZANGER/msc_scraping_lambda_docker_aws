from core.msc_scraping import MscScraping
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)

REGION =  os.environ.get('REGION')
SNS_ARN = os.environ.get('SNS_TOPIC_ARN')
TARGET_VALUE = float(os.environ.get('TARGET_VALUE'))


def lambda_handler(event=None, context=None):
    logging.info("Starting Function", extra={"Function Name": "lambda_handler"})
    mscScraping = MscScraping()
    mscScraping.run()


if __name__ == "__main__":
    lambda_handler()
