-- Select key fields to identify inactive plans
SELECT
    p.id AS plan_id,                        -- Unique identifier for the plan
    p.owner_id,                             -- User associated with the plan

    -- Classify each plan as either 'investment', 'savings', or 'other'
    CASE 
        WHEN p.is_a_fund = 1 THEN 'investment'
        WHEN p.is_regular_savings = 1 THEN 'savings'
        ELSE 'other'
    END AS type,

    -- Find the date of the most recent transaction for the plan
    DATE(MAX(s.transaction_date)) AS last_transaction_date,

    -- Calculate how many days have passed since the last transaction
    TIMESTAMPDIFF(DAY, MAX(s.transaction_date), CURDATE()) AS inactivity_days

FROM adashi_staging.plans_plan p

LEFT JOIN adashi_staging.savings_savingsaccount s
    ON p.id = s.plan_id

-- Focus only on active savings or investment plans
WHERE (p.is_a_fund = 1 OR p.is_regular_savings = 1)

-- Group by plan and owner to allow aggregation (e.g., MAX date)
GROUP BY p.id, p.owner_id, type

-- Return only plans with no transaction in the last 365 days
HAVING inactivity_days > 365;

