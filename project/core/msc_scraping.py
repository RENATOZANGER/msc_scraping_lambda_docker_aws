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
            target_value = scraping_service.process_results(results)
            if target_value:
                message = json.dumps(target_value, indent=4, ensure_ascii=False)
                self.sns_client.publish_message('SNS_ARN', message)
        finally:
            driver.quit()
