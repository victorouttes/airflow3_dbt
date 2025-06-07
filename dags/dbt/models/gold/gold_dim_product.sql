{{ config(
    alias='dim_product',
    materialized='incremental',
    unique_key='hashkey'
) }}

with source as (
    select
        hashkey,
        sku,
        product_name,
        unit_cost
    from {{ ref('silver_products') }}
)
select * from source