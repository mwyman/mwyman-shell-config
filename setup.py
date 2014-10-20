#!/usr/bin/python
# -*- encoding: utf8 -*-

"""
Update the user shell configuration to include the Github-based config.
"""

import os
import re
import sys

USER_HOME=os.path.realpath(os.path.expanduser('~'))
GITHUB_SHELL_PATH=os.path.dirname(os.path.realpath(__file__))

# Create a HOME-relative (or absolute) version of GITHUB_SHELL_PATH
if os.path.relpath(GITHUB_SHELL_PATH, USER_HOME).startswith('..'):
  GITHUB_SHELL_RELPATH=GITHUB_SHELL_PATH
else:
  GITHUB_SHELL_RELPATH=os.path.join(
      '${HOME}',
      os.path.relpath(GITHUB_SHELL_PATH, USER_HOME))


def ExpandAll(path):
  return os.path.expanduser(os.path.expandvars(path))

def ParseConfig(path):
  var_re = re.compile(r'%%(\w+)%%')
  vardict = dict()
  vardict['CONFIG_ROOT'] = GITHUB_SHELL_PATH
  vardict['CONFIG_ROOT_RELATIVE'] = GITHUB_SHELL_RELPATH
  vardict['CONFIG_RELPATH'] = os.path.relpath(
      os.path.dirname(os.path.realpath(path)),
      GITHUB_SHELL_PATH)
  marker = None
  files = []
  contents = []
  with open(path) as fp:
    for line in fp:
      if line.startswith("%% marker:"):
        marker = re.match(r'^%% marker:\s+(.*)', line).group(1)
        if not marker.endswith('\n'):
          marker += '\n'
      elif line.startswith("%% file:"):
        files.append(re.match(r'^%% file:\s+(.*)', line).group(1))
      else:
        for key, value in vardict.iteritems():
          line = line.replace('%%{0}%%'.format(key), value)
        contents.append(line)
  while len(contents) and not contents[0].strip():  # Remove blank lines from the beginning
    contents.pop(0)
  while len(contents) and not contents[-1].strip():  # Remove blank lines from the end
    contents.pop()

  return { 'marker': marker, 'files': files, 'contents': contents }


def UpdateFile(path, contentLines, marker):
  """
  Update the given file with the provided config lines.
  """
  path = os.path.realpath(ExpandAll(path))

  print 'Updating ~/%s...' % (os.path.relpath(path, USER_HOME))

  beginComment = re.sub(r'<>', 'Begin', marker)
  endComment = re.sub(r'<>', 'End', marker)
  with open(path, 'r') as fp:
    lines = fp.readlines()

  outlines = [] 
  incomment = False
  found = False
  for line in lines:
    if line.lower() == beginComment.lower() and not found:
      incomment = True
    elif line.lower() == endComment.lower():
      outlines.append(beginComment)
      outlines.extend(contentLines)
      outlines.append(endComment)
      incomment = False
      found = True
    elif not incomment:
      outlines.append(line)

  if not found:
    # Append the config to the end of the existing file if an existing config
    # was not found.
    outlines.append(beginComment)
    outlines.extend(contentLines)
    outlines.append(endComment)

#  print 'Configuring %s' % (path)
#  sys.stdout.writelines(outlines)
#  print ''
  #with open(path, 'w') as fp:
  #  fp.writelines(outlines)


def FindConfigs(configName='.shell_setup'):
  configs = []
  for root, dirs, files in os.walk(GITHUB_SHELL_PATH):
    if configName in files:
      configs.append(os.path.join(root, configName))
  return configs


def main():

  for configFile in FindConfigs():
    config = ParseConfig(configFile)
    marker = config['marker']
    files = config['files']
    contents = config['contents']

    if not marker or not files or not contents:
      continue

    for path in files:
      if os.path.exists(ExpandAll(path)):
        UpdateFile(path, contents, marker)


if __name__ == '__main__':
    main()

