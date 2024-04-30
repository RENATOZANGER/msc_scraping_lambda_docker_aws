import re
from selenium.common import TimeoutException
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
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
        self.logging.warning("get driver")
        self.driver.get(
            "https://www.msccruzeiros.com.br/Search%20Result?area=SOA&embkPort=SSZ&departureDateFrom=01%2F01%2F2025&departureDateTo=31%2F01%2F2025&passengers=2%7C0%7C0%7C0&page=1&nights=6%2C7")
        self.logging.warning("Start...")
        try:
            self.logging.warning("Start Scraping")
            WebDriverWait(self.driver, 10).until(
                EC.presence_of_element_located((By.CLASS_NAME, "itinerary-card-detail__destination"))
            )
            self.logging.warning("waiting find elements")
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
        except TimeoutException:
            self.logging.warning("Element not found")
        except Exception as e:
            self.logging.error(f"Error: {str(e)}")
        finally:
            self.driver.quit()
