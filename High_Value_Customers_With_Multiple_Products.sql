-- Step 1: Summarize the number of savings and investment plans per customer
WITH plan_summary AS (
    SELECT
        owner_id,  -- The user who owns the plan
        SUM(is_regular_savings) AS savings_count,      -- Total number of savings plans
        SUM(is_a_fund) AS investment_count              -- Total number of investment plans
    FROM plans_plan
    GROUP BY owner_id                                   -- Grouping by user to get per-customer counts
),

-- Step 2: Summarize total confirmed deposits per customer
savings_summary AS (
    SELECT
        owner_id,  -- The user who owns the savings account
        ROUND(SUM(confirmed_amount), 2) AS total_deposit  -- Total deposited amount (rounded to 2 decimal places)
    FROM savings_savingsaccount
    GROUP BY owner_id                                     -- Grouping to aggregate deposits per customer
)

-- Step 3: Join both summaries with the users table to get full customer info
SELECT 
    u.id AS owner_id,                                      -- Customer ID
    CONCAT(u.first_name, ' ', u.last_name) AS name,        -- Full name of the customer
    p.savings_count,                                       -- Number of savings plans (from CTE)
    p.investment_count,                                    -- Number of investment plans (from CTE)
    s.total_deposit                                        -- Total confirmed deposit (from CTE)
FROM plan_summary p
JOIN savings_summary s ON p.owner_id = s.owner_id          -- Join on user ID to combine deposits and plans
JOIN users_customuser u ON u.id = p.owner_id               -- Join to bring in customer name and details
WHERE p.investment_count >= 1 AND p.savings_count >= 1     -- Filter for users who have both savings and investments
ORDER BY s.total_deposit DESC;                             -- Sort by total deposit in descending order
