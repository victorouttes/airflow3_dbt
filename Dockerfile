FROM astrocrpublic.azurecr.io/runtime:3.0-2

RUN python -m venv dbt_env &&  \
    source dbt_env/bin/activate && \
    pip install --upgrade pip &&  \
    pip install --no-cache-dir dbt-core==1.9.6 dbt-postgres==1.9.0 &&  \
    deactivate