import sys
sys.stdout.reconfigure(encoding='utf-8')

with open('himopay google.html', 'r', encoding='utf-8') as f:
    text = f.read()

idx = text.find('toggleAppLanguage')
if idx != -1:
    print(text[idx-50:idx+800])

idx_toast = text.find('function showToast')
if idx_toast != -1:
    print("\n--- SHOW TOAST ---")
    print(text[idx_toast-20:idx_toast+600])
