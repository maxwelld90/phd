EXEC = xelatex
GLOSS = makeglossaries
BIB = bibtex

.PHONY : all view

all : maxwell2019thesis.pdf clean view

maxwell2019thesis.pdf : maxwell2019thesis.tex chapters/* chapters/*/* figures/* phd.cls
	$(EXEC) maxwell2019thesis.tex
	$(BIB) maxwell2019thesis
	$(GLOSS) maxwell2019thesis
	$(EXEC) maxwell2019thesis
	$(EXEC) maxwell2019thesis
	$(EXEC) maxwell2019thesis

view :
	open maxwell2019thesis.pdf

clean :
	rm -f maxwell2019thesis.acn
	rm -f maxwell2019thesis.acr
	rm -f maxwell2019thesis.alg
	rm -f maxwell2019thesis.aux
	rm -f maxwell2019thesis.blg
	rm -f maxwell2019thesis.brf
	rm -f maxwell2019thesis.glg
	rm -f maxwell2019thesis.glo
	rm -f maxwell2019thesis.gls
	rm -f maxwell2019thesis.ist
	rm -f maxwell2019thesis.lof
	rm -f maxwell2019thesis.log
	rm -f maxwell2019thesis.lot
	rm -f maxwell2019thesis.out
	rm -f maxwell2019thesis.synctex.gz
	rm -f maxwell2019thesis.toc