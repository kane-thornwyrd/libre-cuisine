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
