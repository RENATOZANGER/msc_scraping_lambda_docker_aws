import os
import json
import logging
from core.scraping_service import ScrapingService
from adapters.chrome_driver import ChromeDriverAdapter, get_chrome_options
from adapters.sns_client import SNSClientAdapter

REGION = os.environ.get('REGION')
SNS_ARN = os.environ.get('SNS_TOPIC_ARN')
TARGET_VALUE = float("%.3f" % (float(os.environ.get('TARGET_VALUE'))))


class MscScraping:
    def __init__(self):
        self.chrome_driver = ChromeDriverAdapter("/opt/chromedriver")
        self.sns_client = SNSClientAdapter(REGION)
        self.logging = logging
    
    def run(self):
        try:
            options = get_chrome_options()
            driver = self.chrome_driver.get_driver(options)
            scraping_service = ScrapingService(driver)
            self.logging.info("Scraping MSC")
            results = scraping_service.scrape_website()
            self.logging.info("Get results")
            print(TARGET_VALUE, type(TARGET_VALUE))
            target_value = [results[result] for result in results if (float(result) < TARGET_VALUE)]
            if target_value:
                message = json.dumps(target_value, indent=4, ensure_ascii=False)
                self.sns_client.publish_message(SNS_ARN, message)
                self.logging.info("Email successfully sent")
            else:
                self.logging.info("Value above expected")
        except Exception as e:
            self.logging.error(f"Error: {str(e)}")
