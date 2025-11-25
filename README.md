# Data & AI Local Infrastructure

Este repositório contém uma plataforma de desenvolvimento local completa e robusta, provisionada com Docker Compose. O objetivo é fornecer uma base de infraestrutura pronta para uso para projetos de desenvolvimento de software, engenharia de dados e inteligência artificial, sem custos de nuvem.

## Visão Geral

A filosofia deste projeto é fornecer uma coleção coesa e padronizada de serviços de ponta, cobrindo desde bancos de dados e armazenamento até orquestração de workflows, observabilidade e ferramentas de IA. Todos os serviços são configurados para trabalhar em conjunto na mesma rede Docker.

## Serviços Incluídos

Abaixo está a lista de todos os serviços disponíveis, agrupados por capacidade funcional.

| Categoria | Serviço | Acesso (localhost) | Credenciais Padrão (user/pass) |
| :--- | :--- | :--- | :--- |
| **Core & Storage** | MinIO (Object Storage) | [http://localhost:9001](http://localhost:9001) | `minioadmin` / `minioadmin` |
| | PostgreSQL (com PostGIS) | `psql -h localhost -p 5432` | `postgres` / `postgres` |
| | MongoDB (NoSQL) | `mongo --host localhost` | `root` / `example` |
| | ClickHouse (OLAP) | [http://localhost:8123](http://localhost:8123) | `default` / `clickhouse_secret` |
| | Neo4j (Graph DB) | [http://localhost:7474](http://localhost:7474) | `neo4j` / `neo4j_secret` |
| | Redis (Cache) | `redis-cli -h localhost` | `(none)` / `Redis2019!` |
| | RabbitMQ (Messaging) | [http://localhost:15672](http://localhost:15672) | `guest` / `guest` |
| **Data Processing** | Apache Airflow | [http://localhost:8081](http://localhost:8081) | `airflow` / `airflow` |
| | Apache Spark Master | [http://localhost:9090](http://localhost:9090) | (N/A) |
| | Apache Spark Worker A | [http://localhost:9093](http://localhost:9093) | (N/A) |
| | Apache Spark Worker B | [http://localhost:9092](http://localhost:9092) | (N/A) |
| **AI & ML** | Ollama (LLM Server) | [http://localhost:11434](http://localhost:11434) | (N/A) |
| | Open WebUI | [http://localhost:8080](http://localhost:8080) | (setup no primeiro acesso) |
| | MLflow | [http://localhost:5000](http://localhost:5000) | (N/A) |
| | JupyterLab | [http://localhost:8888](http://localhost:8888) | (token no console) |
| | ChromaDB (Vector DB) | [http://localhost:8000/api/v1](http://localhost:8000/api/v1) | (N/A) |
| **Observability** | Grafana | [http://localhost:3000](http://localhost:3000) | `admin` / `admin` |
| | Prometheus | [http://localhost:9091](http://localhost:9091) | (N/A) |
| | OpenTelemetry Collector | `gRPC: 4317`, `HTTP: 4318` | (N/A) |
| **Management & UI** | Portainer | [http://localhost:9002](http://localhost:9002) | (setup no primeiro acesso) |
| | Metabase | [http://localhost:3001](http://localhost:3001) | (setup no primeiro acesso) |
| | Mongo Express | [http://localhost:8082](http://localhost:8082) | `root` / `example` |
| | MailHog (SMTP) | [http://localhost:8025](http://localhost:8025) | (N/A) |

**Nota sobre o Airflow:** Para simplificar o ambiente local, o Airflow agora utiliza o `postgres-server` como seu banco de dados de metadados, eliminando a necessidade de um serviço de banco de dados PostgreSQL dedicado ao Airflow.

## Pré-requisitos

- **Docker:** [Instruções de instalação](https://docs.docker.com/engine/install/)
- **Docker Compose:** [Instruções de instalação](https://docs.docker.com/compose/install/)

## Como Começar

1.  **Clone o Repositório:**
    ```bash
    git clone https://github.com/DanielCirino/data-ai-infra.git
    cd devrox-infra
    ```

2.  **Configure o Ambiente:**
    Cada serviço que requer configuração possui um arquivo `.env.example` em seu respectivo diretório dentro de `docker/`. Para a primeira execução, você pode simplesmente copiar esses arquivos.
    
    *Exemplo para o PostgreSQL:*
    ```bash
    cp docker/postgresql/.env.example docker/postgresql/.env
    ```
    Repita este processo para todos os serviços que você pretende usar e que possuam um arquivo `.env.example`.

3.  **Crie um ID de Usuário para o Airflow:**
    O Airflow requer que um ID de usuário seja definido para evitar problemas de permissão com os arquivos de DAGs. Crie um arquivo `.env` na raiz do projeto com o seguinte conteúdo:
    ```bash
    echo "AIRFLOW_UID=$(id -u)" > .env
    ```

4.  **Inicie a Plataforma:**
    Com o Docker em execução, inicie todos os serviços com o Docker Compose:
    ```bash
    docker-compose up -d
    ```
    A primeira execução pode levar vários minutos, pois o Docker irá baixar todas as imagens e construir os serviços que possuem um `Dockerfile` (como JupyterLab e Airflow).

5.  **Acesse os Serviços:**
    Use a tabela na seção "Serviços Incluídos" para encontrar as URLs e as credenciais de cada serviço.

6.  **Desligue a Plataforma:**
    Para parar todos os serviços, execute:
    ```bash
    docker-compose down
    ```

## Estrutura de Diretórios

- **`docker-compose.yml`**: O arquivo principal que define e orquestra todos os serviços.
- **`docker/`**: Contém as configurações específicas de cada serviço.
  - **`[NOME_DO_SERVICO]/`**: Cada serviço configurável possui seu próprio diretório.
    - **`.env`**: Arquivo com as variáveis de ambiente (credenciais, hosts, etc.). **Este arquivo não deve ser commitado.**
    - **`.env.example`**: Um arquivo de modelo para o `.env`.
    - **`*.yml` ou `*.conf`**: Arquivos de configuração adicionais, se necessários.
    - **`Dockerfile`**: Se o serviço requer uma imagem customizada, ele estará aqui.
- **`data/`**: Diretórios mapeados como volumes para persistir dados ou fornecer arquivos aos serviços (ex: `notebooks/` para o Jupyter, `dags/` para o Airflow). Este diretório é criado na primeira execução ou pode ser criado manualmente.

## Políticas de Reinício (Restart Policies)

Para otimizar o uso de recursos e o tempo de inicialização em um ambiente de desenvolvimento local, apenas os serviços essenciais estão configurados para reiniciar automaticamente com o Docker:

*   **`minio-server`**: `restart: always`
*   **`postgres-server`**: `restart: always`
*   **`portainer-app`**: `restart: always`

Todos os outros serviços não possuem uma política de reinício definida (`no-restart`), o que significa que eles precisarão ser iniciados manualmente após um `docker-compose down` ou uma reinicialização do sistema, a menos que você os inicie explicitamente.
