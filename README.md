
# DataAnalytics-Assessment

Assessment_Q1.sql – High-Value Customusers with Multiple Products

Goal:

-Identify high-value customusers who have both a funded savings plan and a funded investment plan, highlighting potential cross-selling opportunities.

Approach:

-Joined users_customuser, plans_plan, and savings_savingsaccount to access user info, plan types, and deposit data.

-Used CASE WHEN logic to count the number of savings plans (is_regular_savings = 1) and investment plans (is_fixed_investment = 1) per user.

-Applied a HAVING clause to ensure at least one savings and one investment plan per customer.

-Filtered for successful transactions and specific transaction types (transaction_type_id IN (1–7)), assumed to represent deposit inflows.

-Converted confirmed_amount from kobo to Naira by dividing by 100.

-Used ROUND() to format total deposits to two decimal places for financial accuracy.

-Ordered results by total_deposits descending and limited output to the top 10 customusers.


Assessment_Q2.sql – Transaction Frequency Analysis

Goal:

-Segment customusers based on how frequently they transact to help the finance team identify different user behavior patterns.

Approach:

-Calculated total transactions per customuser per month by extracting the year and month from transaction_date in savings_savingsaccount.

-Used a subquery to count transactions for each customuser grouped by month.

-Calculated the average monthly transactions per customuser by averaging their monthly transaction counts.

-Categorized customers into three segments based on average monthly transactions:

-High Frequency: 10 or more transactions/month

-Medium Frequency: 3 to 9 transactions/month

-Low Frequency: 2 or fewer transactions/month

-Returned frequency category, number of customusers per category, and average transactions per month.

-Joined with users_customuser only when necessary to focus on existing users.

Assessment_Q3.sql – Account Inactivity Alert

Goal:

-Identify active accounts (savings or investments) with no inflow transactions for over one year (365 days), to help the operations team flag potentially dormant accounts.

Approach:

-Joined plans_plan with savings_savingsaccount to associate accounts with transactions.

-Filtered for active plans based on plan attributes (e.g., is_regular_savings or is_a_fund).

-Calculated the last inflow transaction date per account by aggregating transaction dates.

-Computed inactivity days by comparing the last transaction date to the current date.

-Selected accounts inactive longer than 365 days.

-Classified accounts as “Savings” or “Investment” based on plan flags.

-Used LEFT JOIN to include accounts with no transactions at all, treating their inactivity accordingly.

Assessment_Q4.sql – Customuser Lifetime Value (CLV) Estimation

Goal:

-Estimate Customuser Lifetime Value (CLV) based on account tenure and transaction volume to help the marketing team understand customuser profitability.

Approach:

-Calculated account tenure in months by finding the difference between the current date and the user’s signup date.

-Counted total transactions per customuser from savings_savingsaccount.

-Assumed profit per transaction as 0.1% of the transaction value (confirmed_amount).

-Computed average profit per transaction per customuser.

-Estimated CLV using the formula:

\text{CLV} = \left(\frac{\text{total_transactions}}{\text{tenure_months}}\right) \times 12 \times \text{avg_profit_per_transaction}
Ordered customusers by estimated CLV in descending order to highlight the most valuable customusers.

-Joined user data from users_customuser to include customuser names and IDs.

Challenges

-Initially worked with PostgreSQL, but the provided database file was not compatible, causing import and setup issues, Resolved this by downloading and installing MySQL and MySQL Workbench to properly import the database and run queries.

-Adapted SQL syntax and functions from PostgreSQL to MySQL, gaining valuable experience understanding differences between SQL dialects.
