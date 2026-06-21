with gaps as (
    select * from {{ ref('int_card_txn_gaps') }}
)

select
    transaction_id,
    card_id,
    merchant_id,
    amount,
    status,
    transaction_ts,
    seconds_since_prev_txn,

    -- velocity flag: this txn came suspiciously fast after the card's previous one
    case
        when seconds_since_prev_txn is not null
             and seconds_since_prev_txn <= 60
        then true
        else false
    end as is_rapid_fire,

    -- high-value flag: large amount (tune threshold as needed)
    case
        when amount >= 50000 then true
        else false
    end as is_high_value

from gaps