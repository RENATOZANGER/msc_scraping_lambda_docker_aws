import os
import json
import logging
from core.scraping_service import ScrapingService
from adapters.chrome_driver import ChromeDriverAdapter, get_chrome_options
from adapters.sns_client import SNSClientAdapter


class MscScraping:
    def __init__(self):
        self.chrome_driver = ChromeDriverAdapter("/opt/chromedriver")
        self.sns_client = SNSClientAdapter("us-east-1")
        self.logging = logging
    
    def run(self):
        try:
            self.logging.info("Exec scraping..", extra={"Function Name": "run"})
            options = get_chrome_options()
            driver = self.chrome_driver.get_driver(options)
            scraping_service = ScrapingService(driver)
            results = scraping_service.scrape_website()
            target_value = [results[result] for result in results if (float(result) < 5.800)]
            self.logging.info(target_value)
            if target_value:
                message = json.dumps(target_value, indent=4, ensure_ascii=False)
                self.sns_client.publish_message(os.environ.get('SNS_TOPIC_ARN'), message)
        except Exception as e:
            self.logging.error(f"Error: {str(e)}")
