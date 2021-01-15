#!/usr/bin/env bash

##############################################################################
#+ * Author: Meng Lu <lumeng.dev@gmail.com>
#+ * Summary: 
#+ * References: https://stackoverflow.com/questions/23233252/broken-references-in-virtualenvs
#+
##

source "$HOME/.bashrc_python_config"

if [[ -d $WORKON_HOME ]]; then
    for subdir in $(find $WORKON_HOME -maxdepth 1 -type d); do
        if [[ -f "${subdir}/bin/activate" ]]; then
            echo $(basename $subdir)
            find $subdir -type l -exec rm '{}' \;
            virtualenv $subdir
            workon $(basename $subdir)
            deactivate
        fi
    done
fi

## END
