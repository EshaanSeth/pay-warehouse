{% snapshot merchant_snapshot %}

{{
    config(
        target_schema='snapshots',
        unique_key='merchant_id',
        strategy='check',
        check_cols=['category'],
    )
}}

select
    merchant_id,
    merchant_name,
    category
from {{ ref('stg_merchants') }}

{% endsnapshot %}
