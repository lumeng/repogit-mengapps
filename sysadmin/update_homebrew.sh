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

xcode-select --install

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


brew cleanup


##
#+ Update all softwares installed using "brew cask" using 'brew-cask-upgrade'.
#+ * https://github.com/buo/homebrew-cask-upgrade
##

brew tap buo/cask-upgrade
brew cu -y -a --cleanup
# brew list --cask | xargs brew reinstall --cask ## alternatively, reinstall all softwares

brew cleanup

brew doctor


################################################################################
#+ Install softwares.
##


################################################################################
#+ 2021-12-25: Install qView](https://interversehq.com/qview/).
#+ 
##

brew list qview >/dev/null 2>&1 || brew install --cask qview
if [[ $(brew outdated | grep -c qview) > 0 ]]; then
    if [[ -e '/Applications/qView.app' || -z "$(ls -A '/Applications/qView.app')" ]]; then
        osascript -e 'quit app "qView"' && rm -rf '/Applications/qView.app'
    fi
    brew reinstall --cask qview
fi


################################################################################
#+ 2021-9-16: Install Matrix client [Element](https://matrix.org/clients-matrix/)
#+
##
brew list element >/dev/null 2>&1 || brew install --cask element
if [[ $(brew outdated | grep -c element) > 0 ]]; then
    if [[ -e '/Applications/Element.app' || -z "$(ls -A '/Applications/Element.app')" ]]; then
        osascript -e 'quit app "Element"' && rm -rf '/Applications/Element.app'
    fi
    brew reinstall --cask element
fi


################################################################################
#+ 2021-9-10: Install [iMazing](https://www.imazing.com)
#+
##
# brew list imazing >/dev/null 2>&1 || brew install --cask imazing
# if [[ $(brew outdated | grep -c imazing) > 0 ]]; then
#     if [[ -e '/Applications/Imazing.app' || -z "$(ls -A '/Applications/Imazing.app')" ]]; then
#         osascript -e 'quit app "Imazing"' && rm -rf '/Applications/Imazing.app'
#     fi
#     brew reinstall --cask imazing
# fi


################################################################################
#+ 2021-8-30: Install [RescueTime](https://www.rescuetime.com)
#+
##
brew list rescuetime >/dev/null 2>&1 || brew install --cask rescuetime
if [[ $(brew outdated | grep -c rescuetime) > 0 ]]; then
    if [[ -e '/Applications/RescueTime.app' || -z "$(ls -A '/Applications/RescueTime.app')" ]]; then
        osascript -e 'quit app "RescueTime"' && rm -rf '/Applications/RescueTime.app'
    fi
    brew reinstall --cask rescuetime
fi


################################################################################
#+ 2021-8-30: Install [Audacity](https://wiki.audacityteam.org)
#+
##
brew list audacity >/dev/null 2>&1 || brew install --cask audacity
if [[ $(brew outdated | grep -c audacity) > 0 ]]; then
    if [[ -e '/Applications/Audacity.app' || -z "$(ls -A '/Applications/Audacity.app')" ]]; then
        osascript -e 'quit app "Audacity"' && rm -rf '/Applications/Audacity.app'
    fi
    brew reinstall --cask audacity
fi


################################################################################
#+ 2021-8-29: Install [Anki](https://apps.ankiweb.net)
#+
##
brew list anki >/dev/null 2>&1 || brew install --cask anki
if [[ $(brew outdated | grep -c anki) > 0 ]]; then
    if [[ -e '/Applications/Anki.app' || -z "$(ls -A '/Applications/Anki.app')" ]]; then
        osascript -e 'quit app "Anki"' && rm -rf '/Applications/Anki.app'
    fi
    brew reinstall --cask anki
fi


################################################################################
#+ 2021-8-27: Install [GoldenDict](http://goldendict.org)
#+
##
brew list goldendict >/dev/null 2>&1 || brew install --cask goldendict
if [[ $(brew outdated | grep -c goldendict) > 0 ]]; then
    if [[ -e '/Applications/GoldenDict.app' || -z "$(ls -A '/Applications/GoldenDict.app')" ]]; then
        osascript -e 'quit app "GoldenDict"' && rm -rf '/Applications/GoldenDict.app'
    fi
    brew reinstall --cask goldendict
fi


################################################################################
#+ 2021-8-16: Install [EBMac](http://ebstudio.info/manual/EBMac/)
#+
##
brew list ebmac >/dev/null 2>&1 || brew install --cask ebmac
if [[ $(brew outdated | grep -c ebmac) > 0 ]]; then
    if [[ -e '/Applications/EBMac.app' || -z "$(ls -A '/Applications/EBMac.app')" ]]; then
        osascript -e 'quit app "EBMac"' && rm -rf '/Applications/EBMac.app'
    fi
    brew reinstall --cask ebmac
fi


