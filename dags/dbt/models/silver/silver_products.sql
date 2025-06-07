{{ config(
    alias='products',
    materialized='incremental',
    unique_key='hashkey'
) }}

with source as (
    select
        record_id as record_id,
        source_system as source_system,
        ingestion_timestamp as ingestion_timestamp,
        coalesce(raw_data->>'sku', concat(raw_data->>'supplier_id', raw_data->>'product_code')) as sku,
        coalesce(raw_data->>'name', raw_data->>'product_name') as product_name,
        cast(coalesce(raw_data->>'price', raw_data->>'unit_cost') as decimal(10,2)) as unit_cost,
        cast(coalesce(raw_data->>'stock', '0') as decimal(10,2)) as stock,
        encode(sha256((coalesce(raw_data->>'sku', concat(raw_data->>'supplier_id', raw_data->>'product_code')))::TEXT::BYTEA), 'hex') as hashkey
    from {{ source('dw_bronze', 'raw_products') }}
)

select * from source
{% if is_incremental() %}
    where ingestion_timestamp > (select coalesce(max(ingestion_timestamp), '1900-01-01 00:00:00') from {{ this }})
{% endif %}