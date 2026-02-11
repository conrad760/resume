FILENAME=resume
PHONE_NUMBER ?= PHONE\_NUMBER

all: $(FILENAME).pdf

$(FILENAME).pdf: $(FILENAME).tex
	sed 's/PHONE\\_NUMBER/$(PHONE_NUMBER)/' $(FILENAME).tex > $(FILENAME)_build.tex
	pdflatex $(FILENAME)_build.tex
	pdflatex $(FILENAME)_build.tex
	mv $(FILENAME)_build.pdf $(FILENAME).pdf
	rm -f $(FILENAME)_build.*

watch:
	latexmk -pdf -pvc -interaction=nonstopmode $(FILENAME).tex

clean:
	rm -f *.aux *.log *.out *.pdf *.fls *.fdb_latexmk *_build.*

.PHONY: all watch clean
