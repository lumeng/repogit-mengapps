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


brew cask doctor

################################################################################
#+ Install softwares.
##


################################################################################
#+ Install FileZilla.
#+ * 2021-1-20: Disable the installation as it is no longer available or
#+ compatible with macOS 10.14.6 (at least).
##

# brew list --cask filezilla >/dev/null && brew install --cask filezilla


################################################################################
## 2017-5-21: For using Multimarkdown syntax in source files of Ikiwiki websites#+ 2019-10-10: Superseded this with multimarkdown in pkgsrc as an dependency of ikiwiki.
##.
# brew list multimarkdown >/dev/null || brew install multimarkdown

################################################################################
## 2017-5-21: Install FileZilla via Homebrew so it's automatically updated via
#+ the cron job to update Homebrew.
#+ 2020-3-10: Stop installing FileZilla. Replace it with CyberDuck.
## 
#brew list --cask filezilla >/dev/null || brew install --cask filezilla

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
brew list R >/dev/null || brew install R

## 2017-6-8: Install MacTeX
brew list --cask mactex >/dev/null || brew install --cask mactex

## 2017-6-25: Install RocketChat
brew list --cask rocket-chat >/dev/null || brew install --cask rocket-chat
if [[ $(brew outdated | grep -c rocket-chat) > 0 ]]; then
    if [[ -e /Applications/RocketChat.app ||  -e /Applications/Rocket.Chat.app ]]; then
        rm -rf '/Applications/RocketChat.app'
        rm -rf '/Applications/Rocket.Chat.app'
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
## 2017-7-17： Install torbrowser.
brew list --cask torbrowser > /dev/null || brew install --cask torbrowser

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



## 2017-9-20: Install ntfs-3g and osxfuse to enable read and write on NTFS hard
#+ drives.
#+ References:
#+ * medium.com/@technikhil/setting-up-ntfs-3g-on-your-mac-os-sierra-11eff1749898
##
brew list ntfs-3g > /dev/null || brew install ntfs-3g
brew list --cask osxfuse >/dev/null || brew install --cask osxfuse

## 2017-9-23: Install diffmerge
##
brew list --cask diffmerge >/dev/null || brew install --cask diffmerge

## 2017-10-12L Install sloccount
brew list sloccount > /dev/null || brew install sloccount

## 2017-10-25: Install and upgrade graphviz.
#+ * https://en.wikipedia.org/wiki/Graphviz
##
brew list graphviz > /dev/null || brew install graphviz

## 2017-11-2: Install vagrant (VM) and virtualbox (hypervisor, i.e. VM player)
brew list --cask vagrant >/dev/null || brew install --cask vagrant
brew list --cask virtualbox >/dev/null || brew install --cask virtualbox
brew list --cask virtualbox-extension-pack >/dev/null || brew install --cask virtualbox-extension-pack

## 2017-11-2: Install cvs.
brew list cvs > /dev/null || ( brew install cvs && brew link cvs --overwrite )

## 2017-11-11: Intall xquartz.
brew list --cask xquartz >/dev/null || brew install --cask xquartz
## Or reinstall it to upgrade it to the newest version
# brew reinstall --cask xquartz


## 2017-11-19: Intall 'Resilio Sync'.
brew list --cask resilio-sync >/dev/null || brew install --cask resilio-sync

if [[ $(brew outdated | grep -c resilio-sync) > 0 ]]; then
    if [[ -e '/Applications/Resilio Sync.app' ]]; then
        rm -rf '/Applications/Resilio Sync.app'
    fi
    brew reinstall --cask resilio-sync
fi


## 2017-11-22: Install npm.
brew list npm > /dev/null || brew install npm


## 2017-11-22: Install [GPG Suite, namely GPGTools](https://gpgtools.org/).
brew list --cask gpg-suite > /dev/null || brew install --cask gpg-suite


## 2017-11-24: Install [MenuMeters](https://www.ragingmenace.com/software/menumeters/)
# brew list --cask menumeters > /dev/null || brew install --cask menumeters
brew list --cask yujitach-menumeters > /dev/null || brew install --cask yujitach-menumeters


## 2017-11-24: Install and update selected [JetBrains](https://www.jetbrains.com/products.html) softwares.

#formulas=(intellij-idea pycharm phpstorm webstorm datagrip clion)
#appdirs=("Intellij IDEA" "PyCharm" "PhpStorm" "WebStorm" "DataGrip" "CLion")
formulas=(intellij-idea pycharm phpstorm datagrip clion)
appdirs=("Intellij IDEA" "PyCharm" "PhpStorm" "DataGrip" "CLion")

