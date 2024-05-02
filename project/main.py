from core.msc_scraping import MscScraping
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event=None, context=None):
    logging.info("Starting Function", extra={"Function Name": "lambda_handler"})
    mscScraping = MscScraping()
    mscScraping.run()


if __name__ == "__main__":
    lambda_handler()
