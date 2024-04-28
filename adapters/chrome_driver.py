import tempfile
from selenium import webdriver
from selenium.webdriver.chrome.service import Service


def get_chrome_options():
    options = webdriver.ChromeOptions()
    options.binary_location = '/opt/chrome/chrome'
    options.add_argument("--headless=new")
    options.add_argument('--no-sandbox')
    options.add_argument("--disable-gpu")
    options.add_argument("--window-size=1280x1696")
    options.add_argument("--single-process")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-dev-tools")
    options.add_argument("--no-zygote")
    options.add_argument(f"--user-data-dir={tempfile.mkdtemp()}")
    options.add_argument(f"--data-path={tempfile.mkdtemp()}")
    options.add_argument(f"--disk-cache-dir={tempfile.mkdtemp()}")
    options.add_argument("--remote-debugging-port=9222")
    return options


class ChromeDriverAdapter:
    def __init__(self, service_path):
        self.service = Service(service_path)
    
    def get_driver(self, options):
        return webdriver.Chrome(service=self.service, options=options)
