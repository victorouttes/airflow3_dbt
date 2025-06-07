# Execução

1 - Iniciar o astro-cli
```
astro dev start
```

2 - Checar qual a rede que o astro-cli criou
```
docker network ls
```
Pegar o nome da rede e atualizar o arquivo  [dw_config_docker_compose.yml](dw/dw_config_docker_compose.yml),
de forma que o datawarehouse consiga ficar acessível pelos containers do airflow.

3 - Inicializar o DW
```
 docker compose -f dw/dw_config_docker_compose.yml up -d
```

4 - Adicionar os dados na camada bronze

Abra o DBeaver, conecte no DW e rode o script [bronze.sql](dw/bronze.sql).

5 - Para rodar localmente o dbt
```
cd dags/dbt
DBT_PROFILES_DIR=. dbt run
```