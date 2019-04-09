default:
	just --list

render:
	dot -Tpng -Gdpi=300 boot.dot -o boot.png && open boot.png

increment:
	perl -pi -e 's/>(\d+)</">".(1+$1)."<"/ge' index.html
