#!/usr/bin/env bash

## Summary: Start Apache2 server
#+ Author: Meng Lu <meng@woflram.com>
#+ Date: 201502
#+
#+ ## References:
#+ * http://httpd.apache.org/docs/2.0/stopping.html
##

if [ `uname -s` == 'Darwin' ] && [ -e /usr/local/apache2/bin/apachectl ]; then
    sudo /usr/local/apache2/bin/apachectl -k restart
elif [ -e /usr/sbin/apachectl ]; then
	sudo /usr/sbin/apachectl -k restart
else
	exit 1
fi

## END
