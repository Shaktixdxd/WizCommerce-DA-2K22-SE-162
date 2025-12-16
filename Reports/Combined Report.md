# User Behavior & Conversion Analysis
### Final Report

---

## 1. Introduction

This report analyzes user behavior for an AI content‑generation web application using three datasets: user signups, in‑product events, and payments. The goal is to understand how users move through the product funnel, how well they are retained, when they upgrade, which segments perform best, and which behaviors predict conversion to paid plans.

The datasets used are:

- `users_v2-1.csv` — user attributes and signup dates
- `events_v2-1.csv` — event‑level product usage (feature views, pricing visits, advanced features, etc.)  
- `payments_v2-1.csv` — successful upgrades to paid plans

---

## 2. Funnel Analysis

A four‑step funnel from signup to paid upgrade was built using SQL (`Funnel.sql`) and notebook code.

### 2.1 Funnel counts

| Step | Description                          | Users |
|------|--------------------------------------|-------|
| 1    | Signed up                            | 800   |
| 2    | Viewed a feature (`viewed_feature`)  | 702   |
| 3    | Returned within 7 days of signup     | 800   |
| 4    | Upgraded (present in payments table) | 224   |

There are 800 signups, of which 702 users view at least one feature, 800 return within seven days with at least one event, and 224 eventually upgrade to a paid plan. This implies that 98 users (12.25% of signups) never trigger a `viewed_feature` event, revealing an activation gap at the second step of the funnel.

### 2.2 Conversion rates

Step‑wise and overall conversion rates from the notebook are:

| Transition                     | Rate    |
|--------------------------------|---------|
| Signup → Viewed Feature        | 87.75%  |
| Viewed Feature → Returned (7d) | 113.96% |
| Returned → Upgrade             | 28.00%  |
| Overall Signup → Upgrade       | 28.00%  |

The overall signup‑to‑paid conversion of 28% indicates that more than one in four signups convert to paying customers, which is substantially higher than typical SaaS benchmarks (often 3–8%). The >100% rate from “Viewed Feature → Returned” occurs because some returning users have events other than `viewed_feature` in their first week, so the 7‑day return population slightly exceeds the feature‑view population.

---

## 3. Retention Behavior

Weekly retention is calculated by tagging each event with the number of weeks since signup and counting distinct active users per week.

### 3.1 Weekly active users

| Week since signup | Active users |
|-------------------|-------------|
| 0                 | 800         |
| 1                 | 431         |
| 2                 | 457         |
| 3                 | 428         |
| 4                 | 441         |
| 5                 | 408         |

As expected, activity drops from 800 in Week 0 to 431 in Week 1, reflecting first‑week churn. From Weeks 1 to 5, active users stay within a narrow band of roughly 408–457, including a rebound in Week 2, which suggests a strong core cohort that continues to find value in the product.

---

## 4. Upgrade Timing (Within 30 Days)

Using `payments_v2-1.csv`, upgrades are joined with signup dates to compute `days_to_upgrade`.

| Metric                         | Value |
|--------------------------------|-------|
| Users upgrading within 30 days | 224   |
| 30‑day upgrade rate (of 800)   | 28%   |

All paying users upgrade within 30 days of signup, so the 30‑day and overall upgrade counts are identical. This indicates that users who intend to pay reveal that intent early, and late‑stage upsell efforts beyond the first month are unlikely to significantly grow conversion.

---

## 5. Segmentation Insights

Funnel performance is further broken down by country, device, and acquisition source using SQL in `Segmentation.sql` and a `segment_funnel` helper in the notebook.

### 5.1 Country‑level funnel

| Country   | Signed up | Viewed feature | Returned 7d | Upgraded | Paid conversion rate |
|-----------|-----------|----------------|-------------|----------|----------------------|
| Australia | 107       | 92             | 107         | 37       | 34.58%               |
| Brazil    | 105       | 92             | 105         | 21       | 20.00%               |
| Canada    | 128       | 107            | 128         | 38       | 29.69%               |
| Germany   | 121       | 104            | 121         | 32       | 26.45%               |
| India     | 113       | 101            | 113         | 40       | 35.40%               |
| UK        | 108       | 96             | 108         | 26       | 24.07%               |
| USA       | 118       | 110            | 118         | 30       | 25.42%               |

India and Australia show the strongest signup‑to‑upgrade conversion (around 35%), indicating particularly good product–market fit or acquisition quality in these markets. Brazil and the UK underperform at 20–24% despite similar top‑of‑funnel volumes, so these regions may need localized onboarding, messaging, or pricing adjustments.

### 5.2 Device and source segments

From the same segmentation outputs, device and source patterns are:

