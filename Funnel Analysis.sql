-- --------------------------OVERALL FUNNEL ANALYTICS ( home_page -> search_page -> payment_page -> payment_confirmation_page )---------------------

WITH funnel_overall AS (
SELECT COUNT(*) AS Users, 
'                 HOME PAGE' AS PAGE 
FROM home_page_table
UNION ALL
SELECT COUNT(*), 
'               SEARCH PAGE' 
FROM search_page_table
UNION ALL
SELECT COUNT(*), 
'              PAYMENT PAGE' 
FROM payment_page_table
UNION ALL
SELECT COUNT(*), 
' PAYMENT CONFIRMATION PAGE' 
FROM payment_confirmation_table
)

SELECT 
PAGE,
Users, 
CONCAT(ROUND((Users / LAG(Users, 1, Users) OVER()) * 100, 2), '%') AS Conversion_rate, 
CONCAT(ROUND(100 - (Users / LAG(Users, 1, Users) OVER()) * 100, 2), '%') AS Drop_off_rate,
CONCAT(ROUND((Users / (SELECT MAX(Users) FROM funnel_overall))*100, 2), '%') AS Cumulative_conversion_rate 
-- Cumulative conversion rate - % of total users who landed on the respective page
FROM funnel_overall
;

-- -------------------------------------------------SEGMENTED FUNNEL ANALYTICS--------------------------------------------------------

-- -----------------------------------------------------1) MALE VS FEMALE--------------------------------------------------------------

WITH funnel AS (
SELECT 
	'                 HOME PAGE' AS page,
    sex, 
    COUNT(*) AS users
FROM
    user_table u
        JOIN
    home_page_table h ON h.user_id = u.user_id
GROUP BY page, sex
UNION ALL
SELECT
	'               SEARCH PAGE' AS page,
    sex, 
    COUNT(*) AS users
FROM
    user_table u
        JOIN
    search_page_table h ON h.user_id = u.user_id
GROUP BY page, sex
UNION ALL 
SELECT
'              PAYMENT PAGE' AS page,
sex,
COUNT(*) AS users
FROM 
	user_table u
		JOIN
	payment_page_table h ON h.user_id = u.user_id
GROUP BY sex, page
UNION ALL
SELECT
' PAYMENT CONFIRMATION PAGE' AS page,
sex,
COUNT(*) AS users
FROM 
	user_table u
		JOIN
	payment_confirmation_table h ON h.user_id = u.user_id
GROUP BY sex, page
), filtered_funnel AS (
SELECT page, 
SUM(CASE WHEN sex = 'Male' THEN users ELSE 0 END) AS Male, 
SUM(CASE WHEN sex = 'Female' THEN users ELSE 0 END) AS Female FROM funnel
GROUP BY page)

SELECT page,
CONCAT(Male, '  vs  ', Female) AS Male_vs_Female, 
CONCAT(CONCAT(ROUND((Male / LAG(Male, 1, Male) OVER()) * 100, 2), '%'), '  vs  ', CONCAT(ROUND((Female / LAG(Female, 1, Female) OVER()) * 100, 2), '%')) AS Conversion_rate, 
CONCAT(CONCAT(ROUND(100 - (Male / LAG(Male, 1, Male) OVER()) * 100, 2), '%'), '  vs  ', CONCAT(ROUND(100 - (Female / LAG(Female, 1, Female) OVER()) * 100, 2), '%')) AS Drop_off_rate,
CONCAT(CONCAT(ROUND((Male / (SELECT MAX(Male) FROM filtered_funnel))*100, 2), '%'), '  vs  ', CONCAT(ROUND((Female / (SELECT MAX(Female) FROM filtered_funnel))*100, 2), '%')) AS Cumulative_conversion_rate
FROM filtered_funnel
;

-- ------------------------------------------------------2) MOBILE VS DESKTOP-----------------------------------------------------------------------

WITH funnel AS (
SELECT 
	'                 HOME PAGE' AS page,
    device, 
    COUNT(*) AS users
FROM
    user_table u
        JOIN
    home_page_table h ON h.user_id = u.user_id
GROUP BY page, device
UNION ALL
SELECT
	'               SEARCH PAGE' AS page,
    device, 
    COUNT(*) AS users
FROM
    user_table u
        JOIN
    search_page_table h ON h.user_id = u.user_id
GROUP BY page, device
UNION ALL 
SELECT
'              PAYMENT PAGE' AS page,
	device,
	COUNT(*) AS users
FROM 
	user_table u
		JOIN
	payment_page_table h ON h.user_id = u.user_id
GROUP BY page, device
UNION ALL
SELECT
' PAYMENT CONFIRMATION PAGE' AS page,
	device,
	COUNT(*) AS users
FROM 
	user_table u
		JOIN
	payment_confirmation_table h ON h.user_id = u.user_id
GROUP BY page, device
), filtered_funnel AS (
SELECT page, 
SUM(CASE WHEN device = 'Mobile' THEN users ELSE 0 END) AS Mobile, 
SUM(CASE WHEN device = 'Desktop' THEN users ELSE 0 END) AS Desktop FROM funnel
GROUP BY page)