for idx in {0..5}
do
    brew list --cask ${formulas[$idx]} >/dev/null || brew install --cask ${formulas[$idx]}
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


## 2017-12-14: Install and update node.
brew list node >/dev/null || brew install node


## 2017-12-20: Install and update [Tableau Public](https://public.tableau.com/).
brew list --cask tableau-public >/dev/null || brew install --cask tableau-public


## 2017-12-22: Install and update mp4box.
#+ https://stackoverflow.com/questions/5651654/ffmpeg-how-to-split-video-efficiently
#+ mp4box -cat file1.mp4 -cat file2.mp4 output.mp4
##
brew list mp4box >/dev/null || brew install mp4box


## 2017-12-30: Install and update ccleaner.
brew list --cask ccleaner > /dev/null || brew install --cask ccleaner


## 2018-1-4: Install and update [OpenBazaar](https://www.openbazaar.org/)
brew list --cask openbazaar >/dev/null || brew install --cask openbazaar
if [[ $(brew outdated | grep -c openbazaar) > 0 ]]; then
    if [[ -e '/Applications/OpenBazaar2.app' ]]; then
        rm -rf '/Applications/OpenBazaar2.app'
    fi
    brew reinstall --cask openbazaar
fi


## 2018-1-4: Install and update [MPlayer](https://en.wikipedia.org/wiki/MPlayer)
brew list --cask mplayer-osx-extended >/dev/null || brew install --cask mplayer-osx-extended
if [[ $(brew outdated | grep -c mplayer-osx-extended) > 0 ]]; then
    if [[ -e '/Applications/MPlayer OSX Extended.app' ]]; then
        rm -rf '/Applications/MPlayer OSX Extended.app'
    fi
    brew reinstall --cask mplayer-osx-extended
fi

## 2018-1-31: Install and update [Blockstack](https://blockstack.org/)
brew list --cask blockstack >/dev/null || brew install --cask blockstack
if [[ $(brew outdated | grep -c blockstack) > 0 ]]; then
    if [[ -e '/Applications/Blockstack.app' ]]; then
        rm -rf '/Applications/Blockstack.app'
    fi
    brew reinstall --cask blockstack
fi


## 2018-3-29: Install and update [Transmission](https://en.wikipedia.org/wiki/Transmission_(BitTorrent_client))
brew list --cask transmission >/dev/null || brew install --cask transmission



## 2018-9-6: Install and update [Google Chrome Beta](https://www.google.com/chrome/beta/)
#brew list --cask homebrew/cask-versions/google-chrome-beta >/dev/null || brew install --cask homebrew/cask-versions/google-chrome-beta


## 2018-10-1: Install and update [Telegram](https://en.wikipedia.org/wiki/Telegram_(service))
#+ 2019-11-29: Install Telegram Desktop in favor of Telegram as the latter seems to have one drawback: you cannot use Cmd + <up arrow> to scroll back a screenful of content.
##
#brew list --cask telegram >/dev/null || brew install --cask telegram
brew list --cask telegram-desktop >/dev/null || brew install --cask telegram-desktop
if [[ $(brew outdated | grep -c telegram-desktop) > 0 ]]; then
    if [[ -e '/Applications/Telegram Desktop.app' ]]; then
        rm -rf '/Applications/Telegram Desktop.app'
    fi
    brew reinstall --cask telegram-desktop
fi

## more ...

## 2020-3-26: Install and update [git](https://git-scm.com/)
#+
##
if [[ $(brew outdated | grep -c git) > 0 ]]; then
    brew upgrade git
fi

## 2018-12-10: Install and update [git-lfs](https://git-lfs.github.com)
#+ 2020-3-11: Stop installing git-lfs as it is no longer available.
#+ 2020-7-20: git-lfs is changed from a cask to formula.
##
brew list git-lfs >/dev/null || brew install git-lfs
if [[ $(brew outdated | grep -c git-lfs) > 0 ]]; then
    brew upgrade git-lfs
fi


# 2018-12-20: Install and update [LimeChat](http://limechat.net)
# 2019-2-28: LimeChat is not longer released via Homebrew due to the fact
# the latest version of the software can ONLY be downloaded from Apple's
# App Store.
# brew list --cask limechat >/dev/null || brew install --cask limechat



