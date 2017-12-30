#!/usr/bin/env bash

##
#+ Script for updating Homebrew.
#+
##

## Abort if not on Mac OS X.
if [[ ! $(uname) == 'Darwin' ]]; then
    echo >&2 "Since Homebrew is a package management system for macOS (formerly known as Mac OS X), it does not make sense to update it on $(uname). Abort."
	exit 1
fi


## If brew is not installed, exit.
export PATH=/usr/local/bin:$PATH  ## Make sure brew is on the path before checking its existence.
type brew >/dev/null 2>&1 || { echo >&2 "Homebrew is not installed. Aborting."; exit 1; }


## Save old $PATH and restore it later
OLD_PATH="$PATH"

## Get the path of binaries installed via Homebrew.
BREW_BIN_PATH=$(brew --prefix)/bin

## The most basic paths that should be included in $PATH
BASIC_PATH=/Applications/Xcode.app/Contents/Developer/usr/bin:/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/sbin

##
#+ Prepend Homebrew binary path to $PATH, so when installing of compiling
#+ softwares using brew, it sees softwares and libraries installed by
#+ brew first.
##

export PATH=$BREW_BIN_PATH:$BASIC_PATH

##
#+ Update 
#+
#+

#+ References:
#+ * http://apple.stackexchange.com/questions/277386/how-to-upgrade-homebrew-itself-not-softwares-formulas-installed-by-it-on-macos
#+ * http://discourse.brew.sh/t/how-to-upgrade-brew-stuck-on-0-9-9/33

cd "$(brew --repo)" && git fetch && git reset --hard origin/master && git clean -i


#+ Update, upgrade, cleanup, diagnose
brew update


brew upgrade


brew prune


##
#+ Update all softwares installed using "brew cask" using 'brew-cask-upgrade'.
#+ * https://github.com/buo/homebrew-cask-upgrade
##

brew tap buo/cask-upgrade
brew cu -y -a --cleanup
# brew cask list | xargs brew cask reinstall ## alternatively, reinstall all softwares


brew cleanup


brew doctor


brew cask doctor

################################################################################
#+ Install softwares.
##

## 2017-5-21: For using Multimarkdown syntax in source files of Ikiwiki websites.
brew list multimarkdown >/dev/null || brew install multimarkdown

## 2017-5-21: Install FileZilla via Homebrew so it's automatically updated via the cron job to update Homebrew.
brew cask list filezilla >/dev/null || brew cask install filezilla

## 2017-5-30: Install R.
#+ To enable rJava support, run the following command:
#+   R CMD javareconf JAVA_CPPFLAGS=-I/System/Library/Frameworks/JavaVM.framework/Headers
#+ If you've installed a version of Java other than the default, you might need to instead use:
#+   R CMD javareconf JAVA_CPPFLAGS="-I/System/Library/Frameworks/JavaVM.framework/Headers -I/Library/Java/JavaVirtualMachines/jdk<version>.jdk/"
#+ (where <version> can be found by running `java -version`, `/usr/libexec/java_home`, or `locate jni.h`), or:
#+   R CMD javareconf JAVA_CPPFLAGS="-I/System/Library/Frameworks/JavaVM.framework/Headers -I$(/usr/libexec/java_home | grep -o '.*jdk')"
#+
##

## 2017-6: Install R
brew list R >/dev/null || brew install R

## 2017-6-8: Install MacTeX
brew cask list mactex >/dev/null || brew cask install mactex

## 2017-6-25: Install RocketChat
brew cask list rocket-chat >/dev/null || brew cask install rocket-chat

## 2017-6-26: Intall MySQL Workbench
brew cask list mysqlworkbench > /dev/null || brew cask install mysqlworkbench

## 2017-6-26: Intall MySQL Workbench
brew cask list mysqlworkbench > /dev/null || brew cask install mysqlworkbench

## 2017-6-26: Intall docker
brew cask list docker > /dev/null || brew cask install docker
brew cask list docker-toolbox > /dev/null || brew cask install docker-toolbox

## 2017-7-17： Install torbrowser.
brew cask list torbrowser > /dev/null || brew cask install torbrowser

## 2017-7-20： Install Python.
brew list python > /dev/null || brew install python
brew list python3 > /dev/null || brew install python3
#brew reinstall python

## 2017-8-10: Install Emacs
#+

#+ Uninstall emacs that was previously installed with
#+ 'brew install emacs --with-cocoa'.

# brew uninstall --ignore-dependencies emacs


#+ Prior to at the most 2017-8 and Homebrew 1.3.1-24-g67b20d9, Emacs
#+ can be intalled using the following command.

# brew list emacs > /dev/null || ( brew install emacs --with-cocoa && brew linkapps emacs )

#+ Install emacs using 'brew cask' so /Applications/Emacs.app is
#+ properly created since 'brew linkapps emacs' is depcrecated since
#+ at least 2017-8.
brew cask list emacs > /dev/null || brew cask install emacs


## 2017-8-10: Install macvim

#+ Uninstall emacs that was previously installed with
#+ 'brew install macvim'
#brew uninstall --ignore-dependencies macvim

#+ Install macvim using 'brew cask' so /Applications/Macvim.app is
#+ properly created since 'brew linkapps macvim' is depcrecated since
#+ at least 2017-8.
brew cask list macvim > /dev/null || brew cask install macvim