################################################################################
#+ 2021-8-16: Install [Eclipse](https://www.eclipse.org)
#+
##

brew list --cask temurin >/dev/null 2>&1 || brew install --cask temurin

brew list eclipse-jee >/dev/null 2>&1 || brew install eclipse-jee
if [[ $(brew outdated | grep -c eclipse-jee) > 0 ]]; then
    if [[ -e '/Applications/Eclipse JEE.app' || -z "$(ls -A '/Applications/Eclipse JEE.app')" ]]; then
        osascript -e 'quit app "Eclipse JEE"' \
            && cp -R '/Applications/Eclipse JEE.app' "/Applications/Eclipse JEE.app.$(date '+%Y-%m-%d').bak" \
            && rm -rf '/Applications/Eclipse JEE.app'
    fi
    brew reinstall eclipse-jee
fi


################################################################################
#+ 2021-8-11: Install [IINA](https://iina.io)
#+
##
brew list --cask iina >/dev/null 2>&1 || brew install --cask iina
if [[ $(brew outdated | grep -c iina) > 0 ]]; then
    if [[ -e '/Applications/IINA.app' || -z "$(ls -A '/Applications/IINA.app')" ]]; then
            osascript -e 'quit app "IINA"' && rm -rf '/Applications/IINA.app'
    fi
    brew reinstall --cask iina
fi


################################################################################
#+ 2021-7-16: Install [Manuskript](https://www.theologeek.ch/manuskript/)
#+
##
brew list manuskript >/dev/null 2>&1 || brew install manuskript
if [[ $(brew outdated | grep -c manuskript) > 0 ]]; then
    if [[ -e '/Applications/Manuskript.app' || -z "$(ls -A '/Applications/Manuskript.app')" ]]; then
           osascript -e 'quit app "Manuskript"' && rm -rf '/Applications/Manuskript.app'
    fi
    brew reinstall --cask manuskript
fi


################################################################################
#+ 2021-7-16: Install tree
#+
##
brew list tree >/dev/null 2>&1 || brew install tree


################################################################################
#+ 2021-7-12: Install ipfs
#+
##
brew list ipfs >/dev/null 2>&1 || brew install ipfs


################################################################################
#+ 2021-7-12: Install Evernote.
#+
##
brew list --cask Evernote >/dev/null 2>&1 || brew install --cask evernote
if [[ $(brew outdated | grep -c evernote) > 0 ]]; then
    if [[ -e '/Applications/Evernote.app' || -z "$(ls -A '/Applications/Evernote.app')" ]]; then
           osascript -e 'quit app "Evernote"' && rm -rf '/Applications/Evernote.app'
    fi
    brew reinstall --cask evernote
fi


################################################################################
#+ 2021-7-7: Install mkvtoolnix
#+
##
brew list mkvtoolnix >/dev/null 2>&1 || brew install mkvtoolnix


################################################################################
#+ 2021-7-6: Install splayer
#+
##
brew list --cask splayer >/dev/null 2>&1 || brew install --cask splayer


################################################################################
#+ 2021-7-5: Install snipaste
#+
##
brew list --cask snipaste >/dev/null 2>&1 || brew install --cask snipaste
if [[ $(brew outdated | grep -c the-unarchiver) > 0 ]]; then
    if [[ -e '/Applications/Snipaste.app' || -z "$(ls -A '/Applications/Snipaste.app')" ]]; then
           osascript -e 'quit app "Snipaste"' && rm -rf '/Applications/Snipaste.app'
    fi
    brew reinstall --cask snipaste
fi


################################################################################
#+ 2021-6-28: Install SmcFanControls
#+
##
brew list --cask smcfancontrol >/dev/null 2>&1 || brew install --cask smcfancontrol


################################################################################
#+ 2021-6-28: Install MenuMeters
#+ * installed file: /Users/meng/Library/PreferencePanes/MenuMeters.prefPane
##
brew list --cask menumeters >/dev/null 2>&1 || brew install --cask menumeters
if [[ $(brew outdated | grep -c menumeters) > 0 ]]; then
    if [[ -e '/Applications/MenuMeters.app' || -z "$(ls -A '/Applications/MenuMeters.app')" ]]; then
           osascript -e 'quit app "MenuMeters"' && rm -rf '/Applications/MenuMeters.app'
    fi
    brew reinstall --cask menumeters
fi


################################################################################
#+ 2021-6-28: Install trash-cli
#+ * alternative applications:
#+   * trash-cli
#+   * macos-trash
#+   * trash
##
brew list trash-cli >/dev/null 2>&1 || brew install trash-cli


################################################################################
#+ 2021-6-26: Install Discord
##
brew list --cask discord >/dev/null 2>&1 || brew install --cask discord
if [[ $(brew outdated | grep -c discord) > 0 ]]; then
    if [[ -e '/Applications/Discord.app' || -z "$(ls -A '/Applications/Discord.app')" ]]; then
           osascript -e 'quit app "Discord"' && rm -rf '/Applications/Discord.app'
    fi
    brew reinstall --cask discord
