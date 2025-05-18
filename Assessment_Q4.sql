-- Customer Lifetime Value (CLV) Estimation
-- Scenario: Estimate CLV based on account tenure and transaction volume.
-- Assumptions:
--   - profit_per_transaction = 0.1% of transaction value
--   - CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction
-- Notes:
--   - All amounts are in kobo, so we divide by 100 to convert to naira
--   - FORMAT is used to ensure the output always shows two decimal places

SELECT
    u.id AS customer_id,  -- Unique ID of the customer
    CONCAT(u.first_name, ' ', u.last_name) AS name,  -- Full name of the customer
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,  -- Number of months since account creation
    COUNT(s.id) AS total_transactions,  -- Total number of successful transactions
    FORMAT(  -- Ensure 2 decimal places are displayed in the result
        (
            (COUNT(s.id) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()))  -- Average transactions per month
            * 12  -- Project to 12 months
            * AVG(s.confirmed_amount) * 0.001  -- Profit per transaction = 0.1%
        ) / 100,  -- Convert from kobo to naira
        2  -- Format to 2 decimal places
    ) AS estimated_clv  -- Final estimated CLV value
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id
WHERE s.transaction_status = 'success'  -- Only count successful transactions
GROUP BY u.id, u.first_name, u.last_name, tenure_months
HAVING tenure_months > 0  -- Exclude customers with no tenure (to avoid division by zero)
ORDER BY estimated_clv DESC;  -- Show highest CLV first
