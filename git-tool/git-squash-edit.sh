#!/bin/env bash
########################################################
#+ author: Meng Lu <lumeng.dev@gmail.com>
#+ git alias command to squash the last n commits using
#+ the nth last commit message as the new commit message.
#+ authoring date: 2021-4-19
#+
#+ * configuration: Include the following in $HOME/.gitconfig
#+   ```
#+   ## squash
#+   #+ * example: to squash the last 3 commits into onw as the new last commit
#+   #+ and use the 3rd last commit message: git squash 3
#+   #+ * $1 in the following is the number of commits to quash together as the new last commit
#+   #+ * reference: <https://stackoverflow.com/a/24018435/607655>
#+   ##
#+   squash = !bash -c 'bash ~/bin/symlink/git-squash $1 $2' -
#+   ```
#+ * usage:
#+   * to squash the last two commits: git squash 2
#+   * to squash the last three commits: git squash 3
#+
#+ * reference: <https://stackoverflow.com/a/24018435/607655>
#+
##

OFFSET=$(($1))

git reset --soft HEAD~${OFFSET}

git commit --all --edit -m"$(git log --format=%B --reverse HEAD..HEAD@{1})"

## END
