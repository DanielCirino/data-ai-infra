FROM jupyter/pyspark-notebook:latest

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

USER $NB_UID

RUN pip install --no-cache-dir \
    # ML & Data Science
    scikit-learn \
    tensorflow \
    torch \
    # Data Sources & Drivers
    psycopg2-binary \
    boto3 \
    mlflow \
    # Graph & Vector DB
    neo4j \
    chromadb \
    # LLM & RAG
    langchain \
    llama-index \
    openai
