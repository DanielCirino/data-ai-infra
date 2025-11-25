#!/bin/bash

set -e

# Função para criar um banco de dados.
# Ela verifica se o banco de dados já não existe.
function create_database() {
    local database=$1
    echo "Creating database '$database'"
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
        SELECT 'CREATE DATABASE $database'
        WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '$database')\gexec
EOSQL
}

# Se a variável POSTGRES_MULTIPLE_DATABASES estiver definida,
# itera sobre os nomes dos bancos de dados (separados por vírgula) e cria cada um.
if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
    echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
    for db in $(echo "$POSTGRES_MULTIPLE_DATABASES" | tr ',' ' '); do
        create_database "$db"
    done
    echo "Multiple databases created"
fi