fi


################################################################################
#+ 2021-6-25: Install The Unarchiver
##
brew list --cask the-unarchiver >/dev/null 2>&1 || brew install --cask the-unarchiver
if [[ $(brew outdated | grep -c the-unarchiver) > 0 ]]; then
    if [[ -e '/Applications/The Unarchiver.app' || -z "$(ls -A '/Applications/The Unarchiver.app')" ]]; then
           osascript -e 'quit app "The Unarchiver"' && rm -rf '/Applications/The Unarchiver.app'
    fi
    brew reinstall --cask the-unarchiver
fi


################################################################################
#+ Install sourcetree.
##
brew list --cask sourcetree >/dev/null 2>&1 || brew install sourcetree
if [[ $(brew outdated | grep -c the-unarchiver) > 0 ]]; then
    if [[ -e '/Applications/SourceTree.app' || -z "$(ls -A '/Applications/SourceTree.app')" ]]; then
           osascript -e 'quit app "SourceTree"' && rm -rf '/Applications/SourceTree.app'
    fi
    brew reinstall --cask sourcetree
fi


################################################################################
#+ Install coreutils.
##
brew list coreutils >/dev/null 2>&1 || brew install coreutils


################################################################################
#+ Install rsync.
##

brew list rsync >/dev/null 2>&1 || brew install rsync


################################################################################
#+ Install FileZilla.
#+ * 2021-1-20: Disable the installation as it is no longer available or
#+ compatible with macOS 10.14.6 (at least).
##

# brew list --cask filezilla >/dev/null && brew install --cask filezilla


################################################################################
## 2017-5-21: For using Multimarkdown syntax in source files of Ikiwiki websites#+ 2019-10-10: Superseded this with multimarkdown in pkgsrc as an dependency of ikiwiki.
##.
# brew list multimarkdown >/dev/null 2>&1 || brew install multimarkdown


################################################################################
## 2017-5-21: Install FileZilla via Homebrew so it's automatically updated via
#+ the cron job to update Homebrew.
#+ 2020-3-10: Stop installing FileZilla. Replace it with CyberDuck.
##
#brew list --cask filezilla >/dev/null 2>&1 || brew install --cask filezilla


################################################################################
## 2017-5-30: Install R.
#+ To enable rJava support, run the following command:
#+   R CMD javareconf JAVA_CPPFLAGS=-I/System/Library/Frameworks/JavaVM.framework/Headers
#+ If you've installed a version of Java other than the default, you might need to instead use:
#+   R CMD javareconf JAVA_CPPFLAGS="-I/System/Library/Frameworks/JavaVM.framework/Headers -I/Library/Java/JavaVirtualMachines/jdk<version>.jdk/"
#+ (where <version> can be found by running `java -version`, `/usr/libexec/java_home`, or `locate jni.h`), or:
#+   R CMD javareconf JAVA_CPPFLAGS="-I/System/Library/Frameworks/JavaVM.framework/Headers -I$(/usr/libexec/java_home | grep -o '.*jdk')"
#+
##


################################################################################
## 2017-6: Install R
brew list r >/dev/null 2>&1 || brew install r

## 2017-6-8: Install MacTeX
brew list --cask mactex >/dev/null 2>&1 || brew install --cask mactex

## 2017-6-25: Install RocketChat
brew list --cask rocket-chat >/dev/null 2>&1 || brew install --cask rocket-chat
if [[ $(brew outdated | grep -c rocket-chat) > 0 || -z "$(ls -A '/Applications/Rocket.Chat.app')" ]]; then
    if [[ -e /Applications/RocketChat.app ||  -e /Applications/Rocket.Chat.app ]]; then
           osascript -e 'quit app "RocketChat"' && rm -rf '/Applications/RocketChat.app'
           osascript -e 'quit app "Rocket.Chat"' && rm -rf '/Applications/Rocket.Chat.app'
    fi
    brew reinstall --cask rocket-chat
fi


################################################################################
## 2017-6-26: Intall MySQL Workbench
brew list --cask mysqlworkbench > /dev/null || brew install --cask mysqlworkbench


################################################################################
## 2017-6-26: Intall docker
brew list --cask docker > /dev/null || brew install --cask docker
brew list --cask docker-toolbox > /dev/null || brew install --cask docker-toolbox


################################################################################
## 2017-7-17： Install tor-browser.
brew list --cask tor-browser > /dev/null || brew install --cask tor-browser

################################################################################
## 2017-7-20： Install Python.
brew list python > /dev/null || brew install python
brew list python3 > /dev/null || brew install python3
#brew reinstall python


################################################################################
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
brew list --cask emacs > /dev/null || brew install --cask emacs


################################################################################
## 2017-8-10: Install macvim

