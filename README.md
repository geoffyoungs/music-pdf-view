music-pdf-view
==============

View and print multi page sheet music PDFs on a single screen/sheet.

Requirements (Gems)
------------------
* gtk2
* popppler
* json

Changes
-------
* 0.0.1 - 1 Dec 2012
 * Initial version

Description
-----------
This is not your average PDF viewer - it is designed to display sheet
music on a computer screen.

Most PDF viewers are designed to display documents accurately.  This is
designed to display the relevant content for sheet music so that you see
an entire song at once.

It also removes a configurable amount of the page margins. (Defaults are
set to trim the margins in Kingsway Shop PDFs - which are mostly(?)
generated from Finale 2008).

Usage
-----
     $ music-pdf-view /path/to/pdf

Controls
--------
You can edit the amount of whitespace that is cut off at the edges of
each page with the margin controls in the bottom left hand corner.

You can print the current view with the print button in the bottom right
hand corner.

