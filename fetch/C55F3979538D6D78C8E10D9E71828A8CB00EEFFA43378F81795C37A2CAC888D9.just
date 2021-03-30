DATE := `date "+%b%Y"`
JOBNAME := "AdrianBergesCV_" + DATE

all:
	xelatex \
		-output-directory="./aux" \
		src/cv.tex
	mv ./aux/cv.pdf ./{{JOBNAME}}.pdf


get-fonts:
	sudo apt install fonts-vollkorn fonts-open-sans
