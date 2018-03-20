TEMPLATE_DIR=ieee
TEMPLATE=templates/${TEMPLATE_DIR}/template.latex
CSL_FILE=templates/${TEMPLATE_DIR}/bibliography.csl
LANG=en-GB
CLASS=article
SOURCES_DIR=sources
EXAMPLE_DIR=example
BUILD_DIR=build
BIBLIO:=biblio.bib
FILENAME_WITHOUT_EXTENSION=document
MD_FILE:=${FILENAME_WITHOUT_EXTENSION}.md
TEX_FILE=${FILENAME_WITHOUT_EXTENSION}.tex
PANDOC_OPTIONS:= --number-sections  -V lang=${LANG} --listings --filter pandoc-fignos --variable pagestyle=headings --variable links-as-notes=true --highlight-style=zenburn --variable biblio-style=alphabetic --variable documentclass=${CLASS} --toc --variable papersize=a4paper -f markdown -s --biblatex
LUALATEX_OPTIONS:=--output-format=pdf --jobname ${FILENAME_WITHOUT_EXTENSION} --interaction nonstopmode --halt-on-error

all : latex pdf
example : example-build pdf

install :
	mkdir -p  pandoc build
	wget -c https://github.com/jgm/pandoc/releases/download/2.1.2/pandoc-2.1.2-linux.tar.gz
	tar xvzf pandoc-2.1.2-linux.tar.gz --strip-components 1 -C ./pandoc/
	sudo pip install pandoc-fignos

example-build :
	mkdir -p build
	rm -fr `pwd`/${BUILD_DIR}/images
	rm -fr `pwd`/${BUILD_DIR}/${BIBLIO}
	ln -s `pwd`/${EXAMPLE_DIR}/${BIBLIO} `pwd`/${BUILD_DIR}/${BIBLIO}
	ln -s `pwd`/${EXAMPLE_DIR}/images `pwd`/${BUILD_DIR}/images
	PATH=./pandoc/bin:$$PATH; (cd ${EXAMPLE_DIR} && pandoc ${MD_FILE} ${PANDOC_OPTIONS} --csl={CSL_FILE} --filter=../filters/pandoc-svg.py --template=../${TEMPLATE} --bibliography ${BIBLIO} -o ../${BUILD_DIR}/${TEX_FILE})

latex :
	mkdir -p build
	rm -fr `pwd`/${BUILD_DIR}/images
	rm -fr `pwd`/${BUILD_DIR}/${BIBLIO}
	ln -s `pwd`/${SOURCES_DIR}/${BIBLIO} `pwd`/${BUILD_DIR}/${BIBLIO}
	ln -s `pwd`/${SOURCES_DIR}/images `pwd`/${BUILD_DIR}/images
	PATH=./pandoc/bin:$$PATH; (cd ${SOURCES_DIR} && pandoc ${MD_FILE} ${PANDOC_OPTIONS} --csl={CSL_FILE} --filter=../filters/pandoc-svg.py --template=../${TEMPLATE} --bibliography ${BIBLIO} -o ../${BUILD_DIR}/${TEX_FILE})

pdf :
	(cd ${BUILD_DIR} && lualatex ${LUALATEX_OPTIONS} ${TEX_FILE})
	(cd ${BUILD_DIR} && biber ${FILENAME_WITHOUT_EXTENSION})
	(cd ${BUILD_DIR} && lualatex ${LUALATEX_OPTIONS} ${TEX_FILE} )

print :
	(cd ${BUILD_DIR} && cat ${TEX_FILE})
	(cd ${BUILD_DIR} && xdg-open ${FILENAME_WITHOUT_EXTENSION}.pdf)

clean :
	rm -fr build/*

dockerimage :
	docker rmi nnynn/m2latex-pandoc || true
	(cd docker && docker build -t nnynn/m2latex-pandoc .)

dockerbuild:
	docker run --rm -v `pwd`/Makefile:/latex/Makefile -v `pwd`:/latex nnynn/m2latex-pandoc /bin/sh -c "(cd latex && make all && chmod -R 777 ${BUILD_DIR})"
	(cd ${BUILD_DIR} && xdg-open ${FILENAME_WITHOUT_EXTENSION}.pdf &)

dockerexample :
	docker run --rm -v `pwd`/Makefile:/latex/Makefile -v `pwd`:/latex nnynn/m2latex-pandoc /bin/sh -c "(cd latex && make example && chmod -R 777 ${BUILD_DIR})"
	(cd ${BUILD_DIR} && xdg-open ${FILENAME_WITHOUT_EXTENSION}.pdf &)
