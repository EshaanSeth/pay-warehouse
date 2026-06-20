with transactions as (
    select * from {{ ref('stg_transactions') }}
),

merchants as (
    select * from {{ ref('dim_merchant') }}
)

select
    t.transaction_id,
    t.card_id,
    t.merchant_id,
    m.merchant_name,
    m.category        as merchant_category,
    t.amount,
    t.status,
    t.transaction_ts,
    t.city
from transactions t
left join merchants m
    on t.merchant_id = m.merchant_id