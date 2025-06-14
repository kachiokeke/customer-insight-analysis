SELECT frequency_category,
	   COUNT(*) AS customer_count,
       ROUND(AVG(avg_txns_per_month), 1) AS avg_transactions_per_month
FROM (
-- calculate avg monthly transactions per customer and assigns a frequency category
SELECT 
    owner_id,
    AVG(monthly_txn_count) AS avg_txns_per_month, -- average # of transactions/month per customer
    CASE
        WHEN AVG(monthly_txn_count) >= 10 THEN 'High Frequency'
        WHEN AVG(monthly_txn_count) BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category
FROM
-- transaction counts per customer per month
    (SELECT 
        owner_id,
            DATE_FORMAT(transaction_date, '%Y-%m') AS month, -- Extract month and year
            COUNT(*) AS monthly_txn_count
    FROM
        savings_savingsaccount
    GROUP BY owner_id , month) AS monthly_txns
GROUP BY owner_id) as categorized_customers
GROUP BY frequency_category
