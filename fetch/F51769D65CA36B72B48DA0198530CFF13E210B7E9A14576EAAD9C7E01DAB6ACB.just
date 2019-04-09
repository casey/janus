start:
	npm run dev

server:
	node server.js

sign kv:
	node service/case/jwt.js {{kv}}

# settings
import coll:
	node service/migration/yml-to-collection.js {{coll}}.yml

migrate:
	node service/migration/index.js ${HOME}/arangodb/imtrack.json

prod-migrate:
	node service/migration/index.js /opt/arangodb/imtrack.json

prod-pm2:
	pm2 start service/index.js --name imtrack2-service
	pm2 start npm --name imtrack2 -- run start

db:
	docker run --rm -d \
			-p 8533:8529 \
			-e "ARANGO_ROOT_PASSWORD=123123" \
			-v $HOME/arangodb/database:/var/lib/arangodb3 \
			--name imtrack-v2-db \
			arangodb:3.4.4

dbClean:
	node service/migration/deleteCollection.js

dbReset: dbClean migrate

docs:
	docker run --rm -p 4000:8080 -v `pwd`/docs:/docs vuepress vuepress dev /docs

buildDocs:
	docker run --rm -v `pwd`/docs:/docs vuepress vuepress build /docs

doc:
	npx vuepress dev -p 3002 docs

buildDoc:
	npx vuepress build docs


deploy-modules user="fitoe" target="192.168.10.241" path="documents/imtrackv2":
	tar zcf - node_modules | ssh {{user}}@{{target}} 'cd /home/{{user}}/{{path}} && tar zxvf -'
