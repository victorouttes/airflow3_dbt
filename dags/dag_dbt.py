import os

from airflow.sdk import dag
from cosmos.profiles import PostgresUserPasswordProfileMapping
from cosmos import DbtTaskGroup, ProjectConfig, ProfileConfig, ExecutionConfig, RenderConfig, ExecutionMode, \
    SourceRenderingBehavior
from datetime import datetime

current_dir = os.path.dirname(os.path.abspath(__file__))
dbt_project_path = os.path.join(current_dir, "dbt")
profile_ = PostgresUserPasswordProfileMapping(
    conn_id="postgres_dw",
    profile_args={"schema": "dw"}
)
profile_config = ProfileConfig(
    profile_mapping=profile_,
    profile_name="dbt_project",
    target_name="datalake",
)

@dag(start_date=datetime(2023, 1, 1), schedule=None, catchup=False, tags=["dbt"])
def generate_dag():
    DbtTaskGroup(
        group_id="bronze_to_silver_gold",
        project_config=ProjectConfig(
            dbt_project_path
        ),
        execution_config=ExecutionConfig(
            execution_mode=ExecutionMode.LOCAL,
            dbt_executable_path=f"{os.environ['AIRFLOW_HOME']}/dbt_env/bin/dbt"
        ),
        profile_config=profile_config,
        render_config=RenderConfig(
            source_rendering_behavior=SourceRenderingBehavior.ALL,
        ),
        operator_args={
            "install_deps": True,
        }
    )

generate_dag()
