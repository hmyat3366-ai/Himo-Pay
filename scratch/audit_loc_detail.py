import os
import re

features_dir = r"c:\Users\User\Desktop\Xia Power\lib\features"
missing_loc_files = []

for root, dirs, files in os.walk(features_dir):
    for f in files:
        if f.endswith('.dart'):
            p = os.path.join(root, f)
            with open(p, 'r', encoding='utf-8') as fp:
                c = fp.read()
            if 'app_strings.dart' not in c:
                appbar_match = re.findall(r'HimoAppBar\s*\(\s*title:\s*[\'"]([^\'"]+)[\'"]', c)
                missing_loc_files.append((p, appbar_match))

print(f"Total missing files in features/: {len(missing_loc_files)}")
for p, titles in sorted(missing_loc_files, key=lambda x: x[0]):
    rel = os.path.relpath(p, features_dir)
    print(f"{rel:50} -> AppBars: {titles}")
