import re

with open('himopay google.html', 'r', encoding='utf-8') as f:
    text = f.read()

pos = text.find('screen-profile"')
if pos != -1:
    print("Found screen-profile:")
    print(text[pos-20:pos+3000])

print("\n--- ALL MODALS OR POPUPS IN HTML ---")
for m in re.finditer(r'(modal|popup|dialog|bottom-sheet|action-sheet|drawer)', text, re.IGNORECASE):
    snippet = text[max(0, m.start()-50):min(len(text), m.end()+150)]
    print(snippet)
    print("="*40)
