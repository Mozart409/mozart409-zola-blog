# https://just.systems

set dotenv-load := true
set unstable := true

default:
    just --list

clear:
    clear

[working-directory('blog')]
dev:
    zola serve

[working-directory('blog/static')]
css: clear
    tailwindcss -i input.css -o app.css

[working-directory('blog/static')]
css-watch: clear
    tailwindcss -i input.css -o app.css --watch
