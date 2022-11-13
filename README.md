# PNG Defringe

Using PNG Defringe can remove colored fringes from resampled and filtered graphics which have transparency. This is achieved in transparent pixels of true-color PNG graphics based on weighted average of the nearest opaque pixels or a user-defined color. The level of shading (number of pixels) around an opaque pixel can be defined while leaving the user-defined color elsewhere in the transparent pixel space. This program is designed only for true-color PNG formatted images.

## Installation

The installation requires a MATLAB runtime to be downloaded. It is a big file but if you use my other utilities, like the MIDI 64nicator you will not need to download it again.

## Parameters

Process File - Defringe a single true-color PNG of your choice.

Process Folder - Defringe a folder of PNGs

Defringe Level - The number of transparent pixels around an opaque pixel to shade. 0 does no defringing but inserts a base color while full defringes every transparent pixel.

Transparent Color - The color to add to transparent pixels that are not defringed.
