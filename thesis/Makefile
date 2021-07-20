EXEC = xelatex
GLOSS = makeglossaries
BIB = bibtex

.PHONY : all view

all : maxwell2019thesis-bcs.pdf clean view

maxwell2019thesis-bcs.pdf : maxwell2019thesis-bcs.tex chapters/* chapters/*/* figures/* phd.cls
	$(EXEC) maxwell2019thesis-bcs.tex
	$(BIB) maxwell2019thesis-bcs
	$(GLOSS) maxwell2019thesis-bcs
	$(EXEC) maxwell2019thesis-bcs
	$(EXEC) maxwell2019thesis-bcs
	$(EXEC) maxwell2019thesis-bcs

view :
	open maxwell2019thesis-bcs.pdf

clean :
	rm -f maxwell2019thesis-bcs.acn
	rm -f maxwell2019thesis-bcs.acr
	rm -f maxwell2019thesis-bcs.alg
	rm -f maxwell2019thesis-bcs.aux
	rm -f maxwell2019thesis-bcs.blg
	rm -f maxwell2019thesis-bcs.brf
	rm -f maxwell2019thesis-bcs.glg
	rm -f maxwell2019thesis-bcs.glo
	rm -f maxwell2019thesis-bcs.gls
	rm -f maxwell2019thesis-bcs.ist
	rm -f maxwell2019thesis-bcs.lof
	rm -f maxwell2019thesis-bcs.log
	rm -f maxwell2019thesis-bcs.lot
	rm -f maxwell2019thesis-bcs.out
	rm -f maxwell2019thesis-bcs.synctex.gz
	rm -f maxwell2019thesis-bcs.toc