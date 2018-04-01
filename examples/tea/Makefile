
PAPER+= A4
PAPER+= letter

MODES+= xhtml
.if defined(DEBUG)
MODES+= debug
.endif

MDB?= ../../share

PATHS+= .
PATHS+= ${MDB}/tex
PATHS+= ${MDB}/type
PATHS+= ${MDB}/canon
PATHS+= ${MDB}/env

ENVS+= secret
ENVS+= common/main
ENVS+= tea

.for paper in ${PAPER}

all:: tea-${paper}.pdf

tea-${paper}.pdf: tea.tex
	OSOFONTDIR=. \
	context --batchmode --nonstopmode \
		--result=${.TARGET} \
		--file-line-error --halt-on-error \
		--path=${PATHS:ts,} \
		--environment=${ENVS:ts,} \
		--mode=${paper},${MODES:ts,} \
	--forcexml tea.xhtml

.endfor

