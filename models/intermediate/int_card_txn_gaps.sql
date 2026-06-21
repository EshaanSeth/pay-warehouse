with transactions as (
    select * from {{ ref('stg_transactions') }}
),

with_prev as (
    select
        transaction_id,
        card_id,
        merchant_id,
        amount,
        status,
        transaction_ts,
        lag(transaction_ts) over (
            partition by card_id
            order by transaction_ts
        ) as prev_transaction_ts
    from transactions
)

select
    transaction_id,
    card_id,
    merchant_id,
    amount,
    status,
    transaction_ts,
    prev_transaction_ts,
    datediff(second, prev_transaction_ts, transaction_ts) as seconds_since_prev_txn
from with_prev