/* =========================================================
   FILE: Segmentation.sql

   PURPOSE:
   - Analyze funnel performance across user segments
   - Compare conversion rates by country, device, source
========================================================= */

-- ---------------------------------------------------------
-- FUNNEL SEGMENTATION BY COUNTRY, DEVICE, SOURCE
-- ---------------------------------------------------------

SELECT
    u.country,
    u.device,
    u.source,
    COUNT(DISTINCT u.user_id)      AS signed_up,
    COUNT(DISTINCT vf.user_id)     AS viewed_feature,
    COUNT(DISTINCT r7.user_id)     AS returned_7_days,
    COUNT(DISTINCT pay.user_id)    AS upgraded,
    COUNT(DISTINCT pay.user_id) * 1.0
        / COUNT(DISTINCT u.user_id) AS signup_to_upgrade_rate
FROM users u
LEFT JOIN (
    SELECT DISTINCT user_id
    FROM events
    WHERE event_name = 'viewed_feature'
) AS vf
    ON u.user_id = vf.user_id
LEFT JOIN (
    SELECT DISTINCT e.user_id
    FROM events e
    JOIN users u_sig
      ON e.user_id = u_sig.user_id
    WHERE e.event_time <= u_sig.signup_date + INTERVAL '7 days'
) AS r7
    ON u.user_id = r7.user_id
LEFT JOIN payments AS pay
    ON u.user_id = pay.user_id
GROUP BY
    u.country,
    u.device,
    u.source
ORDER BY
    signup_to_upgrade_rate DESC;
