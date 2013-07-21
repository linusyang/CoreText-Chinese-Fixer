CoreText Chinese Fixer
======
v0.1 by Linus Yang

Introduction
------
In iOS 5 and below, the CoreText framework has an issue that all Chinese glyphs are shown in bold style, no matter which style you have chosen in CTFontDescriptor. (iOS 6 and above has fixed this issue.)

Detailed information please visit [this page](https://github.com/Cocoanetics/DTCoreText/issues/104).

This Cydia tweak can fix this annoying issue below iOS 6, especially for apps like **Opera Mini** , which uses CoreText to render its text.

Build
------
    git clone --recursive git://github.com/linusyang/CoreText-Chinese-Fixer.git
    cd CoreText-Chinese-Fixer
    make
    make package # If you have dpkg-deb utilities