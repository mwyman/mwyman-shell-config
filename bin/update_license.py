#!/usr/bin/env python
# -*- encoding: utf-8 -*-

import argparse
import os.path
import re

parser = argparse.ArgumentParser(description='Update license text on source files.')
parser.add_argument('-l', '--license',
                    help='path to the license file to insert.')
parser.add_argument('files', nargs='+',
                    help='the files to update license comments for.')
parser.add_argument('-n', '--dry-run', action='store_true',
                    help='only print the changes that will be made.')

group = parser.add_argument_group()
group.add_argument('--insert-filename', dest='insert_filename', action='store_true',
                    help='prepend the current file name into the license.')
group.add_argument('--no-insert-filename', dest='insert_filename', action='store_false')
group.set_defaults(feature=True)

opts = parser.parse_args()

# Ensure valid license file (either implicit = 'LICENSE' or explicit exists).
if not opts.license:
  if not os.path.isfile('LICENSE'):
    parser.error('implicit license file path "LICENSE" does not exist '
                 '(specify with --license).')
  opts.license = 'LICENSE'
elif not os.path.isfile(opts.license):
  parser.error('license file path provided does not exist: %s' % (opts.license))

# Read the license file into license_text, pre-pending comment start/mid text.
with open(opts.license, 'r') as lfile:
  license_text = ''
  for line in lfile:
    license_text += '//  ' + line

IMPORT_RE = re.compile('''^#[ \t]*(?:(import|include))''', flags=re.MULTILINE)

for fpath in opts.files:
  if not os.path.isfile(fpath):
    continue
  with open(fpath, 'r') as fp:
    content = fp.read()
    match = IMPORT_RE.search(content)
    if match:
      content = content[match.start():]

  header = '//\n//  %s\n//\n' % (os.path.basename(fpath))
  footer = '// ' + ('=' * 77) + '\n\n'
  if opts.insert_filename:
    content = header + license_text + footer + content
  else:
    content = license_text + footer + content

  if opts.dry_run:
    print content
  else:
    with open(fpath, 'w') as fp:
      fp.write(content)

