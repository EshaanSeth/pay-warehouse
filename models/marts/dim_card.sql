with cards as (
    select * from {{ ref('stg_cards') }}
)

select
    card_id,
    customer_id,
    issued_at
from cards