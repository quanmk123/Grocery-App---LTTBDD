import urllib.request
import urllib.parse
import re
import time

keywords = {
    "cherry tomatoes": "tomato",
    "sweet potato": "potato",
    "raw beef steak": "meat",
    "raw shrimp": "seafood",
    "raw squid": "squid",
    "clams shellfish": "clam",
    "drinking yogurt": "yogurt",
    "coconut water": "coconut",
    "breadsticks cheese": "bread"
}

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
}

for kw, default_term in keywords.items():
    query = f"site:unsplash.com/photos {kw}"
    url = f"https://html.duckduckgo.com/html/?q={urllib.parse.quote(query)}"
    req = urllib.request.Request(url, headers=headers)
    
    try:
        with urllib.request.urlopen(req) as response:
            html = response.read().decode('utf-8')
            # Look for links to unsplash photos like /photos/XXXXX
            matches = re.findall(r'unsplash\.com/photos/([a-zA-Z0-9\-]+)', html)
            if matches:
                unique_matches = list(dict.fromkeys(matches))
                # Filter out terms like 'download', 'license', 'info', etc.
                filtered = [m for m in unique_matches if m not in ['download', 'license', 'info', 'explore', 'login', 'join']]
                print(f"Keyword: {kw} -> Photo IDs: {filtered[:5]}")
            else:
                print(f"Keyword: {kw} -> No photo IDs found. HTML snippet: {html[:200]}")
        time.sleep(1) # Be polite
    except Exception as e:
        print(f"Error fetching {kw}: {e}")