## 2017-8-10: Install ghostscript
brew list ghostscript > /dev/null || ( brew install ghostscript && brew link ghostscript --overwrite )


## 2017-8-10: Install gnupg 
brew list gnupg > /dev/null || ( brew install gnupg && brew link gnupg --overwrite )


## 2017-9-29: Install simple-comic
brew cask list simple-comic > /dev/null || brew cask install simple-comic



## 2017-9-20: Install ntfs-3g and osxfuse to enable read and write on NTFS hard
#+ drives.
#+ References:
#+ * medium.com/@technikhil/setting-up-ntfs-3g-on-your-mac-os-sierra-11eff1749898
##
brew list ntfs-3g > /dev/null || brew install ntfs-3g
brew cask list osxfuse >/dev/null || brew cask install osxfuse

## 2017-9-23: Install diffmerge
##
brew cask list diffmerge >/dev/null || brew cask install diffmerge

## 2017-10-12L Install sloccount
brew list sloccount > /dev/null || brew install sloccount

## 2017-10-25: Install and upgrade graphviz.
#+ * https://en.wikipedia.org/wiki/Graphviz
##
brew list graphviz > /dev/null || brew install graphviz

## 2017-11-2: Install vagrant (VM) and virtualbox (hypervisor, i.e. VM player)
brew cask list vagrant >/dev/null || brew cask install vagrant
brew cask list virtualbox >/dev/null || brew cask install virtualbox
brew cask list virtualbox-extension-pack >/dev/null || brew cask install virtualbox-extension-pack

## 2017-11-2: Install cvs.
brew list cvs > /dev/null || ( brew install cvs && brew link cvs --overwrite )

## 2017-11-11: Intall xquartz.
brew cask list xquartz >/dev/null || brew cask install xquartz
## Or reinstall it to upgrade it to the newest version
# brew cask reinstall xquartz


## 2017-11-19: Intall 'Resilio Sync'.
brew cask list resilio-sync >/dev/null || brew cask install resilio-sync


## 2017-11-22: Install npm.
brew list npm > /dev/null || brew install npm


## 2017-11-22: Install [GPG Suite, namely GPGTools](https://gpgtools.org/).
brew cask list gpg-suite > /dev/null || brew cask install gpg-suite


## 2017-11-24: Install [MenuMeters](https://www.ragingmenace.com/software/menumeters/)
brew cask list menumeters > /dev/null || brew cask install menumeters


## 2017-11-24: Install and update selected [JetBrains](https://www.jetbrains.com/products.html) softwares.
brew cask list intellij-idea > /dev/null || brew cask install intellij-idea
brew cask list pycharm > /dev/null || brew cask install pycharm
brew cask list phpstorm > /dev/null || brew cask install phpstorm
## brew cask list webstorm > /dev/null || brew cask install webstorm
brew cask list datagrip > /dev/null || brew cask install datagrip
brew cask list clion > /dev/null || brew cask install clion

#+ c.f. https://stackoverflow.com/questions/40251201/upgrading-intellij-idea-after-sierra-upgrade-does-not-have-write-access-to-pri/41383566#41383566
[[ -d /Applications/IntelliJ\ IDEA.app ]] && xattr -d com.apple.quarantine /Applications/IntelliJ\ IDEA.app
[[ -d /Applications/PyCharm.app ]] && xattr -d com.apple.quarantine /Applications/PyCharm.app
[[ -d /Applications/PhpStorm.app ]] && xattr -d com.apple.quarantine /Applications/PhpStorm.app
## [[ -d /Applications/WebStorm.app ]] && xattr -d com.apple.quarantine /Applications/WebStorm.app
[[ -d /Applications/DataGrip.app ]] && xattr -d com.apple.quarantine /Applications/DataGrip.app
[[ -d /Applications/CLion.app ]] && xattr -d com.apple.quarantine /Applications/CLion.app


## 2017-12-14: Install and update node.
brew list node >/dev/null || brew install node


## 2017-12-20: Install and update [Tableau Public](https://public.tableau.com/).
brew cask list tableau-public >/dev/null || brew cask install tableau-public


## 2017-12-22: Install and update mp4box.
#+ https://stackoverflow.com/questions/5651654/ffmpeg-how-to-split-video-efficiently
#+ mp4box -cat file1.mp4 -cat file2.mp4 output.mp4
##
brew list mp4box >/dev/null || brew install mp4box


## 2017-12-30: Install and update ccleaner.
brew cask list ccleaner > /dev/null || brew cask install ccleaner


## more ...



##
#+ Fix permissions required by applications installed via Munki 
#+ See http://apple.stackexchange.com/questions/174492/how-to-uninstall-munki-managed-software-center-app/
#+ 
#+ * As of at least Homebrew 1.1.11 (March, 2017) (what's the earliest?), Homebrew
#+ no longer requires /usr/local/ to have an ownership different from the
#+ default value of root:wheel. At some point, when running 'brew upgrade' it
#+ tells that
#+     Homebrew no longer needs to have ownership of /usr/local. If you wish you can
#+     return /usr/local to its default ownership with:
#+     sudo chown root:wheel /usr/local
##
#if [[ -d /usr/local/munki ]]; then
#   sudo chown -R root:wheel /usr/local/munki
#   sudo chmod -R o-w /usr/local/munki
#fi

## Restore $PATH.
export PATH=$OLD_PATH

## END
