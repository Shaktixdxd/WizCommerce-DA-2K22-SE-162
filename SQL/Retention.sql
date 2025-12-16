/* =========================================================
   FILE: Retention.sql

   PURPOSE:
   - Calculate weekly retention of users after signup
   - Measure how many users are active in Week 0, 1, 2, 3…
========================================================= */

-- ---------------------------------------------------------
-- WEEKLY RETENTION COHORT ANALYSIS
-- ---------------------------------------------------------

WITH user_activity AS (
    SELECT
        u.user_id,
        FLOOR(
            EXTRACT(EPOCH FROM (e.event_time - u.signup_date)) / 604800
        ) AS week_number
    FROM users  u
    JOIN events e
      ON e.user_id = u.user_id
),

base_cohort AS (
    SELECT COUNT(DISTINCT user_id) AS total_users
    FROM users
)

SELECT
    ua.week_number,
    COUNT(DISTINCT ua.user_id) AS active_users,
    COUNT(DISTINCT ua.user_id) * 1.0
        / (SELECT total_users FROM base_cohort) AS retention_rate
FROM user_activity ua
WHERE ua.week_number >= 0
GROUP BY ua.week_number
ORDER BY ua.week_number;
