#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

echo "Проект: $(basename "$PWD")"
echo

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Ошибка: эта папка ещё не является Git-репозиторием."
    echo "Сначала нужно выполнить git init и подключить GitHub-репозиторий."
    exit 1
fi

BRANCH="$(git branch --show-current)"

if [[ -z "$BRANCH" ]]; then
    echo "Ошибка: не удалось определить текущую ветку Git."
    exit 1
fi

if ! git remote get-url origin >/dev/null 2>&1; then
    echo "Ошибка: удалённый репозиторий origin не настроен."
    exit 1
fi

echo "Текущая ветка: $BRANCH"
echo
git status --short
echo

read -r -p "Введите название коммита: " COMMIT_MESSAGE

if [[ -z "${COMMIT_MESSAGE// }" ]]; then
    echo "Ошибка: название коммита не может быть пустым."
    exit 1
fi

git add -A

if git diff --cached --quiet; then
    echo
    echo "Нет новых изменений для коммита."
    exit 0
fi

git commit -m "$COMMIT_MESSAGE"

echo
echo "Отправка изменений на GitHub..."

git push -u origin "$BRANCH"

echo
echo "Готово."
echo "Коммит создан и отправлен в ветку: $BRANCH"
echo
git status -sb
