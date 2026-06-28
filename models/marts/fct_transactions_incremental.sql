{{
    config(
        materialized='incremental',
        unique_key='transaction_id',
        incremental_strategy='merge'
    )
}}

with transactions as (
    select * from {{ ref('stg_transactions') }}
)

select
    transaction_id,
    card_id,
    merchant_id,
    amount,
    status,
    transaction_ts
from transactions

{% if is_incremental() %}
  -- only on runs after the first: grab rows newer than what we already have
  where transaction_ts > (select max(transaction_ts) from {{ this }})
{% endif %}