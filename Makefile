OUTDIR=out
OBJDIR=obj
SRCDIR=src

TARGETS:=$(patsubst %.org,%.pdf,$(wildcard ${SRCDIR}/*.org))
TARGETS:=$(subst ${SRCDIR},${OUTDIR},${TARGETS})

TEXFLAGS=-halt-on-error --output-directory=${OBJDIR}

.phony: all dir clean

all: ${TARGETS}

${OUTDIR}/%.pdf: ${OBJDIR}/%.tex
	TEXINPUTS=./${SRCDIR}:${TEXINPUTS} pdflatex ${TEXFLAGS} $<
	mv $(<:.tex=.pdf) $@

${OBJDIR}/%.tex: ${SRCDIR}/%.org dir
	emacs $< --batch --load=export.el -f org-latex-export-to-latex --kill
	mv $(<:.org=.tex) $@

dir:
	mkdir -p ${OUTDIR}
	mkdir -p ${OBJDIR}
	ln -sfv ${SRCDIR}/img img

clean:
	rm -rf ${OBJDIR}
	rm -rf ${OUTDIR}
	rm -f img
