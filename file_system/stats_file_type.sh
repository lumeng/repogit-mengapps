#!/usr/bin/env bash

find . -type f | ack '\.\w+$' -o | sort | uniq -c | sort | tac

## END
