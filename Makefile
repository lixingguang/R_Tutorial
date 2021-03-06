REXE = R --vanilla
RSCRIPT = Rscript --vanilla
RCMD = $(REXE) CMD
PDFLATEX = pdflatex
BIBTEX = bibtex
MAKEIDX = makeindex
CP = cp
RM = rm -f

FILES = tutorial.html tutorial.R Intro1.R Intro2.R hurricanes.csv ChlorellaGrowth.csv seedpred.dat munging.html munging.R viz.html viz.R

default: $(FILES)
	cp tutorial.html index.html

%.html: %.Rmd
	PATH=/usr/lib/rstudio/bin/pandoc:$$PATH \
	Rscript --vanilla -e "rmarkdown::render(\"$*.Rmd\",output_format=\"html_document\")"

%.html: %.md
	PATH=/usr/lib/rstudio/bin/pandoc:$$PATH \
	Rscript --vanilla -e "rmarkdown::render(\"$*.md\",output_format=\"html_document\")"

%.R: %.Rmd
	Rscript --vanilla -e "library(knitr); purl(\"$*.Rmd\",output=\"$*.R\",documentation=2)"

%.tex: %.Rnw
	$(RSCRIPT) -e "library(knitr); knit(\"$*.Rnw\")"

%.pdf: %.tex
	$(PDFLATEX) $*
	-$(BIBTEX) $*
	$(PDFLATEX) $*
	$(PDFLATEX) $*

clean:
	$(RM) *.log *.blg *.ilg *.aux *.lof *.lot *.toc *.idx
	$(RM) *.ttt *.fff *.out *.nav *.snm
	$(RM) *.o *.so *.bak *~
	$(RM) *-concordance.tex *.synctex.gz *.knit.md *.utf8.md
	$(RM) *.brf
	$(RM) Rplots.*

fresh: clean
	$(RM) *.ps *.bbl *.ind *.dvi
	$(RM) -r cache figure
	$(RM) -r *_cache *_files
