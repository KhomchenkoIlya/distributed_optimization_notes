#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

PROJECT_NAME="$(basename "$PWD")"
BUILD_DIR="build"
MAIN_FILE="main.tex"

mkdir -p "$BUILD_DIR"

if [[ ! -f "$MAIN_FILE" ]]; then
    echo "Ошибка: файл $MAIN_FILE не найден."
    exit 1
fi

echo "Проект: $PROJECT_NAME"
echo "Компиляция $MAIN_FILE через XeLaTeX..."

xelatex \
    -interaction=nonstopmode \
    -halt-on-error \
    -file-line-error \
    -synctex=1 \
    -output-directory="$BUILD_DIR" \
    -jobname="$PROJECT_NAME" \
    "$MAIN_FILE"

echo
echo "Второй проход XeLaTeX..."

xelatex \
    -interaction=nonstopmode \
    -halt-on-error \
    -file-line-error \
    -synctex=1 \
    -output-directory="$BUILD_DIR" \
    -jobname="$PROJECT_NAME" \
    "$MAIN_FILE"

echo
echo "Сборка завершена:"
echo "$PWD/$BUILD_DIR/$PROJECT_NAME.pdf"
