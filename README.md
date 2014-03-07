ESMD
=====
Version     : 0.01	


Description : 
-----------

Major mode to use VMD within emacs.
It is derived from tcl mode but allows to run an instance of VMD in a
second buffer and to send commands to it. Three combinations of keys are added to tcl-mode to directly interact with VMD:
- "\C-c\C-n" vmd-send-line
- "\C-c\C-r" vmd-send-region
- "\C-c\C-q" vmd-send-quit

Usage:
-----------

1. installation:
add to your .emacs file
```
(load "<path>/esmd.el")
```
you might want to add the lines
```
(add-to-list 'auto-mode-alist '("\\.vmd\\'" . vmd-mode))
(autoload 'vmd-mode "vmd" "Major mode for VMD." t)
```
any file with the extension .vmd should be recognised. You can call
the mode manually by "M-x vmd-mode";

2. run VMD within emacs use "M-x vmd-run";

3. start working.

------
										  
  COPYRIGHT														     
  Copyright © 2014.  
  Salvatore M Cosseddu					  
  Centre for Scientific Computing and School of Engineering, University of Warwick, Coventry, UK.			  
  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.  
  This is free software: you are free to change and redistribute it.         	    
  There is NO WARRANTY, to the extent permitted by law.          		    
