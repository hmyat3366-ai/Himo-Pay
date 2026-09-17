import sys
import re
sys.stdout.reconfigure(encoding='utf-8')

with open('himopay google.html', 'r', encoding='utf-8') as f:
    text = f.read()

matches = re.findall(r'.{0,50}language.{0,50}', text, re.IGNORECASE)
for m in matches:
    print("Match:", m.strip())
