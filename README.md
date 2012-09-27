nthorne-zsh-environment
=======================

nthorne's zsh environment

usage
-----
    $ cd ~
    $ git clone --recursive git://github.com/nthorne/nthorne-zsh-environment.git .zsh
    $ ln -s .zsh/.zshrc .
    $ ln -s .zsh/.zprofile .

notes
-----

The work-specific profile depends on the file ~/current\_project.zsh. This
file shall define the following variables:
  * CURRENT\_PROJECT - details the name of the current project
  * CURRENT\_PROJECT\_ROOT - details the root path of the current project
  * CURRENT\_PROJECT\_INSTALL\_PATH - details installation path of current project
  * CURRENT\_PROJECT\_INSTALL\_USER (optional) - details user@server for installation

This feature is used to set up nifty aliases and functions that requires
knowledge of the path of the current project. Also, the file may contain further
project-specific settings, since it is currently being _sourced_ by work.zsh
