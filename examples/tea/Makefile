
MODES+= xhtml
MODES+= A4
.if defined(DEBUG)
MODES+= debug
.endif

MDB?= ../..

PATHS+= .
PATHS+= ${MDB}/tex
PATHS+= ${MDB}/type
PATHS+= ${MDB}/canon
PATHS+= ${MDB}/env

ENVS+= secret
ENVS+= common/main
ENVS+= tea

tea.pdf: tea.tex
	OSOFONTDIR=. \
	context --batchmode --nonstopmode \
		--file-line-error --halt-on-error \
		--path=${PATHS:ts,} \
		--environment=${ENVS:ts,} \
		--mode=${MODES:ts,} \
	--forcexml tea.xhtml

