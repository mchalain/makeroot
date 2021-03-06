makeroot
========

Embedded software integration tools.  
Makeroot is a compilation of Makefile to generate : board image, SDK

What Makeroot is not  
--------------------
Makeroot is not a distribution. The packages list is not fix, and can change easily for each project.  
Makeroot is not a toolchain. Makeroot downloads and uses the toolchain that you configured.  
Makeroot is not linux or system dedicated. Makeroot offers to build the kernel that you want,
the system tree as you want.  
Makeroot is not a packages manager. Makeroot doesn't ckeck packages dependancies. You can build two packages with dependancies
for a project, and a third one for another project.  

*Makeroot doesn't decide for you, you keep control of your project*.  

What Makeroot can do for you  
----------------------------
Makeroot is simple to configure the base elements of your embedded system.  
Makeroot allows to add your own element from release package or source control system.  
Makeroot help you to install your device.
Makeroot integrates your developments into your system.

What Makeroot does
--------------------
step by step Makeroot
 * downloads (, builds) and installs a toolchain and other tools
 * builds the bootloader
 * builds and installs a kernel Linux or BSD or other
 * creates a system tree with configuration files and initialisation files
 * installs your libc from your toolchain or build another libc
 * downloads and patches libraries and applications from the Net
 * builds and installs dozens packages
 * generates images on MMC or into raw image file
 
Which concepts Makeroot uses
---------------------------
Makeroot is based on Makefile and try to use only Makefile.
All applications needed to build the device image, are downloaded and build.

Makeroot is dedicated to run on Linux/GNU but may run on Windows or other systems.

Which libc Makeroot uses
-------------------------
 * glibc the GNU Libc
 * eglibc the Embedded GNU Libc
 * musl
 * uClibc
 * dietlib
 * newlib
 
Which compilers Makeroot uses
-----------------------------
 * GCC
   * from GNU with build
   * from Linaro
   * from Code Sourcery
 * CLang
 * ARM tools
