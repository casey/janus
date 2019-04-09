add LANG:
	mkdir {{LANG}}
	echo "[{{LANG}}](/{{LANG}}/)" >> cover.md
	echo "# The {{LANG}} Programming Language" >> {{LANG}}/README.md
	touch {{LANG}}/_sidebar.md

page LANG PAGE:
	echo "[{{PAGE}}](/{{LANG}}/{{PAGE}}/)" >> {{LANG}}/_sidebar.md
	echo "# {{PAGE}}" >> {{LANG}}/{{PAGE}}.md
