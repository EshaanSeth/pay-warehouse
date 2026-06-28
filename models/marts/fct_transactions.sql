with transactions as (
    select * from {{ ref('stg_transactions') }}
),

current_merchants as (
    select *
    from {{ ref('dim_merchant') }}
    where is_current = true          -- one row per merchant → no fan-out
)

select
    t.transaction_id,
    t.card_id,
    t.merchant_id,
    m.merchant_name,
    m.category        as merchant_category,   -- merchant's CURRENT category
    t.amount,
    t.status,
    t.transaction_ts,
    t.city
from transactions t
left join current_merchants m
    on t.merchant_id = m.merchant_id