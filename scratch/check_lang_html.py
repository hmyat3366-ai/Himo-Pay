import sys
sys.stdout.reconfigure(encoding='utf-8')

with open('himopay google.html', 'r', encoding='utf-8') as f:
    text = f.read()

idx = text.find('home-lang-badge')
if idx != -1:
    print(text[idx-100:idx+400])

idx_prof = text.find('profile-lang-')
if idx_prof != -1:
    print("\n--- PROFILE LANG ---")
    print(text[idx_prof-100:idx_prof+400])
