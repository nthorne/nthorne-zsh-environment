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

The work-specific profile depends on the file ~/.zsh/current\_project.zsh
defining a variable named CURRENT\_PROJECT which details the path to the project
that I am currently working on. This feature is used to set up nifty aliases and
functions that requires knowledge of the path of the current project. Also,
the file may contain further project-specific settings, since it is currently
being _sourced_ by work.zsh
