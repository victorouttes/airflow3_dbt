{{ config(
    alias='dim_customer',
    materialized='incremental',
    unique_key='hashkey'
) }}

with source as (
    select
        hashkey,
        customer_id,
        full_name
    from {{ ref('silver_customers') }}
)
select * from source