#+ Uninstall emacs that was previously installed with
#+ 'brew install macvim'
#brew uninstall --ignore-dependencies macvim

#+ Install macvim using 'brew cask' so /Applications/Macvim.app is
#+ properly created since 'brew linkapps macvim' is depcrecated since
#+ at least 2017-8.
brew list macvim > /dev/null || brew reinstall macvim --with-override-system-vim
brew link --overwrite macvim

################################################################################
## 2017-8-10: Install ghostscript
brew list ghostscript > /dev/null || ( brew install ghostscript && brew link ghostscript --overwrite )


################################################################################
## 2017-8-10: Install gnupg
## 2018-3-3: On macOS, do not install gnupg. Instead, install the formula 'gpg-suite' and use the gpg binary inside it.
#brew list gnupg > /dev/null || ( brew install gnupg && brew link gnupg --overwrite )


## 2017-9-29: Install simple-comic
brew list --cask simple-comic > /dev/null || brew install --cask simple-comic


################################################################################
#+ Install macfuse and ntfs-3g-mac
#+ * 2021-6-22: Install macfuse and ntfs-3g-mac which now supersede osxfuse and ntfs-3g.
#+ * 2017-9-20: Install ntfs-3g and osxfuse to enable read and write on NTFS hard
#+ drives.
#+ * References:
#+   * ntfs-3g-mac: https://github.com/gromgit/homebrew-fuse/tree/main/Formula
#+   * 2021-6-22: https://github.com/gromgit/homebrew-fuse/tree/main/Formula
#+   * medium.com/@technikhil/setting-up-ntfs-3g-on-your-mac-os-sierra-11eff1749898
##

## 2021-6-22: Uninstall osxfuse if it is installed as it has been superseded by macfuse.
#brew list --cask osxfuse >/dev/null 2>&1 || brew install --cask osxfuse
brew list osxfuse >/dev/null 2>&1 && brew uninstall osxfuse
brew list --cask macfuse >/dev/null 2>&1 || brew install macfuse

## 2021-6-22: Uninstall ntfs-3g if it is installed as it has been superseded by ntfs-3g-mac in tap gromgit/homebrew/fuse
#brew list ntfs-3g > /dev/null || brew install ntfs-3g
brew list ntfs-3g >/dev/null 2>&1 && brew uninstall ntfs-3g
brew tap gromgit/homebrew-fuse
brew list ntfs-3g-mac >/dev/null 2>&1 || brew install ntfs-3g-mac


################################################################################
## 2017-9-23: Install diffmerge
##
brew list --cask diffmerge >/dev/null 2>&1 || brew install --cask diffmerge


################################################################################
## 2017-10-12L Install sloccount
brew list sloccount > /dev/null || brew install sloccount


################################################################################
## 2017-10-25: Install and upgrade graphviz.
#+ * https://en.wikipedia.org/wiki/Graphviz
##
brew list graphviz > /dev/null || brew install graphviz


################################################################################
## 2017-11-2: Install vagrant (VM) and virtualbox (hypervisor, i.e. VM player)
brew list --cask vagrant >/dev/null 2>&1 || brew install --cask vagrant
brew list --cask virtualbox >/dev/null 2>&1 || brew install --cask virtualbox
brew list --cask virtualbox-extension-pack >/dev/null 2>&1 || brew install --cask virtualbox-extension-pack


################################################################################
## 2017-11-2: Install cvs.
brew list cvs > /dev/null || ( brew install cvs && brew link cvs --overwrite )


################################################################################
## 2017-11-11: Intall xquartz.
brew list --cask xquartz >/dev/null 2>&1 || brew install --cask xquartz
## Or reinstall it to upgrade it to the newest version
# brew reinstall --cask xquartz


################################################################################
## 2017-11-19: Intall 'Resilio Sync'.
brew list --cask resilio-sync >/dev/null 2>&1 || brew install --cask resilio-sync

if [[ $(brew outdated | grep -c resilio-sync) > 0 ]]; then
    if [[ -e '/Applications/Resilio Sync.app' || -z "$(ls -A '/Applications/Resilio Sync.app')" ]]; then
           osascript -e 'quit app "Resilio Sync"' && rm -rf '/Applications/Resilio Sync.app'
    fi
    brew reinstall --cask resilio-sync
fi


################################################################################
## 2017-11-22: Install npm.
brew list npm > /dev/null || brew install npm


################################################################################
## 2017-11-22: Install [GPG Suite, namely GPGTools](https://gpgtools.org/).
brew list --cask gpg-suite > /dev/null || brew install --cask gpg-suite


################################################################################
## 2017-11-24: Install and update selected [JetBrains](https://www.jetbrains.com/products.html) softwares.

