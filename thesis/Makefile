EXEC = xelatex
GLOSS = makeglossaries
BIB = bibtex

.PHONY : all view

all : maxwell2018thesis.pdf clean view

maxwell2018thesis.pdf : maxwell2018thesis.tex chapters/* chapters/*/* figures/* phd.cls
	$(EXEC) maxwell2018thesis.tex
	$(BIB) maxwell2018thesis
	$(GLOSS) maxwell2018thesis
	$(EXEC) maxwell2018thesis
	$(EXEC) maxwell2018thesis

view :
	open maxwell2018thesis.pdf

clean :
	rm -f maxwell2018thesis.acn
	rm -f maxwell2018thesis.acr
	rm -f maxwell2018thesis.alg
	rm -f maxwell2018thesis.aux
	rm -f maxwell2018thesis.blg
	rm -f maxwell2018thesis.brf
	rm -f maxwell2018thesis.glg
	rm -f maxwell2018thesis.glo
	rm -f maxwell2018thesis.gls
	rm -f maxwell2018thesis.ist
	rm -f maxwell2018thesis.lof
	rm -f maxwell2018thesis.log
	rm -f maxwell2018thesis.lot
	rm -f maxwell2018thesis.out
	rm -f maxwell2018thesis.synctex.gz
	rm -f maxwell2018thesis.toc