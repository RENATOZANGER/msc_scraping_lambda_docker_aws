import re
from selenium.webdriver.common.by import By
import logging

area = "SOA"  # Region: South America
embkPort = "SSZ"  # Port of Embarcation: Santos
departureDateFrom = "01%2F01%2F2025"  # January 1, 2025
departureDateTo = "31%2F01%2F2025"  # January 31, 2025
passengers = "2%7C0%7C0%7C0"  # number of passengers: 2 passengers
nights = "6%2C7"  # night numbers 6-7 nights


class ScrapingService:
    def __init__(self, driver):
        self.driver = driver
        self.logging = logging
    
    def scrape_website(self):
        self.driver.get(
            "https://www.msccruzeiros.com.br/Search%20Result?area=SOA&embkPort=SSZ&departureDateFrom=01%2F01%2F2025"
            "&departureDateTo=31%2F01%2F2025&passengers=2%7C0%7C0%7C0&page=1&nights=6%2C7")
        self.driver.implicitly_wait(5)
        
        destinations = self.driver.find_elements(By.CLASS_NAME, "itinerary-card-detail__destination")
        durations = self.driver.find_elements(By.CLASS_NAME, "itinerary-card-detail__duration")
        ship_names = self.driver.find_elements(By.CLASS_NAME, "itinerary-card-detail__ship-name-and-itinerary")
        prices = (self.driver.find_elements(By.CLASS_NAME, "itinerary-card-price__price"))
        ports = self.driver.find_elements(By.CLASS_NAME, "itinerary-card-detail__port-name")
        
        results = {}
        
        for destination, duration, ship_name, price, port in zip(destinations, durations, ship_names, prices, ports):
            value = re.findall(r'\d|\.', price.text)
            formatted_value = ''.join(value)
            result = {
                "Destination": destination.text,
                "Duration": duration.text,
                "Ship_Name": ship_name.text,
                "Boarding": port.text,
                "Price": price.text
            }
            results[formatted_value] = result
        return results
    
    def process_results(self, results):
        target_value = []
        for result in results:
            if float(result) < 5.800:
                target_value.append(results[result])
                self.logging.info(results[result])
            else:
                self.logging.info(results[result])
        return target_value