#formulas=(intellij-idea pycharm phpstorm webstorm datagrip clion)
#appdirs=("Intellij IDEA" "PyCharm" "PhpStorm" "WebStorm" "DataGrip" "CLion")
formulas=(intellij-idea pycharm phpstorm datagrip clion)
appdirs=("Intellij IDEA" "PyCharm" "PhpStorm" "DataGrip" "CLion")

for idx in {0..5}
do
    brew list --cask ${formulas[$idx]} >/dev/null 2>&1 || brew install --cask ${formulas[$idx]}
    if [[ $(brew outdated | grep -c ${formulas[$idx]}) > 0 ]]; then
        if [[ -d "/Applications/${appdirs[$idx]}.app" ]]; then
            rm -rf "/Applications/${appdirs[$idx]}.app"
        fi
        brew reinstall --cask ${formulas[$idx]}
    fi
done

#+ c.f. https://stackoverflow.com/questions/40251201/upgrading-intellij-idea-after-sierra-upgrade-does-not-have-write-access-to-pri/41383566#41383566
[[ -d /Applications/IntelliJ\ IDEA.app ]] && xattr -d com.apple.quarantine /Applications/IntelliJ\ IDEA.app 2>/dev/null
[[ -d /Applications/PyCharm.app ]] && xattr -d com.apple.quarantine /Applications/PyCharm.app 2>/dev/null
[[ -d /Applications/PhpStorm.app ]] && xattr -d com.apple.quarantine /Applications/PhpStorm.app 2>/dev/null
#[[ -d /Applications/WebStorm.app ]] && xattr -d com.apple.quarantine /Applications/WebStorm.app 2>/dev/null
[[ -d /Applications/DataGrip.app ]] && xattr -d com.apple.quarantine /Applications/DataGrip.app 2>/dev/null
[[ -d /Applications/CLion.app ]] && xattr -d com.apple.quarantine /Applications/CLion.app 2>/dev/null


################################################################################
## 2017-12-14: Install and update node.
brew list node >/dev/null 2>&1 || brew install node


################################################################################
## 2017-12-20: Install and update [Tableau Public](https://public.tableau.com/).
brew list --cask tableau-public >/dev/null 2>&1 || brew install --cask tableau-public


################################################################################
## 2017-12-22: Install and update mp4box.
#+ https://stackoverflow.com/questions/5651654/ffmpeg-how-to-split-video-efficiently
#+ mp4box -cat file1.mp4 -cat file2.mp4 output.mp4
##
brew list mp4box >/dev/null 2>&1 || brew install mp4box


################################################################################
## 2017-12-30: Install and update ccleaner.
brew list --cask ccleaner > /dev/null || brew install --cask ccleaner


################################################################################
## 2018-1-4: Install and update [OpenBazaar](https://www.openbazaar.org/)
brew list --cask openbazaar >/dev/null 2>&1 || brew install --cask openbazaar
if [[ $(brew outdated | grep -c openbazaar) > 0 ]]; then
    if [[ -e '/Applications/OpenBazaar2.app' || -z "$(ls -A '/Applications/OpenBazaar2.app')" ]]; then
           osascript -e 'quit app "OpenBazaar2"' && rm -rf '/Applications/OpenBazaar2.app'
    fi
    brew reinstall --cask openbazaar
fi


################################################################################
## 2018-1-4: Install and update [MPlayer](https://en.wikipedia.org/wiki/MPlayer)
brew list --cask mplayer-osx-extended >/dev/null 2>&1 || brew install --cask mplayer-osx-extended
if [[ $(brew outdated | grep -c mplayer-osx-extended) > 0 ]]; then
    if [[ -e '/Applications/MPlayer OSX Extended.app' || -z "$(ls -A '/Applications/MPlayer OSX Extended.app')" ]]; then
           osascript -e 'quit app "MPlayer OSX Extended"' && rm -rf '/Applications/MPlayer OSX Extended.app'
    fi
    brew reinstall --cask mplayer-osx-extended
fi


################################################################################
## 2018-1-31: Install and update [Blockstack](https://blockstack.org/)
brew list --cask blockstack >/dev/null 2>&1 || brew install --cask blockstack
if [[ $(brew outdated | grep -c blockstack) > 0 ]]; then
    if [[ -e '/Applications/Blockstack.app' || -z "$(ls -A '/Applications/Blockstack.app')" ]]; then
           osascript -e 'quit app "Blockstack"' && rm -rf '/Applications/Blockstack.app'
    fi
    brew reinstall --cask blockstack
fi


################################################################################
## 2018-3-29: Install and update [Transmission](https://en.wikipedia.org/wiki/Transmission_(BitTorrent_client))
brew list --cask transmission >/dev/null 2>&1 || brew install --cask transmission


################################################################################
## 2018-9-6: Install and update [Google Chrome Beta](https://www.google.com/chrome/beta/)
#brew list --cask homebrew/cask-versions/google-chrome-beta >/dev/null 2>&1 || brew install --cask homebrew/cask-versions/google-chrome-beta