# 2019-3-5: Install and update [Android Studio](https://developer.android.com/studio)
#
brew list --cask android-studio >/dev/null || brew install --cask android-studio
if [[ $(brew outdated | grep -c android-studio) > 0 ]]; then
    if [[ -e '/Applications/Android Studio.app' ]]; then
        rm -rf '/Applications/Android Studio.app'
    fi
    brew reinstall --cask android-studio
fi

brew list --cask android-file-transfer >/dev/null || brew install --cask android-file-transfer
if [[ $(brew outdated | grep -c android-file-transfer) > 0 ]]; then
    if [[ -e '/Applications/Android File Transfer.app' ]]; then
        rm -rf '/Applications/Android File Transfer.app'
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


# 2019-3-17: Install and update [MacDown](https://macdown.uranusjr.com/)
#
brew list --cask macdown >/dev/null || brew install --cask macdown


# 2019-3-26: Install and update Thunderbird.
#
#brew list --cask thunderbird-beta >/dev/null || brew install --cask thunderbird-beta
brew list --cask thunderbird >/dev/null || brew install --cask thunderbird
if [[ $(brew outdated | grep -c thunderbird) > 0 ]]; then
    if [[ -e '/Applications/Thunderbird.app' ]]; then
        rm -rf '/Applications/Thunderbird.app'
    fi
    brew reinstall --cask thunderbird
fi



# 2019-3-26: Install and update Welly.
#
brew list --cask welly >/dev/null || brew install --cask welly

# 2019-9-29 Install and update Libre Office.
brew list --cask libreoffice > /dev/null || brew install --cask libreoffice
brew list --cask libreoffice-language-pack > /dev/null || brew install --cask libreoffice-language-pack

# 2019-12-1 Install and update Calibre.
brew list --cask calibre >/dev/null || brew install --cask calibre
if [[ $(brew outdated | grep -c calibre) > 0 ]]; then
    if [[ -e '/Applications/calibre.app' ]]; then
        rm -rf '/Applications/calibre.app'
    fi
    brew reinstall --cask calibre
fi


# 2019-12-13 Install and update VLC Player.
brew list --cask vlc || brew install --cask --force vlc
brew list --cask vlc-webplugin || brew install --cask vlc-webplugin
brew list --cask vlcstreamer || brew install --cask --force vlcstreamer

if [[ $(brew outdated | grep -c vlc) > 0 ]]; then
    if [[ -e '/Applications/VLC.app' ]]; then
        rm -rf '/Applications/VLC.app'
    fi
    if [[ -e '/Applications/VLCStreamer.app' ]]; then
        rm -rf '/Applications/VLCStreamer.app'
    fi
    brew reinstall --cask vlc
    brew reinstall --cask vlc-webplugin
    brew reinstall --cask --force vlcstreamer
fi



# 2020-1-7 Install and update Soundflower
brew list --cask soundflower || brew install --cask soundflower

# TODO 2020-2-4 Install and update Mutt
#brew list mutt || brew install mutt
#brew list getmail || brew install getmail

# 2020-2-5 Install and update [NextCloud](https://nextcloud.com)
brew list --cask nextcloud || brew install --cask nextcloud

# 2020-2-5 Install and update [AirDroid](https://www.airdroid.com/)
brew list --cask airdroid || brew install --cask airdroid

## 2020-3-10: Install [CyberDuck](https://cyberduck.io/).
brew list --cask cyberduck >/dev/null || brew install --cask cyberduck

## 2020-3-26: Install [Zoom](https://zoom.us).
#brew list --cask zoomus >/dev/null || brew install --cask zoomus
#if [[ $(brew outdated | grep -c zoomus) > 0 ]]; then
#    if [[ -e /Applications/zoom.us.app ]]; then
#        rm -rf '/Applications/zoom.us.app'
#    fi
#    brew reinstall --cask zoomus
#fi


## 2020-3-28: Install [Wickr](https://wickr.com).
brew list --cask wickrme >/dev/null || brew install --cask wickrme
if [[ $(brew outdated | grep -c wickrme) > 0 ]]; then
    if [[ -e /Applications/WickrMe.app ]]; then
        rm -rf '/Applications/WickrMe.app'
    fi
    brew reinstall --cask wickrme
fi


## 2020-6-11: Install [JDownloader](https://jdownloader.com).
#+ * First install JDK 8 which is required by jDownloader.
##
brew list --cask homebrew/cask-versions/adoptopenjdk8 >/dev/null || brew install --cask homebrew/cask-versions/adoptopenjdk8

