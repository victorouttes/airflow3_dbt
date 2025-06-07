{{ config(
    alias='orders',
    materialized='incremental',
    unique_key='hashkey'
) }}

with source as (
    select
        record_id as record_id,
        source_system as source_system,
        ingestion_timestamp as ingestion_timestamp,
        coalesce(raw_data->>'order_id', raw_data->>'transaction_id') as order_id,
        coalesce(raw_data->>'customer_id', raw_data->>'cust_id') as customer_id,
        raw_data->>'status' as status,
        cast(coalesce(raw_data->>'total', raw_data->>'amount') as decimal(10,2)) as total,
        encode(sha256((coalesce(raw_data->>'order_id', raw_data->>'transaction_id'))::TEXT::BYTEA), 'hex') as hashkey
    from {{ source('dw_bronze', 'raw_orders') }}
)

select * from source
{% if is_incremental() %}
    where ingestion_timestamp > (select coalesce(max(ingestion_timestamp), '1900-01-01 00:00:00') from {{ this }})
{% endif %}