with transactions as (
    select * from {{ ref('stg_transactions') }}
),

merchant_versions as (
    select * from {{ ref('dim_merchant') }}
)

select
    t.transaction_id,
    t.card_id,
    t.merchant_id,
    m.merchant_version_key,                       -- the resolved surrogate key, stamped on the fact
    m.category as merchant_category_at_txn_time,  -- category as it was THEN
    t.amount,
    t.status,
    t.transaction_ts
from transactions t
left join merchant_versions m
    on  t.merchant_id = m.merchant_id
    and t.transaction_ts >= m.valid_from
    and (t.transaction_ts < m.valid_to or m.valid_to is null)