brew list --cask jdownloader >/dev/null || brew install --cask jdownloader
if [[ $(brew outdated | grep -c jdownloader) > 0 ]]; then
    if [[ -e '/Applications/jDownloader 2.0.app' ]]; then
        rm -rf '/Applications/jDownloader 2.0.app'
    fi
    if [[ -e '/Applications/JDownloader2.app' ]]; then
        rm -rf '/Applications/JDownloader2.app'
    fi
    brew reinstall --cask jdownloader
fi

## 2020-6-21: Install [Stretchly](https://hovancik.net/stretchly/).
##
brew list --cask stretchly >/dev/null || brew install --cask stretchly


## 2020-6-11: Install [JDownloader](https://jdownloader.com).
#+ * First install JDK 8 which is required by jDownloader.
##
brew list --cask macdjview >/dev/null || brew install --cask macdjview
if [[ $(brew outdated | grep -c MacDjView) > 0 ]]; then
    if [[ -e '/Applications/MacDjView.app' ]]; then
        rm -rf '/Applications/MacDjView.app'
    fi
    brew reinstall --cask macdjview
fi

## 2020-6-23: Install [Skitch]().
brew list --cask skitch >/dev/null || brew install --cask skitch
if [[ $(brew outdated | grep -c skitch) > 0 ]]; then
    if [[ -e '/Applications/Skitch.app' ]]; then
        rm -rf '/Applications/Skitch.app'
    fi
    brew reinstall --cask skitch
fi

## 2020-6-23: Install OpenJDK.
#+ 2020-07-20: Change openjdk from cask to formula.
#+
##
brew list openjdk >/dev/null || brew install openjdk
brew list --cask adoptopenjdk >/dev/null || brew install --cask adoptopenjdk


## 2020-6-23: Install curl.
brew list --cask curl >/dev/null || brew install --cask curl


## 2020-9-28: Install WhatSize.
brew list --cask whatsize >/dev/null || brew install --cask whatsize
if [[ $(brew outdated | grep -c whatsize) > 0 ]]; then
    if [[ -e '/Applications/WhatSize.app' ]]; then
        rm -rf '/Applications/WhatSize.app'
    fi
    brew reinstall --cask whatsize
fi

## 2020-11-1: Install youtube-dl.
brew list youtube-dl >/dev/null || brew install youtube-dl

## 2020-11-9: Install Franz.
# brew list --cask franz >/dev/null || brew install --cask franz
# if [[ $(brew outdated | grep -c franz) > 0 ]]; then
#     if [[ -e '/Applications/Franz.app' ]]; then
#         rm -rf '/Applications/Franz.app'
#     fi
#     brew reinstall --cask franz
# fi

## 2020-11-20: Install [GoPanda](https://pandanet-igs.com).
brew list --cask gopanda >/dev/null || brew install --cask gopanda
if [[ $(brew outdated | grep -c gopanda) > 0 ]]; then
    if [[ -e '/Applications/GoPanda2.app' ]]; then
        rm -rf '/Applications/GoPanda2.app'
    fi
    brew reinstall --cask gopanda
fi


## 2020-11-26: Install [GoPanda](https://pandanet-igs.com).
brew list --cask gopanda >/dev/null || brew install --cask gopanda
if [[ $(brew outdated | grep -c gopanda) > 0 ]]; then
    if [[ -e '/Applications/GoPanda2.app' ]]; then
        rm -rf '/Applications/GoPanda2.app'
    fi
    brew reinstall --cask gopanda
fi

## 2020-12-24: Install [pyglossary](https://github.com/ilius/pyglossary).
brew list pygobject3 >/dev/null || brew install pygobject3
brew list gtk+3 >/dev/null || brew install --cask gtk+3


## 2020-12-31: Install [ocrmypdf](https://github.com/jbarlow83/OCRmyPDF)
brew list ocrmypdf >/dev/null || brew install ocrmypdf
brew list tesseract-lang >/dev/null || brew install tesseract-lang

## 2021-11-20: Install [TeamViewer](https://www.teamviewer.com).
brew list --cask teamviewer >/dev/null || brew install --cask teamviewer
if [[ $(brew outdated | grep -c teamviewer) > 0 ]]; then
    if [[ -e '/Applications/TeamViewer.app' ]]; then
        rm -rf '/Applications/TeamViewer.app'
    fi
    brew reinstall --cask teamviewer
fi

################################################################################
## 2021-1-20: Install exiftool.
brew list exiftool >/dev/null || brew install exiftool

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
