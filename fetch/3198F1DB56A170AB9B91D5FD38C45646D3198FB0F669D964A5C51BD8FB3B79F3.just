cname 		= "moh.page"
rep 		= "abstractum.io"

postdir 	= "./src/views/posts/"
projdir 	= "./src/views/proj/"
gamedir 	= "./src/views/games/"
sktdir 		= "./src/views/skt/"

rpostdir 	= "./views/posts/"
rprojdir 	= "./views/proj/"
rgamedir 	= "./views/games/"
rsktdir 	= "./views/skt/"

jpostdir 	= "./src/assets/json/blog.json"
jprojdir 	= "./src/assets/json/proj.json"
jgamedir 	= "./src/assets/json/game.json"
jsktdir 	= "./src/assets/json/sket.json"

rter 		= "./src/router.ts"
mdpt 		= "./src/components/mdown.vue"

mdir 		= "@/assets/md/"
sdir 		= "@/assets/skt/"
date 		= `date | sed -n '1p'|awk '{print $3" "$4}'`

deploy:
    yarn run build
    cp -rf ./dist ~/ws/.term/dist
    cp ~/ws/.conf/fr/just/dep ~/ws/.term/dist/
    mv ~/ws/.term/dist/dep ~/ws/.term/dist/justfile
    echo {{cname}} >> ~/ws/.term/dist/CNAME
    rm -rf ./dist
    (cd ~/ws/.term/dist && just deploy {{rep}})
    rm -rf ~/ws/.term/dist

