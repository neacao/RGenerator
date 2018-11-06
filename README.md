
## Purposed
This project aim to automate generate constant strings, color, font for iOS Development. Define in single file & everything will automate generate to R.* files

## Prerequisite
1. R.h, R.m, en.lproj, vi.proj, strings.xml have to be same location of *.xcodeproj*
2. Put the content split with " | " for multiple language inside strings.json

./generator.rb -p <projectRootPath>