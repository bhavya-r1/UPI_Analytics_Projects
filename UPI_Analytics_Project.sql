--1.Database Connection Check
SELECT
current_database(),
CURRENT_USER;


--2. Total Number of Records
SELECT
count(*)as total_records
from upi_transactions


--3.Total And Average Transaction Metrics
select
    sum(volume_mn) as total_transactional_volume,
    sum(value_cr) as total_transactional_value,
    avg(value_cr) as average_transactional_value
    from upi_transactions;


--4. Min and Max Transaction Metrics
select
min(volume_mn) as minimum_volume,
max(volume_mn) as maximum_volume,
min(value_cr) as minimum_value,
max(value_cr) as maximum_value
from upi_transactions


--5.Check Missing Values
SELECT *
FROM upi_transactions
WHERE month IS NULL
   OR volume_mn IS NULL
   OR avg_daily_volume_mn IS NULL
   OR value_cr IS NULL
   OR avg_daily_value_cr IS NULL
   OR days_covered_volume IS NULL
   OR days_covered_value IS NULL
   OR avg_transaction_value IS NULL
   OR mom_volume_growth_pct IS NULL
   OR mom_value_growth_pct IS NULL
   OR yoy_volume_growth_pct IS NULL
   OR yoy_value_growth_pct IS NULL
   OR cumulative_volume IS NULL
   OR cumulative_value IS NULL
   OR year IS NULL
   OR financial_year IS NULL;


--6.Check Imp Missing Values
SELECT
    month,
    mom_volume_growth_pct,
    mom_value_growth_pct,
    yoy_volume_growth_pct,
    yoy_value_growth_pct
FROM upi_transactions
WHERE mom_volume_growth_pct IS NULL
   OR mom_value_growth_pct IS NULL
   OR yoy_volume_growth_pct IS NULL
   OR yoy_value_growth_pct IS NULL
ORDER BY month; 


--7.Check Duplicates Months
SELECT
month,
count(*) as duplicates_count
from upi_transactions
GROUP BY month
having count(*) > 1;


--8.Top 5 months By transaction Volume
select 
MONTH,
volume_mn,
value_cr
FROM upi_transactions
ORDER BY volume_mn DESC
limit 5;


--9.Top 5 months By transaction Value
select
month,
value_cr,
volume_mn
from upi_transactions
ORDER by value_cr DESC
limit 5;


--10.Financial Year Performance 
select 
financial_year,
sum(volume_mn) as total_volume,
sum(value_cr) as total_value,
avg(volume_mn) as average_monthly_volume,
avg(value_cr) as average_monthly_value
from upi_transactions
GROUP BY financial_year
ORDER BY financial_year;


--11.MOnthly Transactional Trend
SELECT
month,
volume_mn,
value_cr,
mom_value_growth_pct,
mom_volume_growth_pct
FROM upi_transactions
ORDER BY month asc;


--12.Year on Year Growth Analysis
SELECT
month,
volume_mn,
value_cr,
yoy_value_growth_pct,
yoy_volume_growth_pct
from upi_transactions
ORDER BY month ASC;


--13.Highest and Lowest Growth MOnths

--Highest Mom Volume Growth
select 
month,
mom_volume_growth_pct
FROM upi_transactions
where mom_volume_growth_pct is not NULL
order BY mom_volume_growth_pct DESC
limit 1;

--Lowest Mom Volume Growth
select 
month,
mom_volume_growth_pct
FROM upi_transactions
where mom_volume_growth_pct is not NULL
order BY mom_volume_growth_pct asc
limit 1;

--Highest Yoy Volume Growth
select 
month,
yoy_volume_growth_pct
FROM upi_transactions
where yoy_volume_growth_pct is not NULL
order BY yoy_volume_growth_pct DESC
limit 1;

--Lowest Yoy Volume Growth
select 
month,
yoy_volume_growth_pct
FROM upi_transactions
where yoy_volume_growth_pct is not NULL
order BY yoy_volume_growth_pct ASC
limit 1;


--14.Avg Transaction Value Analysis

--Monthly Avg Transactional Value
SELECT
month,
avg_transaction_value
from upi_transactions
ORDER BY month;

--Highest Avg transactional Value
SELECT
month,
avg_transaction_value
from upi_transactions
WHERE avg_transaction_value is not NULL
ORDER BY value_cr DESC
limit 1;

--Lowest avg Transactional Value
SELECT
month,
avg_transaction_value
from upi_transactions
WHERE avg_transaction_value is not NULL
ORDER BY avg_transaction_value ASC
limit 1;


--15.Cumulative Transaction Performance
SELECT
MONTH,
cumulative_value,
cumulative_volume
from upi_transactions
ORDER BY month ASC;


--16.Avg daily Transactiona Performance
SELECT
MONTH
avg_daily_value_cr,
avg_daily_volume_mn,
days_covered_value,
days_covered_volume
from upi_transactions
ORDER BY month ASC;


--17. fianacial year Growth Comparison
SELECT
financial_year,
sum(volume_mn) as total_volume,
sum(value_cr) as total_value,
round(
   (sum(volume_mn) - 
   Lag(sum(volume_mn)) over (ORDER BY
   financial_year))
    /NULLIF(lag(sum(volume_mn)) OVER
    (ORDER BY financial_year), 0) * 100,2
) as volume_growth_pct 
FROM upi_transactions
GROUP BY financial_year
ORDER BY financial_year;


--18.Financial year ranking
select
financial_year,
sum(volume_mn) as total_volume,
rank() over( ORDER BY sum(volume_mn) DESC
) as volume_rank
from upi_transactions
group BY financial_year
ORDER BY volume_rank;


--19.Quaterly transaction Analysis
SELECT
financial_year,

case
    when EXTRACT(month from month)
between 4 and 6 then 'Q1'
    WHEN EXTRACT(MONTH FROM month)
between 7 and 9 then 'Q2'
    when EXTRACT(month from month)
between 10 and 12 then 'Q3'
    else 'Q4'
end as quater,

sum(volume_mn) as total_volume,
sum(value_cr) as total_value
from upi_transactions
group by financial_year,
case
    when EXTRACT(month from month)
between 4 and 6 then 'Q1'
    WHEN EXTRACT(MONTH FROM month)
between 7 and 9 then 'Q2'
    when EXTRACT(month from month)
between 10 and 12 then 'Q3'
    else 'Q4'
end
order by financial_year,
quater;


--20.Transaction Value vs value Analysis
select 
month,
volume_mn,
value_cr,
avg_transaction_value
from upi_transactions
ORDER BY value_cr desc;


-- 21. FINAL UPI KPI SUMMARY

SELECT
    COUNT(*) AS total_months,
    SUM(volume_mn) AS total_transaction_volume,
    SUM(value_cr) AS total_transaction_value,
    ROUND(AVG(volume_mn), 2) AS avg_monthly_volume,
    ROUND(AVG(value_cr), 2) AS avg_monthly_value,
    MAX(volume_mn) AS highest_monthly_volume,
    MAX(value_cr) AS highest_monthly_value
FROM upi_transactions;