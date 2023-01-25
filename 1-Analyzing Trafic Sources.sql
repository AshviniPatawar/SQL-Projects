use mavenfuzzyfactory;

# 1- The percentage of sessions that resulted in a revenue-producing sale for each campaign
SELECT 
    website_sessions.utm_content,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS Orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) * 100 AS conversion_rate
FROM
    website_sessions
        LEFT JOIN
    orders ON orders.website_session_id = website_sessions.website_session_id
GROUP BY 1
ORDER BY 2 DESC;

# 2- Analyzing top traffic sources based on UTM source, campaign, and referrer
SELECT 
    utm_source,
    utm_campaign,
    http_referer,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions
FROM
    website_sessions
GROUP BY 1 , 2 , 3
ORDER BY 4 DESC;

# 3- Based on the fact that gsearch nonbrand seems to be a major source of traffic, calculate the conversion rate
SELECT 
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS Orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) * 100 AS CVR
FROM
    website_sessions
        LEFT JOIN
    orders ON website_sessions.website_session_id = orders.website_session_id
WHERE
		website_sessions.utm_source = 'gsearch'
        AND website_sessions.utm_campaign = 'nonbrand'
;

# 4- Session trend analysis by Year and week
SELECT 
    YEAR(created_at),
    WEEK(created_at),
    MIN(DATE(created_at)),
    COUNT(DISTINCT website_session_id) AS sessions
FROM
    website_sessions
GROUP BY 1 , 2;

# 5- (Case Pivoting Method) By primary product id, showing a single order instance, multiple orders and total orders
SELECT 
    primary_product_id,
    COUNT(DISTINCT CASE
            WHEN items_purchased = 1 THEN order_id
            ELSE NULL
        END) AS ORDER_1,
    COUNT(DISTINCT CASE
            WHEN items_purchased = 2 THEN order_id
            ELSE NULL
        END) AS ORDER_2,
    COUNT(DISTINCT order_id) AS TOTAL_ORDER
FROM
    orders
GROUP BY 1
ORDER BY 1 ASC;

# 6- gsearch nonbrand trended volume session by week
SELECT 
    - - YEAR(created_at) AS year_of_sale,
    - - WEEK(created_at) AS week_of_sale,
    MIN(DATE(created_at)) AS Start_date,
    COUNT(DISTINCT website_session_id) AS sessions
FROM
    website_sessions
WHERE
    created_at < '2012-05-12'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY 1 , 2;

# 7- Conversion rates from session to order, by device type for gsearch nonbrand
SELECT 
    website_sessions.device_type,
    COUNT(website_sessions.website_session_id) AS SESSIONS,
    COUNT(orders.order_id) AS ORDERS,
    COUNT(orders.order_id) / COUNT(website_sessions.website_session_id) AS CRATE
FROM
    website_sessions
        LEFT JOIN
    orders ON website_sessions.website_session_id = ORDERS.website_session_id
WHERE
    website_sessions.created_at < '2012-05-11'
        AND website_sessions.utm_source = 'GSEARCH'
        AND website_sessions.utm_campaign = 'NONBRAND'
GROUP BY website_sessions.device_type;

# 8- weekly trend for both desptop and mobile for gsearch nonbrand
SELECT 
    YEAR(created_at) AS YR,
    WEEK(created_at) AS WK,
    COUNT(DISTINCT CASE
            WHEN device_type = 'MOBILE' THEN website_session_id
            ELSE NULL
        END) AS MOB,
    COUNT(DISTINCT CASE
            WHEN device_type = 'DESKTOP' THEN website_session_id
            ELSE NULL
        END) AS DESK,
    MIN(DATE(created_at)) AS WEEK_START
FROM
    website_sessions
WHERE
    created_at < '2012-06-09'
        AND created_at > '2012-04-15'
        AND utm_source = 'GSEARCH'
        AND utm_campaign = 'NONBRAND'
GROUP BY 1 , 2;
