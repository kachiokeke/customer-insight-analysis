SELECT
    u.id AS owner_id,  -- Unique user ID
    CONCAT(u.first_name, ' ', u.last_name) AS name,  -- Full name of the customer

    -- Account tenure in months since signup
    TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE) AS tenure_months,

    -- Total number of transactions
    COUNT(s.id) AS total_transactions,

    -- Estimated Customer Lifetime Value (CLV)
    ROUND(
        (COUNT(s.id) / TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE))
        * 12
        * 0.001 * AVG(s.confirmed_amount),
        2
    ) AS estimated_clv

FROM users_customuser u
JOIN savings_savingsaccount s ON s.owner_id = u.id  -- Link each transaction to its user

GROUP BY u.id
ORDER BY estimated_clv DESC;
