/* =========================================================
   FILE: Conversion_Signals.sql

   PURPOSE:
   - Compare behavior of upgraded vs non-upgraded users
   - Identify early signals correlated with conversion
========================================================= */

-- ---------------------------------------------------------
-- QUERY: USER BEHAVIOR METRICS + UPGRADE FLAG
-- ---------------------------------------------------------

WITH behavior AS (
    SELECT
        e.user_id,
        COUNT(*)                          AS total_events,
        COUNT(DISTINCT e.event_name)      AS distinct_events,
        COUNT(DISTINCT DATE(e.event_time)) AS active_days,
        MIN(e.event_time)                 AS first_event_time,
        MAX(e.event_time)                 AS last_event_time
    FROM events e
    GROUP BY e.user_id
),

first_feature AS (
    SELECT
        e.user_id,
        MIN(e.event_time) AS first_feature_time
    FROM events e
    WHERE e.event_name = 'viewed_feature'
    GROUP BY e.user_id
)

SELECT
    u.user_id,
    b.total_events,
    b.distinct_events,
    b.active_days,
    (b.last_event_time - b.first_event_time)      AS active_span,
    (ff.first_feature_time - u.signup_date)       AS time_to_first_feature,
    (pay.payment_date - u.signup_date)            AS time_to_upgrade,
    CASE
        WHEN pay.user_id IS NOT NULL THEN 1
        ELSE 0
    END                                           AS upgraded
FROM users u
LEFT JOIN behavior     b   ON u.user_id = b.user_id
LEFT JOIN first_feature ff  ON u.user_id = ff.user_id
LEFT JOIN payments     pay ON u.user_id = pay.user_id;
