#!/usr/bin/env bash

if [ ! -f october/index.php ]; then
    if hash composer 2>/dev/null; then
        :
    else
        echo "Composer not found. Installing; requires sudo command."
        curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
    fi
    echo "OctoberCMS not found. Installing to folder 'october'"
    composer create-project october/october october dev-stable -n
fi
