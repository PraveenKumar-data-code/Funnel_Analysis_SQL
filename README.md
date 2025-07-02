# Funnel_Analysis_SQL

## Introduction

This repository contains a set of SQL scripts designed to analyze a user journey through a multi-stage sales funnel. The primary goal is to quantify user drop-offs, calculate conversion rates at each stage, and compare performance across user segments and time periods.

## Data Sources

* **`user_table`**: Contains user demographics (e.g., `user_id`, `sex`, `device`, `registration_date`).
* **Page Tables**: Four tables capturing page visits:

  * `home_page`
  * `search_page`
  * `payment_page`
  * `payment_confirmation_page`

Each page table logs `user_id` and `page` when a user accesses the respective page.

## Query Overview

### Metrics Used:

* **Conversion Rate**: Percentage of users advancing from the previous stage.
* **Drop-Off Rate**: Percentage of users lost at each stage.
* **Cumulative Conversion**: Percentage relative to the initial stage.

### Overall Funnel Analytics

Calculates total users at each funnel stage and calculates the above metrics at each page. 

Found out that only 0.5% of the initial users who landed on the home page completed the funnel.

### Segmented Funnel Analytics

Breaks down funnel metrics by user attributes and calculates the above metrics at each page.

#### Gender Comparison

Compares funnel performance between **Male** and **Female** users, computing conversion and drop-off rates separately.

At every stage of the funnel, Female users had better conversion rates. Overall, despite having less Female users compared to the male counterparts, most of them completed the funnel!

#### Device Comparison

Analyzes differences between **Mobile** and **Desktop** traffic through the funnel.

Mobile Users converted more than the Desktop ones.

#### Device × Gender Segment

Cross-segments by both `device` and `sex`, offering detailed insights for each subgroup.

Both the genders are having better Mobile conversion rates than the Desktop ones!

### Monthly Funnel Analysis

Assesses funnel metrics on a monthly basis (January–April), capturing seasonality and temporal trends.

Overall, Conversion rates dropped steadily from Jan to April!
