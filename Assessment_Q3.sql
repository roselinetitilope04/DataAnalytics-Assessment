-- Find active savings or investment accounts with no inflow transactions in the last 1 year (365 days)

SELECT
    p.id AS plan_id,  -- Unique ID of the plan (savings or investment)
    p.owner_id,  -- ID of the customer who owns the plan

    -- Determine the type of the plan: Savings or Investment
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_fixed_investment = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,

    MAX(t.transaction_date) AS last_transaction_date,  -- Most recent transaction date for the plan

    DATEDIFF(CURDATE(), MAX(t.transaction_date)) AS inactivity_days  -- Number of days since the last transaction

FROM plans_plan p

-- Left join to include plans even if they have no transactions at all
LEFT JOIN savings_savingsaccount t 
    ON p.id = t.plan_id

WHERE
    -- Include only savings and investment plans
    (p.is_regular_savings = 1 OR p.is_fixed_investment = 1)

    -- Ensure the plan is active (not deleted)
    AND p.is_deleted = 0

GROUP BY 
    p.id, 
    p.owner_id, 
    type  -- Group by plan and customer to aggregate transactions

HAVING 
    -- Include plans that either have no transactions at all
    MAX(t.transaction_date) IS NULL 

    -- Or those whose last transaction was more than 365 days ago
    OR DATEDIFF(CURDATE(), MAX(t.transaction_date)) > 365

ORDER BY 
    inactivity_days DESC;  -- Sort by most inactive accounts first
