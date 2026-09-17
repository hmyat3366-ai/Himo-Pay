import sys
sys.stdout.reconfigure(encoding='utf-8')

with open('himopay google.html', 'r', encoding='utf-8') as f:
    text = f.read()

idx = text.find('openProfilePasscode')
if idx != -1:
    print(text[idx-50:idx+1500])
