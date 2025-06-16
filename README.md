## Customer Insights & Product Engagement Analysis

A Financial Technology company seeks to extract meaningful insights from data in order to inform their Operations and Finance Teams using a dataset containing the following tables:

- users_customuser: customer demographic and contact information
- savings_savingsaccount: records of deposit transactions
- plans_plan: records of plans created by customers
- withdrawals_withdrawal:  records of withdrawal transactions

The following questions were to be answered:

### High-Value Customers with Multiple Products

**Scenario:** The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).

**Task:** Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

**Tables to be used:**

users_customuser
savings_savingsaccount
plans_plan

**Solution**

The objective of this analysis was to identify high-value customers who are engaged with multiple financial products — specifically, those who have both a savings and an investment plan — and show how much they have deposited so far.

It took some exploration to understand the relationships between the tables and how to avoid duplicate records caused by many-to-many joins. Initially, a direct join of all three tables led to inflated deposit totals due to overlapping records.

To manage this, I broke the problem down using Common Table Expressions (CTEs).
First, I summarized the number of savings and investment plans per customer using the `plans_plan` table. Then, I separately calculated the total confirmed deposits from the `savings_savingsaccount` table.

Afterward, I joined both summaries with the `users_customuser` table to retrieve customer names. I applied a filter to return only those users who had at least one savings plan and one investment plan, and finally sorted the results by total deposits in descending order.

This approach helped reduce complexity, ensured accuracy, and made the results easy to interpret for business use.

---



### Transaction Frequency Analysis

**Scenario:** The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).

**Task:** Calculate the average number of transactions per customer per month and categorize them:

"High Frequency" (≥10 transactions/month)
"Medium Frequency" (3-9 transactions/month)
"Low Frequency" (≤2 transactions/month)

**Tables:**
users_customuser
savings_savingsaccount

**Solution**:

The objective of this analysis is to  help the finance team understand customer transaction behavior by segmenting users based on how frequently they transact each month.

It took a while to understand the level of aggregation needed after pulling data from different tables using multiple subqueries.

I first had to extract the monthly transactions for each customer by year-month in order to count how many transactions each customer made per month, then find the average per customer per month, assign them into different categories and then summarize.

All these I managed with the help of multiple subqueries.

---


### Account Inactivity Alert

**Scenario:** The ops team wants to flag accounts with no inflow transactions for over one year.

**Task:** Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days).

**Tables:**
plans_plan
savings_savingsaccount

**Solution**:

To begin, I first needed to clearly define what counts as an "active account" and what qualifies as "no transactions in the last 365 days." The data was spread across two main tables: plans_plan, which tracks savings and investment plans, and savings_savingsaccount, which records financial transactions linked to those plans.

I joined these tables using the shared owner_id field to associate each plan with its corresponding transaction records. Then, for each account, I checked the most recent transaction date using the MAX(transaction_date) function. The key step was to compare this latest transaction date with the current date to calculate if the difference exceeded 365 days.

A challenge I encountered was ensuring that I filtered only for accounts that are still marked as active, and that I didn’t mistakenly include inactive or closed accounts. Once filtered correctly, I used a HAVING clause to return only those records where no transactions had occurred within the past year.

Breaking the query into parts and carefully applying time-based logic helped ensure the results were accurate and useful for operational decision-making.


---


### Customer Lifetime Value (CLV) Estimation

**Scenario**: Marketing wants to estimate CLV based on account tenure and transaction volume (simplified model).

**Task**: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:

Account tenure (months since signup)
Total transactions
Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
Order by estimated CLV from highest to lowest

**Tables**:
users_customuser
savings_savingsaccount

**Solution**:

The objective of this analysis was to help the marketing team estimate Customer Lifetime Value (CLV) by evaluating customer account tenure and transaction behavior over time.

To begin, I needed to understand the formula being used and what each part required in terms of data. This involved combining user signup dates with transaction records across two tables.

I first joined the user and transaction tables in order to access each customer’s signup date and transaction history. From there, I calculated the account tenure in months, the total number of transactions, and the average transaction value. Since the model assumed profit per transaction was 0.1% of the transaction amount, I applied that rate to estimate profit.

Once I had these values, I applied the CLV formula, which multiplies average monthly profit by 12 to get an annual estimate.

This approach required multiple aggregate functions and careful calculation of time-based metrics, but breaking the steps into manageable blocks made the logic easier to follow and the results more reliable.














