{{ config(
    alias='fact_order',
    materialized='incremental',
    unique_key='hashkey',
    update_strategy='append'
) }}

with source as (
    select
        hashkey,
        order_id,
        customer_id,
        status,
        total
    from {{ ref('silver_orders') }}
)
select * from source