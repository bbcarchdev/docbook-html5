## Author: Mo McRoberts <mo.mcroberts@bbc.co.uk>
##
## Copyright (c) 2014 BBC
##
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##
##      http://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.

all: index.html

XSLT = docbook-html5.xsl \
	block.xsl doc.xsl inline.xsl toc.xsl

XSLTPROC ?= xsltproc

index.html: docbook-html5.xml $(XSLT) res-links.xml res-nav.xml
	$(XSLTPROC) --nonet --xinclude \
    	--param "html.linksfile" "'`pwd`/res-links.xml'" \
		--param "html.navfile" "'`pwd`/res-nav.xml'" \
		--param "html.ie78css" "'http://bbcarchdev.github.io/painting-by-numbers/ie78.css'" \
		--output $@ \
		docbook-html5.xsl $<
