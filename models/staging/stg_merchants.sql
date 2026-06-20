with source as (
    select * from {{ ref('merchants') }}
),

renamed as (
    select
        merchant_id,
        merchant_name,
        upper(category) as category
    from source
)

select * from renamed