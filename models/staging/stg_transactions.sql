with source as (
    select * from {{ ref('transactions') }}
),

renamed as (
    select
        txn_id          as transaction_id,
        card_id,
        merchant_id,
        amount,
        upper(status)   as status,
        txn_ts          as transaction_ts,
        city
    from source
)

select * from renamed