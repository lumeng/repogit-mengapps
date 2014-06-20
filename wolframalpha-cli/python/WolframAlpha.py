# -*- coding: utf-8 -*-

"""CLI to query wolframalpha.com via its API."""

import sys

if sys.version_info[0] != 2 or sys.version_info[1] < 7:
    sys.exit("Python 2.7 or newer is required to run this program.")

import urllib
import urllib2
import re
import logging
from xml.etree import ElementTree
import argparse


class WolframAlpha:

    WOLFRAMALPHA_HOSTS = [
        ('default', 'http://www.wolframalpha.com/api/v2/query?')
    ]

    def __init__(self, my_app_id):
        self.app_id = my_app_id
        #print self.app_id
        self.base_url = WolframAlpha.WOLFRAMALPHA_HOSTS[0][-1]
        #print self.base_url
        self.headers = {'User-Agent': None}
        self.query = ''
        self.xml = ''
        self.xml_parsed = ''
        self.parser_obj = ''

    def _get_xml(self, input_query):
        try:
            url_params = {
                'input': input_query.encode('utf-8'),
                'appid': self.app_id,
                'async': 'false',
                'scantimeout': 100
            }
            data = urllib.urlencode(url_params)
            req = urllib2.Request(self.base_url, data, self.headers)
            #print req
            self.xml = urllib2.urlopen(req).read()
            #print self.xml
            tree = ElementTree.fromstring(self.xml)
            logging.debug("tree.attrib['success'] = %s", tree.attrib['success'])
            if tree is not None and tree.attrib['success'] == 'true':
                print("query successful!")
            else:
                sys.exit("Query unsuccessful! Check server availability and app ID validity.")
        except UnicodeDecodeError:
            print "_get_xml(self, ip): Non-ASCII detected for _get_xml. Consider using encoding function."
        except IOError:
            print "_get_xml(self, ip): IOerror from the urllib as urlopen failed"

    def _xml_parser(self, xml):
        data_dict = {}
        tree = ElementTree.fromstring(xml)
        # retrieving every tag with label 'plaintext'
        for e in tree.findall('pod'):
            for item in [ef for ef in list(e) if ef.tag == 'subpod']:
                for it in [i for i in list(item) if i.tag == 'plaintext']:
                    if it.tag == 'plaintext':
                        data_dict[e.get('title')] = self._decode_wolfram_longname(it.text)
        return data_dict

    @staticmethod
    def _decode_wolfram_longname(input_query):
        """_decode_wolfram_longname convert Wolfram Language long name \:XYZU to proper Unicode character"""
        if input_query is None:
            return "Not available as textual output"
        else:
            data = re.sub("\\\\:[0-9A-Fa-f]{4}", WolframAlpha._wolfram_longname_replacement,
                          input_query).split('<DELIMITER/>')
            return "".join(map(WolframAlpha._alpha_unicode_char, data))

    @staticmethod
    def _wolfram_longname_replacement(match):
        """helper for unicode character matching"""
        match = match.group()
        return '<DELIMITER/>0x' + match[2:] + '<DELIMITER/>'

    @staticmethod
    def _alpha_unicode_char(input_query):
        """converts hex into unicode"""
        matches = re.match("0x", input_query)
        if matches is not None:
            return unichr(int(input_query[2:], 16))
        else:
            return input_query

    def search(self, current_query, print_q=True, update_q=False):
        if update_q or current_query != self.query:
            self.query = current_query
            # a control to update cpe information
            self._get_xml(self.query)
            try:
                self.xml_parsed = self._xml_parser(self.xml)
            except ElementTree.ParseError:
                print "issue with the xml data passed into search()"

            if print_q:
                try:
                    pod_titles = dict.keys(self.xml_parsed)
                    pod_ids = dict(zip(map(str, range(1, len(pod_titles)+1)), pod_titles))
                    for e in sorted(pod_ids.keys(), key=lambda x: int(x)):
                        print "  {}) {}".format(e, pod_ids[e])
                except TypeError:
                    print "failed to pass xml into search method. check url or vpn connection"

    @staticmethod
    def main():

        parser = argparse.ArgumentParser(description='ADD YOUR DESCRIPTION HERE')
        parser.add_argument('-q', '--query', help='Input your query to ask  Wolfram|Alpha: ', required=False)
        parser.add_argument('-i', '--appid', help='Input your app ID (apply http://j.mp/1nRRoHc): ', required=False)
        args = parser.parse_args()

        logging.debug("args.query: %s", args.query)
        logging.debug("args.appid: %s", args.appid)

        if args.query is None:
            query = raw_input("Type your input query: ").decode(sys.stdin.encoding)
        else:
            query = args.query

        print 'Sending query to wolframalpha.com: ', query
        w = WolframAlpha(args.appid)
        w.search(query)
        result_dicts = w.xml_parsed
        pod_titles = dict.keys(result_dicts)
        title_ids = dict(zip(map(str, range(1, len(pod_titles)+1)), pod_titles))
        try_again_q = True

        while try_again_q:
            s = raw_input('Choose pod (\'q\' to quit): ').decode(sys.stdin.encoding)
            if s == 'quit' or s == 'q':
                sys.exit(1)
            while (s not in pod_titles) and (s not in title_ids.keys()):
                if s == 'quit' or s == 'q':
                    try_again_q = False
                else:
                    print 'Invalid pod'
                    s = raw_input('Choose pod: ').decode(sys.stdin.encoding)
            if s in pod_titles:
                print result_dicts[s]
            else:
                print result_dicts[title_ids[s]]
        print '\nTerminate the query'



