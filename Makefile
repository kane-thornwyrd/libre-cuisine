#####################################################################################################
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>
#
####################################################################################################


####################################################################################################
# Configuration
####################################################################################################

# Build configuration

BUILD = pages
MAKEFILE = Makefile
OUTPUT_FILENAME = index
METADATA = metadata.yml
CHAPTERS = content/*.md
TOC = --toc --toc-depth 2
METADATA_ARGS = --shift-heading-level-by=1 --metadata-file $(METADATA)
IMAGES = images
COVER_IMAGE = images/cover.png
MATH_FORMULAS = --webtex

# Chapters content
CONTENT = awk 'FNR==1 && NR!=1 {print "\n<hr />\n"}{print}' $(CHAPTERS)
CONTENT_FILTERS = tee # Use this to add sed filters or other piped commands

FILTER_ARGS = --filter pandoc-sidenote

# Combined arguments

ARGS = $(TOC) $(MATH_FORMULAS) $(METADATA_ARGS) $(FILTER_ARGS) $(DEBUG_ARGS)
	
PANDOC_COMMAND = pandoc


HTML_ARGS = --template templates/html.html --standalone --to html5

# Per-format file dependencies

BASE_DEPENDENCIES = $(MAKEFILE) $(CHAPTERS) $(METADATA) $(IMAGES)
HTML_DEPENDENCIES = $(BASE_DEPENDENCIES)

####################################################################################################
# Basic actions
####################################################################################################

all:	html

clean:
	rm -r $(BUILD)

####################################################################################################
# File builders
####################################################################################################

html:	$(BUILD)/$(OUTPUT_FILENAME).html

$(BUILD)/$(OUTPUT_FILENAME).html:	$(HTML_DEPENDENCIES)
	mkdir -p $(BUILD)
	$(CONTENT) | $(CONTENT_FILTERS) | $(PANDOC_COMMAND) $(ARGS) $(HTML_ARGS) -o $@
# 	cp --parent $(IMAGES) $(BUILD)/
	@echo "$@ was built"
