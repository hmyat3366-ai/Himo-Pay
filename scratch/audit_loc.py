import os
import re

features_dir = r'lib/features'
results = []

for root, dirs, files in os.walk(features_dir):
    for file in files:
        if file.endswith('.dart'):
            path = os.path.join(root, file)
            with open(path, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
            has_app_strings = 'app_strings.dart' in content or 'AppStrings' in content or '.tr(' in content
            # find hardcoded Text('...') or title: '...'
            text_matches = re.findall(r"Text\(\s*['\"]([A-Za-z][A-Za-z0-9\s,&?!/\-']+)['\"]\s*[,)]", content)
            title_matches = re.findall(r"(?:title|label|subtitle|HimoAppBar)\s*[:\(]\s*['\"]([A-Za-z][A-Za-z0-9\s,&?!/\-']+)['\"]", content)
            all_matches = text_matches + title_matches
            filtered = [t for t in all_matches if len(t.strip()) > 3 and not t.startswith('assets') and not t.startswith('http') and not t.endswith('.png') and not t.endswith('.jpg') and not t.startswith('lib/')]
            results.append((path.replace('\\', '/'), has_app_strings, len(filtered), filtered[:4]))

results.sort(key=lambda x: x[2], reverse=True)
for path, has_tr, count, samples in results:
    if count > 0:
        print(f"{path} | count={count} | has_tr={has_tr} | {samples}")