################################################################################
## 2018-10-1: Install and update [Telegram](https://en.wikipedia.org/wiki/Telegram_(service))
#+ 2019-11-29: Install Telegram Desktop in favor of Telegram as the latter seems to have one drawback: you cannot use Cmd + <up arrow> to scroll back a screenful of content.
##
#brew list --cask telegram >/dev/null 2>&1 || brew install --cask telegram
brew list --cask telegram-desktop >/dev/null 2>&1 || brew install --cask telegram-desktop
if [[ $(brew outdated | grep -c telegram-desktop) > 0 ]]; then
    if [[ -e '/Applications/Telegram Desktop.app' || -z "$(ls -A '/Applications/Telegram Desktop.app')" ]]; then
           osascript -e 'quit app "Telegram Desktop"' && rm -rf '/Applications/Telegram Desktop.app'
    fi
    brew reinstall --cask telegram-desktop
fi


################################################################################
## 2020-3-26: Install and update [git](https://git-scm.com/)
#+
##
if [[ $(brew outdated | grep -c git) > 0 ]]; then
    brew upgrade git
fi


################################################################################
## 2018-12-10: Install and update [git-lfs](https://git-lfs.github.com)
#+ 2020-3-11: Stop installing git-lfs as it is no longer available.
#+ 2020-7-20: git-lfs is changed from a cask to formula.
##
brew list git-lfs >/dev/null 2>&1 || brew install git-lfs
if [[ $(brew outdated | grep -c git-lfs) > 0 ]]; then
    brew upgrade git-lfs
fi


################################################################################
# 2018-12-20: Install and update [LimeChat](http://limechat.net)
# 2019-2-28: LimeChat is not longer released via Homebrew due to the fact
# the latest version of the software can ONLY be downloaded from Apple's
# App Store.
# brew list --cask limechat >/dev/null 2>&1 || brew install --cask limechat



################################################################################
# 2019-3-5: Install and update [Android Studio](https://developer.android.com/studio)
#
brew list --cask android-studio >/dev/null 2>&1 || brew install --cask android-studio
if [[ $(brew outdated | grep -c android-studio) > 0 ]]; then
    if [[ -e '/Applications/Android Studio.app' || -z "$(ls -A '/Applications/Android Studio.app')" ]]; then
           osascript -e 'quit app "Android Studio"' && rm -rf '/Applications/Android Studio.app'
    fi
    brew reinstall --cask android-studio
fi

brew list --cask android-file-transfer >/dev/null 2>&1 || brew install --cask android-file-transfer
if [[ $(brew outdated | grep -c android-file-transfer) > 0 ]]; then
    if [[ -e '/Applications/Android File Transfer.app' || -z "$(ls -A '/Applications/Android File Transfer.app')" ]]; then
           osascript -e 'quit app "Android File Transfer"' && rm -rf '/Applications/Android File Transfer.app'
    fi
    brew reinstall --cask android-file-transfer
fi


# android-messages
# android-ndk
# android-platform-tools
# android-sdk
# android-studio-preview
# androidtool
# anytrans-for-android
# unity-android-support-for-editor
# whoozle-android-file-transfer-nightly
# xamarin-android
# xamarin-android-player


################################################################################
# 2019-3-17: Install and update [MacDown](https://macdown.uranusjr.com/)
#
brew list --cask macdown >/dev/null 2>&1 || brew install --cask macdown


################################################################################
# 2019-3-26: Install and update Thunderbird.
#
#brew list --cask thunderbird-beta >/dev/null 2>&1 || brew install --cask thunderbird-beta
brew list --cask thunderbird >/dev/null 2>&1 || brew install --cask thunderbird
if [[ $(brew outdated | grep -c thunderbird) > 0 ]]; then
    if [[ -e '/Applications/Thunderbird.app' || -z "$(ls -A '/Applications/Thunderbird.app')" ]]; then
           osascript -e 'quit app "Thunderbird"' && rm -rf '/Applications/Thunderbird.app'
    fi
    brew reinstall --cask thunderbird
fi


################################################################################
# 2019-3-26: Install and update Welly.
#
brew list --cask welly >/dev/null 2>&1 || brew install --cask welly


################################################################################
# 2019-9-29 Install and update Libre Office.
brew list --cask libreoffice > /dev/null || brew install --cask libreoffice
brew list --cask libreoffice-language-pack > /dev/null || brew install --cask libreoffice-language-pack


################################################################################
# 2019-12-1 Install and update Calibre.
brew list --cask calibre >/dev/null 2>&1 || brew install --cask calibre
if [[ $(brew outdated | grep -c calibre) > 0 ]]; then
    if [[ -e '/Applications/calibre.app' || -z "$(ls -A '/Applications/calibre.app')" ]]; then
           osascript -e 'quit app "calibre"' && rm -rf '/Applications/calibre.app'
    fi
    brew reinstall --cask calibre
