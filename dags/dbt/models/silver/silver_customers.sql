{{ config(
    alias='customers',
    materialized='incremental',
    unique_key='hashkey'
) }}

with source as (
    select
        record_id as record_id,
        source_system as source_system,
        ingestion_timestamp as ingestion_timestamp,
        raw_data->>'customer_id' as customer_id,
        coalesce(raw_data->>'name', raw_data->>'full_name') as full_name,
        coalesce(raw_data->>'email', raw_data->>'contact') as email,
        coalesce(raw_data->>'phone', raw_data->>'tel') as phone,
        raw_data->>'address' as address,
        encode(sha256((coalesce(raw_data->>'email', raw_data->>'contact'))::TEXT::BYTEA), 'hex') as hashkey
    from {{ source('dw_bronze', 'raw_customers') }}
)

select * from source
{% if is_incremental() %}
    where ingestion_timestamp > (select coalesce(max(ingestion_timestamp), '1900-01-01 00:00:00') from {{ this }})
{% endif %}