SELECT page,
CONCAT(Mobile, '  vs  ', Desktop) AS Mobile_vs_Desktop, 
CONCAT(CONCAT(ROUND((Mobile / LAG(Mobile, 1, Mobile) OVER()) * 100, 2), '%'), '  vs  ', CONCAT(ROUND((Desktop / LAG(Desktop, 1, Desktop) OVER()) * 100, 2), '%')) AS Conversion_rate, 
CONCAT(CONCAT(ROUND(100 - (Mobile / LAG(Mobile, 1, Mobile) OVER()) * 100, 2), '%'), '  vs  ', CONCAT(ROUND(100 - (Desktop / LAG(Desktop, 1, Desktop) OVER()) * 100, 2), '%')) AS Drop_off_rate,
CONCAT(CONCAT(ROUND((Mobile / (SELECT MAX(Mobile) FROM filtered_funnel))*100, 2), '%'), '  vs  ', CONCAT(ROUND((Desktop / (SELECT MAX(Desktop) FROM filtered_funnel))*100, 2), '%')) AS Cumulative_conversion_rate
FROM filtered_funnel
; 

-- ---------------------------------------3) Mobile vs Desktop furthur segmented by Gender ------------------------------------------------------------------------

WITH funnel AS (
SELECT 	'                 HOME PAGE' AS page, device, sex, COUNT(*) AS users FROM user_table u
JOIN home_page_table h ON h.user_id = u.user_id
GROUP BY page, device, sex
UNION ALL
SELECT 	'               SEARCH PAGE' AS page, device, sex, COUNT(*) AS users FROM user_table u
JOIN search_page_table h ON h.user_id = u.user_id
GROUP BY page, device, sex
UNION ALL
SELECT '              PAYMENT PAGE' AS page, device, sex, COUNT(*) AS users FROM user_table u
JOIN payment_page_table h ON h.user_id = u.user_id
GROUP BY page, device, sex
UNION ALL
SELECT ' PAYMENT CONFIRMATION PAGE' AS page, device, sex, COUNT(*) AS users FROM user_table u
JOIN payment_confirmation_table h ON h.user_id = u.user_id
GROUP BY page, device, sex
), filtered_funnel AS (
SELECT page, sex, SUM(CASE WHEN device = 'Mobile' THEN users END) AS Mobile, SUM(CASE WHEN device = 'Desktop' THEN users END) AS Desktop FROM funnel
GROUP BY page, sex
)
-- FEMALE
SELECT page, sex,
CONCAT(Mobile, '  vs  ', Desktop) AS Mobile_vs_Desktop, 
CONCAT(CONCAT(ROUND((Mobile / LAG(Mobile, 1, Mobile) OVER()) * 100, 2), '%'), '  vs  ', CONCAT(ROUND((Desktop / LAG(Desktop, 1, Desktop) OVER()) * 100, 2), '%')) AS Conversion_rate, 
CONCAT(CONCAT(ROUND(100 - (Mobile / LAG(Mobile, 1, Mobile) OVER()) * 100, 2), '%'), '  vs  ', CONCAT(ROUND(100 - (Desktop / LAG(Desktop, 1, Desktop) OVER()) * 100, 2), '%')) AS Drop_off_rate,
CONCAT(CONCAT(ROUND((Mobile / (SELECT MAX(Mobile) FROM filtered_funnel))*100, 2), '%'), '  vs  ', CONCAT(ROUND((Desktop / (SELECT MAX(Desktop) FROM filtered_funnel))*100, 2), '%')) AS Cumulative_conversion_rate
FROM filtered_funnel
WHERE sex = 'Female'
;
-- MALE
SELECT page, sex,
CONCAT(Mobile, '  vs  ', Desktop) AS Mobile_vs_Desktop, 
CONCAT(CONCAT(ROUND((Mobile / LAG(Mobile, 1, Mobile) OVER()) * 100, 2), '%'), '  vs  ', CONCAT(ROUND((Desktop / LAG(Desktop, 1, Desktop) OVER()) * 100, 2), '%')) AS Conversion_rate, 
CONCAT(CONCAT(ROUND(100 - (Mobile / LAG(Mobile, 1, Mobile) OVER()) * 100, 2), '%'), '  vs  ', CONCAT(ROUND(100 - (Desktop / LAG(Desktop, 1, Desktop) OVER()) * 100, 2), '%')) AS Drop_off_rate,
CONCAT(CONCAT(ROUND((Mobile / (SELECT MAX(Mobile) FROM filtered_funnel))*100, 2), '%'), '  vs  ', CONCAT(ROUND((Desktop / (SELECT MAX(Desktop) FROM filtered_funnel))*100, 2), '%')) AS Cumulative_conversion_rate
FROM filtered_funnel
WHERE sex = 'Male'
;