fi


################################################################################
# 2019-12-13 Install and update VLC Player.
# 2023-01-09 Disable vlc-webplugin as it was as of then obsolete.
brew list --cask vlc || brew install --cask --force vlc
#brew list --cask vlc-webplugin || brew install --cask vlc-webplugin
brew list --cask vlcstreamer || brew install --cask --force vlcstreamer

if [[ $(brew outdated | grep -c vlc) > 0 ]]; then
    if [[ -e '~/Library/Internet Plug-Ins/VLC Plugin.plugin' ]]; then
        rm -rf '~/Library/Internet Plug-Ins/VLC Plugin.plugin'
    fi
    if [[ -e '/Applications/VLC.app' || -z "$(ls -A '/Applications/VLC.app')" ]]; then
           osascript -e 'quit app "VLC"' && rm -rf '/Applications/VLC.app'
    fi
    if [[ -e '/Applications/VLCStreamer.app' || -z "$(ls -A '/Applications/VLCStreamer.app')" ]]; then
           osascript -e 'quit app "VLCStreamer"' && rm -rf '/Applications/VLCStreamer.app'
    fi
    brew reinstall --cask vlc
    brew reinstall --cask vlc-webplugin
    brew reinstall --cask --force vlcstreamer
fi


################################################################################
# 2020-1-7 Install and update Soundflower
brew list --cask soundflower || brew install --cask soundflower


################################################################################
# TODO 2020-2-4 Install and update Mutt
#brew list mutt || brew install mutt
#brew list getmail || brew install getmail


################################################################################
# 2020-2-5 Install and update [NextCloud](https://nextcloud.com)
brew list --cask nextcloud || brew install --cask nextcloud


################################################################################
# 2020-2-5 Install and update [AirDroid](https://www.airdroid.com/)
brew list --cask airdroid || brew install --cask airdroid


################################################################################
## 2020-3-10: Install [CyberDuck](https://cyberduck.io/).
brew list --cask cyberduck >/dev/null 2>&1 || brew install --cask cyberduck


################################################################################
## 2020-3-26: Install [Zoom](https://zoom.us).
#brew list --cask zoomus >/dev/null 2>&1 || brew install --cask zoomus
#if [[ $(brew outdated | grep -c zoomus) > 0 ]]; then
#    if [[ -e /Applications/zoom.us.app ]]; then
#        rm -rf '/Applications/zoom.us.app'
#    fi
#    brew reinstall --cask zoomus
#fi


################################################################################
## 2020-3-28: Install [Wickr](https://wickr.com).
brew list --cask wickrme >/dev/null 2>&1 || brew install --cask wickrme
if [[ $(brew outdated | grep -c wickrme) > 0 ]]; then
    if [[ -e /Applications/WickrMe.app ]]; then
           osascript -e 'quit app "WickrMe"' && rm -rf '/Applications/WickrMe.app'
    fi
    brew reinstall --cask wickrme
fi


################################################################################
## 2020-6-11: Install [JDownloader](https://jdownloader.com).
#+ * First install JDK 8 which is required by jDownloader.
##
brew list --cask homebrew/cask-versions/adoptopenjdk8 >/dev/null 2>&1 || brew install --cask homebrew/cask-versions/adoptopenjdk8

brew list --cask jdownloader >/dev/null 2>&1 || brew install --cask jdownloader
if [[ $(brew outdated | grep -c jdownloader) > 0 ]]; then
    if [[ -e '/Applications/jDownloader 2.0.app' || -z "$(ls -A '/Applications/jDownloader 2.0.app')" ]]; then
           osascript -e 'quit app "jDownloader 2.0"' && rm -rf '/Applications/jDownloader 2.0.app'
    fi
    if [[ -e '/Applications/JDownloader2.app' || -z "$(ls -A '/Applications/JDownloader2.app')" ]]; then
           osascript -e 'quit app "JDownloader2"' && rm -rf '/Applications/JDownloader2.app'
    fi
    brew reinstall --cask jdownloader
fi


################################################################################
## 2020-6-21: Install [Stretchly](https://hovancik.net/stretchly/).
##
brew list --cask stretchly >/dev/null 2>&1 || brew install --cask stretchly


## 2020-6-11: Install [JDownloader](https://jdownloader.com).
#+ * First install JDK 8 which is required by jDownloader.
##
brew list --cask macdjview >/dev/null 2>&1 || brew install --cask macdjview
if [[ $(brew outdated | grep -c MacDjView) > 0 ]]; then
    if [[ -e '/Applications/MacDjView.app' || -z "$(ls -A '/Applications/MacDjView.app')" ]]; then
           osascript -e 'quit app "MacDjView"' && rm -rf '/Applications/MacDjView.app'
    fi
    brew reinstall --cask macdjview
fi