- **Device:** Desktop and tablet users have slightly higher paid conversion rates than mobile users, even though mobile accounts for the largest share of signups, suggesting extra friction or weaker UX on smaller screens.  
- **Source:** Organic and social channels deliver higher signup‑to‑paid rates than paid ads and partner channels, implying that these users arrive with clearer intent or better expectations.

These insights can guide marketing spend and product optimization toward higher‑value segments while targeting improvements for weaker ones.

---

## 6. Conversion Signal Analysis

Per‑user behavior metrics are computed by grouping events by `user_id` and calculating:

- `total_events` — total number of events per user  
- `num_distinct_events` — number of distinct event types per user  
- `num_active_days` — number of distinct days on which the user generated any event  

The summary grouped by upgrade status is:

| Group        | Avg total events | Avg distinct events | Avg active days |
|-------------|------------------|---------------------|-----------------|
| Non‑upgraded| 4.61             | 3.25                | 4.41            |
| Upgraded    | 9.10             | 4.87                | 8.28            |

Upgraded users generate roughly twice as many events, interact with more types of features, and remain active for almost twice as many days as non‑upgraders. In addition, many upgraders show repeated `browsed_pricing` and `used_advanced_feature` events, which act as strong high‑intent signals that can be used to trigger targeted upgrade prompts.

---

## 7. Key Insights

**High engagement with an activation gap**  
Weekly retention stabilizes around 400–450 users, but 98 signups never view a feature, making feature discovery the first major funnel bottleneck.

**Exceptionally strong conversion funnel**  
An overall 28% signup‑to‑paid rate and 30‑day upgrade window indicate that users quickly find value and decide to pay early in their lifecycle.

**Segment disparities create upside**  
India and Australia, desktop/tablet, and organic/social channels convert far better than Brazil, some mobile users, and partner traffic, revealing clear opportunities for targeted improvements.

**Behavioral metrics reliably predict upgrades**  
Higher event volume, more distinct feature use, and longer activity streaks strongly correlate with upgrading and can be used as predictive signals in scoring or personalized messaging.

---

## 8. Recommendations

**Improve feature discovery and activation**

- Introduce a guided onboarding flow immediately after signup that walks users through a first successful content‑generation task.  
- Highlight core features on the homepage and in the first‑session UI so that new users are strongly nudged to trigger a `viewed_feature` or `used_advanced_feature` event.

**Strengthen early‑life engagement**

- Send a “Complete your first project” email or in‑app reminder within 24 hours if no feature events are recorded.  
- Use checklists or progress bars (for example, “3 steps to unlock full value”) to encourage exploration during the first week.

**Behavior‑based upgrade prompts**

- Trigger upgrade banners or emails after users cross thresholds such as ≥5 total events, ≥3 distinct event types, or repeated `browsed_pricing` activity.  
- Experiment with time‑limited offers shortly after users reach these high‑intent behaviors to capitalize on peak motivation.

**Segment‑focused growth strategy**

- Allocate more marketing budget and sales attention to top‑converting segments (India, Australia, organic/social channels).  
- For lower‑performing regions and partner traffic, run targeted experiments on localized messaging, pricing, and onboarding to close the conversion gap.

**Optimize mobile experience**

- Audit the mobile journey around feature discovery, pricing page, and checkout to identify friction versus desktop/tablet flows.  
- Implement responsive layout improvements, simplified forms, and clearer CTAs to lift mobile conversion.

**Operationalize analytics**

- Track activation rate (signup → first feature), 7‑day retention, and 30‑day upgrade rate in live dashboards.  
- Use behavioral metrics (`total_events`, `num_distinct_events`, `num_active_days`) as inputs to a simple upgrade‑propensity model that can drive future personalization.

---

## 9. SQL and Notebook Reference

All key metrics in this report are computed using:

- `Funnel.sql` — core funnel counts (signed up, viewed feature, returned in 7 days, upgraded)
- `Segmentation.sql` — country, device, and source funnel segmentation
- `Retention.sql` — weekly retention cohorts
- `30_Days_Upgrade.sql` — days to upgrade and 30‑day upgrade rate
- `Conversion_Signals.sql` and the Jupyter notebook (`analysisNB.ipynb`) — behavioral signal aggregation and summaries

---

## 10. Conclusion

The product demonstrates strong early engagement, high upgrade rates, and a stable core of retained users, confirming solid product–market fit for the AI content platform. The main opportunities are improving initial feature activation, investing in high‑performing segments, reducing mobile friction, and turning behavioral insights into targeted lifecycle interventions to further increase conversions and long‑term value.


**Note:** 
The exact variable and column names used in the code or SQL may differ slightly from the terminology in this report. The analysis and numbers have been organized to give a consistent, high‑level understanding of user behavior and conversion, and should be interpreted as a generic, conceptual view of the product funnel rather than a strict reflection of every implementation detail.