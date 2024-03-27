#!/usr/bin/env bash

##############################################################################
#+ Script for fixing ownership and permission before updating Homebrew.
#+
#+ Meng Lu <lumeng.dev@gmail.com>
#+
#+ * History:
#+ - 2024-3-26: Moved the commands from Homebrew updating script out to this
#+   stand-alone script for checking and fixing user, group, and permission of
#+   files and directories.
#+ - 2024-3-20: Initially created this as part of the regular Homebrew update
#+   script.
##

##############################################################################
#+ Setting up find command.
#+

if [[ $(uname -s) == 'Darwin' ]]; then
    if [[ -f /usr/local/bin/gfind ]]; then
        FIND_BIN=/usr/local/bin/gfind
    else
        FIND_BIN=find
    fi
fi

type $FIND_BIN >/dev/null 2>&1 || ( echo "[ERROR] Install GNU find executable first!" && exit 1 )

[[ ! $($FIND_BIN --version) == *GNU* ]] && ( echo "[ERROR] Install GNU find executable first!" && exit 1 )



################################################################################
#+ Fixing ownership and permission for the directory of local Homebrew Git repo.
#+
#+ References:
#+ * <http://apple.stackexchange.com/questions/277386/how-to-upgrade-homebrew-itself-not-softwares-formulas-installed-by-it-on-macos>
#+ * <http://discourse.brew.sh/t/how-to-upgrade-brew-stuck-on-0-9-9/33>

if [[ -d "$(brew --prefix)/Homebrew" ]]; then
    echo "[INFO] Checking and fixing owner, group of $(brew --prefix)/Homebrew:"
    $FIND_BIN "$(brew --prefix)/Homebrew" \( -not -user $(id -un) \) -or \( -not -group wheel \) \
              -exec ls -l '{}' \; \
              -exec sudo chown $(id -un):wheel '{}' \;
    echo "[INFO] Checking and fixing rw permission of $(brew --prefix)/Homebrew:"
    $FIND_BIN "$(brew --prefix)/Homebrew" -not -perm -u+rw \
              -exec ls -l '{}' \; \
              -exec sudo chmod u+rw '{}' \;
    echo "[INFO] Checking and fixing x permission of sub-directories in $(brew --prefix)/Homebrew:"
    $FIND_BIN "$(brew --prefix)/Homebrew" -type d -not -perm -ug+x \
              -exec ls -l '{}' \; \
              -exec sudo chmod ug+x '{}' \;
fi


##############################################################################
#+ Fix ownership and permission of Homebrew related file paths.
#+
#+ * Fix read and write permission of files and folders recursively for the
#+   user so Homebrew can create and modify files there for installing
#+   softwares without using sudo.
#+
#+ * sudo chown root:wheel /usr/local
#+   This is no longer necessary nor possible as of 2024-3 (macOS 14.4,
#+   Homebrew 4.1.0) as /usr/local is by default owned by root:wheel and not
#+   changeable.
#+
#+ * Finding sub-directories and files in $(brew --prefix) that do not have
#+   ownership as $(id -un):wheel then fix it.
#+
#+ * c.f.
#+   * <https://apple.stackexchange.com/questions/1393/are-my-permissions-for-usr-local-correct>
#+   * <https://www.google.com/search?q=%22%2Fusr%2Flocal%22+%22root%3Awheel%22+homebrew>
#+   * https://apple.stackexchange.com/questions/470617/safe-way-to-fix-ownership-and-permission-of-homebrew-related-directories-as-part
#+
#+


if [[ -d $(brew --prefix) ]]; then
    echo "[INFO] Checking and fixing owner and group for $(brew --prefix)/*:"
    $FIND_BIN $(brew --prefix) -mindepth 1 \( -not -user root \) -or \( -not -group wheel \) \
              -exec ls -l '{}' \; \
              -exec sudo chown root:wheel '{}' \;
fi


echo "[INFO] Checking and fixing owner and group for various /usr/local/XXX directories used by Homebrew:"

DIRS=(\
  /usr/local/Caskroom \
  /usr/local/Cellar \
  /usr/local/Frameworks \
  /usr/local/Homebrew \
  /usr/local/bin \
  /usr/local/etc \
  /usr/local/include \
  /usr/local/lib \
  /usr/local/opt \
  /usr/local/sbin \
  /usr/local/share \
  /usr/local/var/homebrew \
)

for dir in $DIRS
do
    if [[ -d $dir ]]; then
        echo "[INFO] Checking and fixing owner and group for $dir:"
        $FIND_BIN $dir \( -not -user $(id -un) \) -or \( -not -group wheel \) \
                  -exec ls -l '{}' \; \
                  -exec sudo chown $(id -un):wheel '{}' \;
    fi
done


if [[ -d /opt/homebrew-cask ]]; then
    echo "[INFO] Checking and fixing owner and group for /opt/homebrew-cask:"
    $FIND_BIN /opt/homebrew-cask \( -not -user $(id -un) \) -or \( -not -group wheel \) \
              -exec ls -l '{}' \; \
              -exec sudo chown $(id -un):wheel '{}' \;
    echo "[INFO] Checking and fixing permission for /opt/homebrew-cask:"
    $FIND_BIN /opt/homebrew-cask -not -perm -u+rw \
              -exec ls -l '{}' \; \
              -exec sudo chmod u+rw '{}' \;
fi


if [[ -d $HOME/Library/Caches/Homebrew ]]; then
    echo "[INFO] Checking and fixing owner and group for $HOME/Library/Caches/Homebrew:"
    $FIND_BIN "$HOME/Library/Caches/Homebrew" -not -user $(id -un) \
              -exec ls -l '{}' \; \
              -exec sudo chown $(id -un) '{}' \;
    echo "[INFO] Checking and fixing permission for $HOME/Library/Caches/Homebrew:"
    $FIND_BIN "$HOME/Library/Caches/Homebrew" -not -perm -u+rw \
              -exec ls -l '{}' \; \
              -exec sudo chmod u+rw '{}' \;
fi


################################################################################
#+ Fix execute permission of folders recursively, so content inside
#+ are accessible by the user and the group
#+ (c.f. <https://superuser.com/questions/168578/why-must-a-folder-be-executable>.)
#+

DIRS=(\
  $(brew --prefix) \
  /opt/homebrew-cask \
  "$HOME/Library/Caches/Homebrew" \
)

for dir in $DIRS
do
    if [[ -d $dir ]]; then
        echo "[INFO] Checking and fixing x permission of sub-directories in $dir:"
        $FIND_BIN $dir -type d -not -perm -ug+x \
                  -exec ls -l '{}' \; \
                  -exec sudo chmod ug+x '{}' \;
    fi
done


################################################################################
#+ Fix write permission of zsh folders. c.f. <https://archive.ph/dL8U1>
##
type zsh >/dev/null 2>&1 && type compaudit >/dev/null 2>&1 && compaudit | xargs chmod g-w


## END

