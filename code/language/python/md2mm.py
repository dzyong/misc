#!/usr/bin/env python
import sys
import os
import re

DEBUG = 0
title = re.compile("\s*(#+)\s*(.*)")

def readline(f, plevel):
  clevel = None
  data = []
  while True:
    cpos = f.tell()
    line = f.readline()
    if len(line) <= 0:
      break
    matched = re.match(title, line)
    if matched == None:
      continue
    level = len(matched.group(1))
    if (clevel == None):
      clevel = level
    if level <= plevel:
      f.seek(cpos, 0)
      return data
    else:
      if level > clevel:
        f.seek(cpos, 0)
        data.append(readline(f, clevel))
        continue
      if DEBUG:
        print(str(plevel) + "->" + str(level))
        print(line)
      if len(matched.group(2)) > 0:
        data.append(matched.group(2))
  return data
  

def readfile(md):
  f = open(md, mode='r')
  d = readline(f, 0)
  f.close();
  return d

def todotline(data, pdata, f):
  li = pdata
  for i in data:
    if isinstance(i, list):
      todotline(i, li, f)
    else:
      if pdata != None:
        f.writelines("\"" + pdata + "\"->\"" + i + "\"\n")
      li = i

def todot(data, md):
  rname = md
  if md.rfind('.') != -1:
    rname = md[0:md.rfind('.')]
  dot = rname + ".dot"
  f = open(dot, mode='w')
  f.writelines("digraph {\n")
  todotline(data, None, f)
  f.writelines("}\n")
  f.close()
  exes= ["dot", "/c/bin/graphviz/bin/dot"]
  for e in exes:
    if os.system(e + " -T svg " + dot + " -o " + rname + ".svg") == 0:
      if not DEBUG:
        os.remove(dot)
      break

def main():
  if(len(sys.argv) < 2):
    print(sys.argv[0] + " <md1> <md2>...")
    sys.exit(len(sys.argv))
  for i in range(1, len(sys.argv)):
    md = sys.argv[i]
    if DEBUG:
      print(md)
    data = readfile(md)
    if DEBUG:
      print(data)
    todot(data, md)

if __name__ == '__main__':
  main()
