#!/bin/bash

#######################################################################
#+ Summary: find the latest release version number
#+ Author: Meng Lu <lumeng.dev@gmail.com>
#+
#+ ## History:
#+ 2015-05-12: version 1.0
#+
#+ ## To-do:
#+ * Support GNU-styled long options '--foo-bar'
#+ 
#+ ## Usage examples:
#+   ./git-version-number.sh -d "$HOME/WorkSpace/projectfoobar" -p 'release/*'
#+   [DEBUG] 17:05:22: /home/lumeng/WorkSpace/projectfoobar is in a Git repo
#+   [DEBUG] 17:05:22: $git_release_branch_latest_version = 1.17
#+   1.17
#+
#+ ## References:
#+ * http://stackoverflow.com/questions/2180270/check-if-current-directory-is-a-git-repository
##

#######################################################################
#+ A leveled logging function
##

mengLOGGING_LEVEL=6   ## If for production use, use 6
mengLOGGING_LEVEL=3 ## If debugging, use 3

function mengLog () {
    local level
    case "$1" in
    "FINEST") level=1;;
    "ALL") level=1;;
    "FINER") level=2;;
    "TRACE") level=2;;
    "FINE") level=3;;
    "DEBUG") level=3;;
    "CONFIG") level=4;;
    "INFO") level=5;;
    "WARNING") level=6;;
    "WARN") level=6;;
    "SEVERE") level=7;;
    "ERROR") level=7;;
    "FATAL") level=8;;
    "OFF") level=9;;
    *) level=$mengLOGGING_LEVEL_DEFAULT;;
    esac
    if [[ "$level" -ge "$mengLOGGING_LEVEL" ]]; then
    echo "[$1] $(date '+%H:%m:%S'): $2"
    fi
}

#######################################################################
#+ The directory containinig this script.
##

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

#######################################################################
#+ Main
##

## The directory where the command is run.
THIS_DIR=$(pwd)

## Default values for options
#+ Assume $THIS_DIR is a Git repo. Reset it if there is a -d option.
#+
##
GIT_REPO_PATH=$THIS_DIR
RELEASE_BRANCH_GLOB_PATTERN='release/*'

while getopts d:dp:p opt; do
  case $opt in
  d)
      if [[ -d $OPTARG ]]; then
          GIT_REPO_PATH=$OPTARG
      else
      mengLog "ERROR" "not a valid path given to -d."
          exit 1
      fi
      ;;
  p)
      RELEASE_BRANCH_GLOB_PATTERN=$OPTARG
      ;;
  esac
done

## If invalid path for Git repo, print usage and exit.
cd $GIT_REPO_PATH

if [[ -d .git ]] || git rev-parse --git-dir > /dev/null 2>&1; then
    mengLog  "DEBUG" "$(pwd) is in a Git repo"
else
    mengLog "DEBUG" "$(pwd) is NOT in a Git repo"
    mengLog "ERROR" "$GIT_REPO_PATH is not in a valid Git repository.
Navigate to the root path of a Git repository and run

    $0

or specify a directory:

    $0 -d <Git repo path>"
    exit 1
fi

git_release_branch_latest_version=$( \
git for-each-ref                   `# output information on each ref` \
    --sort=-committerdate          `# sort by the commit date` \
    --count=1                      `# only keep one line of result` \
    refs/remotes/origin/${RELEASE_BRANCH_GLOB_PATTERN} `# only look for release branches starting with C, e.g. C1.15.2, C1.14` | \
cut -c 78-                         `# only keep the version number part, e.g. 1.15.2, 1.14` \
)

mengLog "DEBUG" '$git_release_branch_latest_version = '"$git_release_branch_latest_version"

# Regular expression matching version number such as 1.15.2, 1.14
CLOUD_VERSION_NUMBER_REGEX='^[1-9][0-9]*\.[0-9]+(\.[1-9][0-9]*)?$'

# If $version is a valid version number return it, otherwise fail
if [[ ${git_release_branch_latest_version} =~ ${CLOUD_VERSION_NUMBER_REGEX} ]]; then
    echo ${git_release_branch_latest_version}
    exit 0
else
    mengLog "ERROR" "Can't get valid release branch number. Check release branch glob pattern passed to -p option."
    exit 1
fi

## END
