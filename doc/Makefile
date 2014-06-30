all: design.pdf design.png

design.pdf: design.gv
	dot -Tpdf -odesign.pdf design.gv

design.png: design.gv
	dot -Tpng -odesign.png design.gv