@post file id='100' title='title':
	cp ~/ws/.conf/fr/vue/post.vue {{postdir}}
	mv {{postdir}}post.vue {{postdir}}{{file}}.vue
	sed -i '' "s/{{ "{{" }}name}}/{{file}}/g" {{postdir}}{{file}}.vue
	echo "{{file}}.vue created"
	gsed -i '/^\/\/posts.imp$/ s:$:\nimport\ {{file}}\ from\ \"{{rpostdir}}{{file}}.vue\"\;:' {{rter}} 
	gsed -i '/^        \/\/posts.path$/ s:$:\n\        {\ path\: \"\/blog\/{{file}}\"\,\  name\: \"{{file}}\"\,\ component\:\ {{file}}\ }\,:' {{rter}} 
	echo "{{file}} route created"
	gsed -i '/^\/\/mdsrc$/ s:$:\nimport\ {{file}}\ from\ \"{{mdir}}blog\/{{file}}.md\"\;:' {{mdpt}} 
	gsed -i '/^        \/\/mdcomp$/ s:$:\n        {{file}}\,:' {{mdpt}} 
	echo "{{file}}.md route sourced"
	touch ./src/assets/md/blog/{{file}}.md
	gsed -i '/^\[$/ s:$:\n\    {\ \"id\"\:\ \"{{id}}\"\,\ \"date\"\:\ \"\{{date}}\", \"t\"\:\ \"{{title}}\"\,\ \"to\"\:\ \"\/blog\/{{file}}\"\ \}\,:' {{jpostdir}}
	echo "{{file}} page attached"
	echo "# New Post" > ./src/assets/md/blog/{{file}}.md


@game file id='100' title='title':
	cp ~/ws/.conf/fr/vue/post.vue {{gamedir}}
	echo "{{file}}.vue created"
	mv {{gamedir}}post.vue {{gamedir}}{{file}}.vue
	sed -i '' "s/{{ "{{" }}name}}/{{file}}/g" {{gamedir}}{{file}}.vue
	gsed -i '/^\/\/games.imp$/ s:$:\nimport\ {{file}}\ from\ \"{{rgamedir}}{{file}}.vue\"\;:' {{rter}} 
	echo "{{file}} route created"
	gsed -i '/^        \/\/games.path$/ s:$:\n\        {\ path\: \"\/games\/{{file}}\"\,\  name\: \"{{file}}\"\,\ component\:\ {{file}}\ }\,:' {{rter}} 
	gsed -i '/^\/\/mdsrc$/ s:$:\nimport\ {{file}}\ from\ \"{{mdir}}games\/{{file}}.md\"\;:' {{mdpt}} 
	gsed -i '/^        \/\/mdcomp$/ s:$:\n        {{file}}\,:' {{mdpt}} 
	echo "{{file}}.md route sourced"
	touch ./src/assets/md/games/{{file}}.md
	gsed -i '/^\[$/ s:$:\n\    {\ \"id\"\:\ \"{{id}}\"\,\ \"date\"\:\ \"\{{date}}\", \"t\"\:\ \"{{title}}\"\,\ \"to\"\:\ \"\/games\/{{file}}\"\ \}\,:' {{jgamedir}}
	echo "{{file}} page attached"
	echo "# New Post" > ./src/assets/md/games/{{file}}.md

@proj file id='100' title='title':
	cp ~/ws/.conf/fr/vue/post.vue {{projdir}}
	mv {{projdir}}post.vue {{projdir}}{{file}}.vue
	echo "{{file}}.vue created"
	sed -i '' "s/{{ "{{" }}name}}/{{file}}/g" {{projdir}}{{file}}.vue
	gsed -i '/^\/\/projs.imp$/ s:$:\nimport\ {{file}}\ from\ \"{{rprojdir}}{{file}}.vue\"\;:' {{rter}} 
	gsed -i '/^        \/\/projs.path$/ s:$:\n\        {\ path\: \"\/projects\/{{file}}\"\,\  name\: \"{{file}}\"\,\ component\:\ {{file}}\ }\,:' {{rter}} 
	echo "{{file}} route created"
	gsed -i '/^\/\/mdsrc$/ s:$:\nimport\ {{file}}\ from\ \"{{mdir}}projects\/{{file}}.md\"\;:' {{mdpt}} 
	gsed -i '/^        \/\/mdcomp$/ s:$:\n        {{file}}\,:' {{mdpt}} 
	echo "{{file}}.md route sourced"
	touch ./src/assets/md/projects/{{file}}.md
	gsed -i '/^\[$/ s:$:\n\    {\ \"id\"\:\ \"{{id}}\"\,\ \"date\"\:\ \"\{{date}}\", \"t\"\:\ \"{{title}}\"\,\ \"to\"\:\ \"\/projects\/{{file}}\"\ \}\,:' {{jprojdir}}
	echo "{{file}} page attached"
	echo "# New Post" > ./src/assets/md/projects/{{file}}.md

@skt file src id='100' title='title':
	cp ~/ws/.conf/fr/vue/sk.vue {{sktdir}}
	mv {{sktdir}}sk.vue {{sktdir}}{{file}}.vue
	echo "{{file}}.vue created"
	sed -i '' "s/{{ "{{" }}name}}/{{file}}/g" {{sktdir}}{{file}}.vue
	sed -i '' "s/{{ "{{" }}scode}}/{{src}}/g" {{sktdir}}{{file}}.vue
	gsed -i '/^\/\/skt.imp$/ s:$:\nimport\ {{file}}\ from\ \"{{rsktdir}}{{file}}.vue\"\;:' {{rter}} 
	gsed -i '/^        \/\/skt.path$/ s:$:\n\        {\ path\: \"\/sketch\/{{file}}\"\,\  name\: \"{{file}}\"\,\ component\:\ {{file}}\ }\,:' {{rter}} 
	echo "{{file}} route created"
	touch ./src/assets/ts/{{file}}.ts
	gsed -i '/^\[$/ s:$:\n\    {\ \"id\"\:\ \"{{id}}\"\,\ \"date\"\:\ \"\{{date}}\", \"t\"\:\ \"{{title}}\"\,\ \"to\"\:\ \"\/sketch\/{{file}}\"\ \}\,:' {{jsktdir}}
	echo "{{file}} page attached"
	echo "export default class {{file}} {\n        setup(p:p5) {\n\n}\n        draw(p:p5) {\n\n}\n}" > ./src/assets/ts/{{file}}.ts
