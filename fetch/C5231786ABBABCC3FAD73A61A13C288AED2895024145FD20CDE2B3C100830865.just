rcol color1 color2:
	grep -rl '#{{color1}}' $PWD | xargs sed -i 's/#{{color1}}/#{{color2}}/g'
