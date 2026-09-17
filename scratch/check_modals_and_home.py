import sys
import re
sys.stdout.reconfigure(encoding='utf-8')

with open('himopay google.html', 'r', encoding='utf-8') as f:
    text = f.read()

modals = re.findall(r'id=["\']modal-[^"\']+["\']', text)
print("All modals in HTML:", set(modals))

# Check header of home screen in HTML
idx_home = text.find('id="screen-home"')
if idx_home != -1:
    print("\n--- HOME HEADER IN HTML ---")
    print(text[idx_home:idx_home+2500])
