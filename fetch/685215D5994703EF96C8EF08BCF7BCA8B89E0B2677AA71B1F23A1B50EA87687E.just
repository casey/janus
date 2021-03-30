_: just-choose

just-choose:
    #!/usr/bin/env sh
    choose_recipe=$(just --summary | tr ' ' '\n' | /usr/local/opt/choose-gui/bin/choose)
    echo "Choose Recipe: ${choose_recipe}"
    just "${choose_recipe}"

xcode_playground := "./xcode-playground"
ios_singleview_playground_dir := "iOS-SingleView.playground"
transform_bowplayground := "./transform-bowplayground"
ios_singleview_bowplayground_name := "IosSingleView"
markdown_output := "./markdown-output"
jekyll_output := "./jekyll-output"
carbon_output := "./carbon-output"

# iOS Single View : 1 : Open PlayGround by Xcode
open-xcode-playground-iOS-SingleView:
    open "{{xcode_playground}}/{{ios_singleview_playground_dir}}"

# iOS Single View : 2 : Transform PlayGround by nef
nef-playground-transform-iOS-SingleView:
    nef playground --playground "{{xcode_playground}}/{{ios_singleview_playground_dir}}" --output "{{transform_bowplayground}}" --name "{{ios_singleview_bowplayground_name}}" --platform ios

# iOS Single View : 3 : Open Transformed PlayGround by Xcode
open-transformed-playground-iOS-SingleView:
    open "{{transform_bowplayground}}/{{ios_singleview_bowplayground_name}}.app"

# iOS Single View : 4 : Render Markdown for Transformed PlayGround by nef
markdown-transformed-playground-iOS-SingleView:
    nef markdown --project "{{transform_bowplayground}}/{{ios_singleview_bowplayground_name}}.app" --output "{{markdown_output}}"

# iOS Single View : 5 : Render Jekyll for Transformed PlayGround by nef
jekyll-transformed-playground-iOS-SingleView:
    nef jekyll --project "{{transform_bowplayground}}/{{ios_singleview_bowplayground_name}}.app" --output "{{jekyll_output}}/{{ios_singleview_bowplayground_name}}"

# iOS Single View : 6 : Render Carbon for Transformed PlayGround by nef
carbon-transformed-playground-iOS-SingleView:
    nef carbon --project "{{transform_bowplayground}}/{{ios_singleview_bowplayground_name}}.app" --output "{{carbon_output}}"

# iOS Single View : Clean Transformed PlayGround
trash-transformed-playground-iOS-SingleView:
    trash "{{transform_bowplayground}}/{{ios_singleview_bowplayground_name}}.app"

# iOS Single View : Clean Markdown
trash-transformed-playground-iOS-SingleView-markdown:
    trash "{{markdown_output}}/$(echo {{ios_singleview_bowplayground_name}} | tr [A-Z] [a-z])"

# iOS Single View  : clean Jekyll
trash-transformed-playground-iOS-SingleView-jekyll:
    trash "{{jekyll_output}}/{{ios_singleview_bowplayground_name}}"

# iOS Single View : clean Carbon
trash-transformed-playground-iOS-SingleView-carbon:
    trash "{{carbon_output}}/$(echo {{ios_singleview_bowplayground_name}} | tr [A-Z] [a-z])"
