FILENAME=resume

all: $(FILENAME).pdf

$(FILENAME).pdf: $(FILENAME).tex
ifdef PHONE_NUMBER
	sed 's/PHONE\\_NUMBER/$(PHONE_NUMBER)/' $(FILENAME).tex > $(FILENAME)_build.tex
else
	cp $(FILENAME).tex $(FILENAME)_build.tex
endif
	pdflatex $(FILENAME)_build.tex
	pdflatex $(FILENAME)_build.tex
	mv $(FILENAME)_build.pdf $(FILENAME).pdf
	rm -f $(FILENAME)_build.*

preview: $(FILENAME).pdf
	pdftoppm -png -r 300 -singlefile $(FILENAME).pdf $(FILENAME)

watch:
	latexmk -pdf -pvc -interaction=nonstopmode $(FILENAME).tex

clean:
	rm -f *.aux *.log *.out *.pdf *.fls *.fdb_latexmk *_build.*

.PHONY: all preview watch clean
