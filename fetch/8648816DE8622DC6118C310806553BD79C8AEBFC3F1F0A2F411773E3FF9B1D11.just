url_prefix := "localhost:3030/api/v1"
index := "1"

books:
    curl -s {{url_prefix}}/books | json

add_book:
	curl {{url_prefix}}/books -X POST -d '{"title":"Game of Thrones", "author": "George R.R. Martin", "status":"Reading"}' -H "Content-Type: application/json"
update_book:
    curl {{url_prefix}}/books/1 -X PUT -d '{"status":"Finished"}' -H "Content-type: application/json"

# $ just index=2 delete_book
delete_book:
    curl {{url_prefix}}/books/{{index}} -X DELETE
# $ just delete 3
delete ID:
    curl {{url_prefix}}/books/{{ID}} -X DELETE

db_info:
    echo $DATABASE_URL
    dotenv run diesel print-schema



