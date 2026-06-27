with snapshot_data as (
    select * from {{ ref('merchant_snapshot') }}
),

versioned as (
    select
        dbt_scd_id      as merchant_version_key,
        merchant_id,
        merchant_name,
        category,
        dbt_valid_from,
        dbt_valid_to,
        -- is this the earliest version for this merchant?
        row_number() over (partition by merchant_id order by dbt_valid_from) as version_num
    from snapshot_data
)

select
    merchant_version_key,
    merchant_id,
    merchant_name,
    category,
    -- the first version reaches back to the beginning of time so it covers all historical facts
    case when version_num = 1 then '1900-01-01'::timestamp else dbt_valid_from end as valid_from,
    dbt_valid_to as valid_to,
    case when dbt_valid_to is null then true else false end as is_current
from versioned