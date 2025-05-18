
-- Transaction Frequency Analysis
-- This query categorizes users based on the average number of successful transactions per month
-- Categories:
--   - High Frequency: ≥10 transactions/month
--   - Medium Frequency: 3–9 transactions/month
--   - Low Frequency: ≤2 transactions/month

SELECT 
    frequency_category,                              -- User category based on frequency
    COUNT(*) AS customer_count,                      -- Number of customers in each category
    ROUND(AVG(tx_per_month), 1) AS avg_transactions_per_month  -- Average transactions per month in each category
FROM (
    SELECT 
        sa.owner_id,                                 -- User ID
        COUNT(*) / COUNT(DISTINCT DATE_FORMAT(sa.transaction_date, '%Y-%m')) AS tx_per_month,  -- Avg tx per month
        CASE 
            WHEN COUNT(*) / COUNT(DISTINCT DATE_FORMAT(sa.transaction_date, '%Y-%m')) >= 10 THEN 'High Frequency'
            WHEN COUNT(*) / COUNT(DISTINCT DATE_FORMAT(sa.transaction_date, '%Y-%m')) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category                    -- Assign category based on frequency
    FROM savings_savingsaccount sa
    WHERE sa.transaction_status = 'success'          -- Only consider successful transactions
    GROUP BY sa.owner_id                             -- One row per customer
) AS customer_tx_summary
GROUP BY frequency_category;                         -- Final summary per category
