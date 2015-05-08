COMMON=common
BUILD=build
HTML=html
SRCDIRS=1-MongoDB

TEX=`which tex`
LATEX=`which latex`
BIBTEX=`which bibtex`
DVIPS=`which dvips`
PS2PDF=`which ps2pdf`
PDFLATEX=`which pdflatex`
DVIPSOPT=-t a4

COMMONFILES=	${COMMON}/aueb.eps \
		${COMMON}/Unix.bib 
			
.PHONY: structure clean distclean
			
all:	prepare ${SRCDIRS}

1-MongoDB: ${BUILD}/1-MongoDB.pdf

$(BUILD)/%.pdf: $(BUILD)/%.tex
	@echo Compiling $* ;
	@cd $(BUILD) && \
	 $(PDFLATEX) $*.tex ;\
	 $(PDFLATEX) $*.tex
	@cp -v $(BUILD)/$*.pdf $*

$(BUILD)/%.bbl: $(BUILD)/Unix.bib
	@echo Invoke bibtex
	-@cd $(BUILD) && \
	$(BIBTEX) $* ;\
	$(LATEX) $*.tex  ;\
	$(LATEX) $*.tex

prepare:
	@echo Preparing build directory
	@-mkdir $(BUILD)
	@-mkdir $(HTML)
	@for dir in $(SRCDIRS); \
	do \
		echo What to copy from $$dir ? ; \
		for file in $$dir/*; \
		do \
			echo Copy file $${file##*/} ? ; \
			if [[ $$file -nt $(BUILD)/$${file##*/} ]]; \
			then \
				cp -v $$file $(BUILD) ; \
				echo Copied $${file##*/} ; \
			fi \
		done \
	done
	@for filen in $(COMMONFILES); \
	do \
		cp -v $$filen $(BUILD) ; \
	done
	@cp -v $(COMMON)/index.md $(HTML)/index.md


html: all
	@./makehtml.sh $(HTML)

clean:
	@echo Cleaning up
	@-rm -R $(BUILD)
	@-rm -R $(HTML)
	
distclean: clean
	find . -type f -name lab*.pdf |xargs rm
	find . -type f -name .DS_Store |xargs rm
	find . -type f |grep *~|xargs rm
