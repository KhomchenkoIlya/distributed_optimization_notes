#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_NAME="$(basename "$SCRIPT_DIR")"
PROJECT_PARENT="$(dirname "$SCRIPT_DIR")"

BUILD_DIR="$SCRIPT_DIR/build"
ARCHIVE_PATH="$BUILD_DIR/${PROJECT_NAME}.zip"

mkdir -p "$BUILD_DIR"

if ! command -v zip >/dev/null 2>&1; then
    echo "Ошибка: программа zip не установлена."
    echo "Установить её можно командой:"
    echo "sudo apt install zip"
    exit 1
fi

TMP_DIR="$(mktemp -d --tmpdir "${PROJECT_NAME}.XXXXXX")"
TMP_ARCHIVE="$TMP_DIR/${PROJECT_NAME}.zip"

cleanup() {
    rm -rf -- "$TMP_DIR"
}
trap cleanup EXIT

rm -f -- "$ARCHIVE_PATH"

echo "Создание архива проекта..."
echo

cd "$PROJECT_PARENT"

zip -r -9 "$TMP_ARCHIVE" "$PROJECT_NAME" \
    -x "$PROJECT_NAME/.git/*" \
       "$PROJECT_NAME/build/*" \
       "$PROJECT_NAME/*.aux" \
       "$PROJECT_NAME/*.log" \
       "$PROJECT_NAME/*.toc" \
       "$PROJECT_NAME/*.out" \
       "$PROJECT_NAME/*.synctex.gz" \
       "$PROJECT_NAME/*.fls" \
       "$PROJECT_NAME/*.fdb_latexmk" \
       "$PROJECT_NAME/*.xdv" \
       "$PROJECT_NAME/*.bbl" \
       "$PROJECT_NAME/*.blg" \
       "$PROJECT_NAME/*.bcf" \
       "$PROJECT_NAME/*.run.xml" \
       "$PROJECT_NAME/*.lof" \
       "$PROJECT_NAME/*.lot" \
       "$PROJECT_NAME/*.lol" \
       "$PROJECT_NAME/*~" \
       "$PROJECT_NAME/.DS_Store"

echo
echo "Проверка целостности архива..."
zip -T "$TMP_ARCHIVE"

mv -- "$TMP_ARCHIVE" "$ARCHIVE_PATH"

echo
echo "Архив создан:"
echo "$ARCHIVE_PATH"
echo
du -h "$ARCHIVE_PATH"