__author__ = 'meng'

import logging
from WolframAlpha import WolframAlpha

logger = logging.getLogger()
#logger.setLevel(logging.DEBUG)
logger.setLevel(logging.INFO)

# create console handler and set level to debug
ch = logging.StreamHandler()
#ch.setLevel(logging.DEBUG)
ch.setLevel(logging.INFO)

if __name__ == "__main__":
    WolframAlpha.main()
