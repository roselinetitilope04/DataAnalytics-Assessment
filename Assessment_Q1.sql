-- Query to find high-value customers with both savings and investment plans,
-- showing top 10 by total deposits (converted from Kobo to Naira, rounded to 2 decimal places)
SELECT   
    u.id AS owner_id,  
    CONCAT(u.first_name, ' ', u.last_name) AS name,  

    -- Count of unique regular savings plans
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,  

    -- Count of unique fixed investment plans
    COUNT(DISTINCT CASE WHEN p.is_fixed_investment = 1 THEN p.id END) AS investment_count,  

    -- Sum of confirmed deposits converted from Kobo to Naira and rounded to 2 decimal places
    CAST(ROUND(SUM(t.confirmed_amount) / 100, 2) AS DECIMAL(15,2)) AS total_deposits


FROM users_customuser u  
INNER JOIN plans_plan p ON u.id = p.owner_id  
INNER JOIN savings_savingsaccount t ON p.id = t.plan_id  

-- Include only successful deposit transactions of certain types
WHERE t.transaction_type_id IN (1, 2, 3, 4, 5, 6, 7)  
  AND t.transaction_status = 'success'  

GROUP BY u.id, u.first_name, u.last_name  

-- Include only users with at least one savings and one investment plan
HAVING savings_count > 0 AND investment_count > 0  

ORDER BY total_deposits DESC  
LIMIT 10;
