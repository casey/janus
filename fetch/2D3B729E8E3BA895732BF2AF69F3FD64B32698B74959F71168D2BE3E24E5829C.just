jar_name = "financialskill"
current_version = "0.2.0"
extension = "jar"

final_name = jar_name + "-" +  current_version + "." + extension

path = "build/libs"

full_name = path + "/" + final_name

jar:
    @gradle jar
    @md5 {{full_name}}