################################################################################
## 2020-6-23: Install [Skitch](https://evernote.com/products/skitch).
brew list --cask skitch >/dev/null 2>&1 || brew install --cask skitch
if [[ $(brew outdated | grep -c skitch) > 0 ]]; then
    if [[ -e '/Applications/Skitch.app' || -z "$(ls -A '/Applications/Skitch.app')" ]]; then
           osascript -e 'quit app "Skitch"' && rm -rf '/Applications/Skitch.app'
    fi
    brew reinstall --cask skitch
fi


################################################################################
## 2020-6-23: Install OpenJDK.
#+ 2020-07-20: Change openjdk from cask to formula.
#+
##
brew list openjdk >/dev/null 2>&1 || brew install openjdk
brew list --cask adoptopenjdk >/dev/null 2>&1 || brew install --cask adoptopenjdk


################################################################################
## 2020-6-23: Install curl.
brew list curl >/dev/null 2>&1 || brew install curl


################################################################################
## 2020-9-28: Install WhatSize.
brew list --cask whatsize >/dev/null 2>&1 || brew install --cask whatsize
if [[ $(brew outdated | grep -c whatsize) > 0 ]]; then
    if [[ -e '/Applications/WhatSize.app' || -z "$(ls -A '/Applications/WhatSize.app')" ]]; then
           osascript -e 'quit app "WhatSize"' && rm -rf '/Applications/WhatSize.app'
    fi
    brew reinstall --cask whatsize
fi


################################################################################
## 2020-11-1: Install youtube-dl.
brew list youtube-dl >/dev/null 2>&1 || brew install youtube-dl


################################################################################
## 2020-11-9: Install Franz.
# brew list --cask franz >/dev/null 2>&1 || brew install --cask franz
# if [[ $(brew outdated | grep -c franz) > 0 ]]; then
#     if [[ -e '/Applications/Franz.app' || -z "$(ls -A '/Applications/Franz.app')" ]]; then
#         rm -rf '/Applications/Franz.app'
#     fi
#     brew reinstall --cask franz
# fi


################################################################################
## 2020-11-20: Install [GoPanda](https://pandanet-igs.com).
brew list --cask gopanda >/dev/null 2>&1 || brew install --cask gopanda
if [[ $(brew outdated | grep -c gopanda) > 0 ]]; then
    if [[ -e '/Applications/GoPanda2.app' || -z "$(ls -A '/Applications/GoPanda2.app')" ]]; then
           osascript -e 'quit app "GoPanda2"' && rm -rf '/Applications/GoPanda2.app'
    fi
    brew reinstall --cask gopanda
fi


################################################################################
## 2020-11-26: Install [GoPanda](https://pandanet-igs.com).
brew list --cask gopanda >/dev/null 2>&1 || brew install --cask gopanda
if [[ $(brew outdated | grep -c gopanda) > 0 ]]; then
    if [[ -e '/Applications/GoPanda2.app' || -z "$(ls -A '/Applications/GoPanda2.app')" ]]; then
           osascript -e 'quit app "GoPanda2"' && rm -rf '/Applications/GoPanda2.app'
    fi
    brew reinstall --cask gopanda
fi


################################################################################
## 2020-12-24: Install [pyglossary](https://github.com/ilius/pyglossary).
brew list pygobject3 >/dev/null 2>&1 || brew install pygobject3
brew list gtk+3 >/dev/null 2>&1 || brew install gtk+3


################################################################################
## 2020-12-31: Install [ocrmypdf](https://github.com/jbarlow83/OCRmyPDF)
brew list ocrmypdf >/dev/null 2>&1 || brew install ocrmypdf
brew list tesseract-lang >/dev/null 2>&1 || brew install tesseract-lang


################################################################################
## 2021-11-20: Install [TeamViewer](https://www.teamviewer.com).
brew list --cask teamviewer >/dev/null 2>&1 || brew install --cask teamviewer
if [[ $(brew outdated | grep -c teamviewer) > 0 ]]; then
    if [[ -e '/Applications/TeamViewer.app' || -z "$(ls -A '/Applications/TeamViewer.app')" ]]; then
        osascript -e 'quit app "TeamViewer"' && rm -rf '/Applications/TeamViewer.app'
    fi
    brew reinstall --cask teamviewer
fi


################################################################################
## 2021-1-20: Install exiftool.
brew list exiftool >/dev/null 2>&1 || brew install exiftool


################################################################################
## 2021-3-14: Install mediainfo.
brew list media-info >/dev/null 2>&1 || brew install media-info
brew list --cask mediainfo >/dev/null 2>&1 || brew install --cask mediainfo


################################################################################
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

## Cleaning up.

brew cleanup
brew cleanup -s
rm -rf $(brew --cache)

## Restore $PATH.
export PATH=$OLD_PATH

## Say finished!
say "Updating homebrew finished!"
echo -ne '\007'

## END
