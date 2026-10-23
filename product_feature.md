# Part 4 – Product’s New Feature Challenge

## Exploration Plan

 compare new users who installed before vs. after February 18, 2025, focusing on four main areas.

### Progression

- Percentage of users reaching Level 20
- Percentage of users reaching Level 25
- Percentage of users reaching Levels 30, 40, 50, etc.
- Time from Level 20 to Level 25

### Engagement

- Activity before reaching Level 25
- Activity on the Level 25 day
- Activity after reaching Level 25
- Rolls before Level 25
- Rolls on the Level 25 day
- Rolls after Level 25
- Progression in levels per day after Level 25

### Retention

- D1, D7, D14, and D30 retention
- Retention among users who reached Level 20
- Retention among users who reached Level 25

### Monetization

- Revenue before reaching Level 25
- Revenue on the Level 25 day
- Revenue after reaching Level 25
- Conversion from non-paying to paying users after Level 25

look for differences between the pre- and post-launch cohorts, with particular attention to what happens around Level 25, when the feature becomes available.

Specifically:

- **Higher progression:** More post-launch users reaching Level 25 and continuing to Levels 30, 40, and 50.
- **Faster progression:** A shorter time from Level 20 to Level 25 after the feature launch.
- **Higher engagement:** More activity and rolls after reaching Level 25 compared with the pre-launch cohort.
- **Higher retention:** Users who reach Level 25 returning to the game at higher rates after the feature launch.
- **Higher monetization:** More revenue after Level 25 and more previously non-paying users converting to paying users.
- **A change specifically around Level 25:** The most interesting pattern would be if behavior is relatively similar before Level 25 but changes after users reach Level 25 in the post-launch cohort.

check whether these patterns are consistent across platform, country, media source, and campaign, to make sure the observed differences are not simply caused by a change in the type of users being acquired.

## SQL & Analytical Thinking

**3 simple graphs to illustrate the potential effect of the new feature on new users’ behavior.**


### Graph 1 — User Progression

**Chart type:** Line chart comparing progression milestones between the two cohorts.

- **X-axis:** Level milestone — 20, 25, 30, 40, 50
- **Y-axis:** Percentage of new users reaching the milestone
- **Cohorts:**
  - Pre-feature cohort — users who installed before February 18, 2025
  - Post-feature cohort — users who installed on or after February 18, 2025
- **Population:** All new users in the respective cohort
- **Observation window:** First 30 days after installation

### Graph 2 — Engagement Around Level 25

**Chart type:** Grouped bar chart comparing roll activity between the two cohorts.

- **X-axis:** Period relative to the first Level 25 day — Before Level 25, Level 25 day, After Level 25
- **Y-axis:** Average rolls per active day
- **Cohorts:**
  - Pre-feature cohort — users who installed before February 18, 2025
  - Post-feature cohort — users who installed on or after February 18, 2025
- **Population:** Users who reached Level 25
- **Observation window:** A fixed number of days before and after the first Level 25 day, using the same window for both cohorts

### Graph 3 — Conversion From Non-Paying to Paying After Level 25

**Chart type:** 100% stacked bar chart comparing monetization conversion between the two cohorts.

- **X-axis:** Cohort
  - Pre-feature cohort
  - Post-feature cohort
- **Y-axis:** Percentage of users
- **Cohorts:**
  - Pre-feature cohort — users who installed before February 18, 2025
  - Post-feature cohort — users who installed on or after February 18, 2025
- **Population:** Users who reached Level 25, had no revenue before their first Level 25 day, and had sufficient follow-up time after Level 25
- **Observation window:** 30 days after the first Level 25 day
- **Segments:**
  - Stayed non-paying after Level 25
  - Converted to paying after Level 25

## Behavioral Validation

Compare the social engagement rate between:

- **Pre-feature cohort:** Users who installed before February 18, 2025
- **Post-feature cohort:** Users who installed on or after February 18, 2025

Check whether `invite_friend` activity increases specifically after users reach Level 25, rather than simply increasing after February 18 for all users.

Compare:

- Users who have not yet reached Level 25
- Users who have reached Level 25

Segment the analysis by:

- Platform
- Country
- Media source
- Campaign

Check whether the increase is consistent across segments, rather than being driven by a change in the user mix.
