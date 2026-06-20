with source as (
    select * from {{ ref('cards') }}
),

renamed as (
    select
        card_id,
        customer_id,
        issued_at
    from source
)

select * from renamed