-- --------------------------------------------------MONTHLY FUNNEL ANALYSIS --------------------------------------------------------------------

WITH funnel_month AS (
SELECT 'HOME PAGE' AS page, SUM(CASE WHEN MONTH(date) = 1 THEN 1 END) AS Jan, 
SUM(CASE WHEN MONTH(date) = 2 THEN 1 END) AS Feb,
SUM(CASE WHEN MONTH(date) = 3 THEN 1 END) AS Mar,
SUM(CASE WHEN MONTH(date) = 4 THEN 1 END) AS April
FROM user_table u
JOIN home_page_table h ON h.user_id = u.user_id
GROUP BY page
UNION ALL
SELECT 'SEARCH PAGE' AS page, SUM(CASE WHEN MONTH(date) = 1 THEN 1 END) AS Jan, 
SUM(CASE WHEN MONTH(date) = 2 THEN 1 END) AS Feb,
SUM(CASE WHEN MONTH(date) = 3 THEN 1 END) AS Mar,
SUM(CASE WHEN MONTH(date) = 4 THEN 1 END) AS April
FROM user_table u
JOIN search_page_table h ON h.user_id = u.user_id
GROUP BY page
UNION ALL
SELECT 'PAYMENT PAGE' AS page, SUM(CASE WHEN MONTH(date) = 1 THEN 1 END) AS Jan, 
SUM(CASE WHEN MONTH(date) = 2 THEN 1 END) AS Feb,
SUM(CASE WHEN MONTH(date) = 3 THEN 1 END) AS Mar,
SUM(CASE WHEN MONTH(date) = 4 THEN 1 END) AS April
FROM user_table u
JOIN payment_page_table h ON h.user_id = u.user_id
GROUP BY page
UNION ALL
SELECT 'PAYMENT CONFIRMATION PAGE' AS page, SUM(CASE WHEN MONTH(date) = 1 THEN 1 END) AS Jan, 
SUM(CASE WHEN MONTH(date) = 2 THEN 1 END) AS Feb,
SUM(CASE WHEN MONTH(date) = 3 THEN 1 END) AS Mar,
SUM(CASE WHEN MONTH(date) = 4 THEN 1 END) AS April
FROM user_table u
JOIN payment_confirmation_table h ON h.user_id = u.user_id
GROUP BY page)

-- --------------------------------------------------January month funnel analysis--------------------------------------------------------------------

SELECT page, Jan, CONCAT(ROUND((Jan / LAG(Jan, 1, Jan) OVER())*100, 2), '%') AS Conversion_rate, 
CONCAT(ROUND(100 - (Jan / LAG(Jan, 1, Jan) OVER())*100, 2), '%') AS Dropoff_rate,
CONCAT(ROUND((Jan / (SELECT MAX(Jan) FROM funnel_month))*100, 2), '%') AS Cumulative_Conversion_rate
FROM funnel_month
;

-- --------------------------------------------------February month funnel analysis--------------------------------------------------------------------

SELECT page, Feb, CONCAT(ROUND((Feb / LAG(Feb, 1, Feb) OVER())*100, 2), '%') AS Conversion_rate, 
CONCAT(ROUND(100 - (Feb / LAG(Feb, 1, Feb) OVER())*100, 2), '%') AS Dropoff_rate,
CONCAT(ROUND((Feb / (SELECT MAX(Feb) FROM funnel_month))*100, 2), '%') AS Cumulative_Conversion_rate
FROM funnel_month
;

-- --------------------------------------------------March month funnel analysis--------------------------------------------------------------------

SELECT page, Mar, CONCAT(ROUND((Mar / LAG(Mar, 1, Mar) OVER())*100, 2), '%') AS Conversion_rate, 
CONCAT(ROUND(100 - (Mar / LAG(Mar, 1, Mar) OVER())*100, 2), '%') AS Dropoff_rate,
CONCAT(ROUND((Mar / (SELECT MAX(Mar) FROM funnel_month))*100, 2), '%') AS Cumulative_Conversion_rate
FROM funnel_month
;

-- --------------------------------------------------April month funnel analysis--------------------------------------------------------------------

SELECT page, April, CONCAT(ROUND((April / LAG(April, 1, April) OVER())*100, 2), '%') AS Conversion_rate, 
CONCAT(ROUND(100 - (April / LAG(April, 1, April) OVER())*100, 2), '%') AS Dropoff_rate,
CONCAT(ROUND((April / (SELECT MAX(April) FROM funnel_month))*100, 2), '%') AS Cumulative_Conversion_rate
FROM funnel_month
;