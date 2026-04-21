# Programme-Performance-Metrics
End-to-end exam performance analysis for 6 programmes using MySQL and Power BI

![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-F2C811?style=flat&logo=powerbi&logoColor=black)
![Excel](https://img.shields.io/badge/Excel-217346?style=flat&logo=microsoftexcel&logoColor=white)

## Project Overview

This project analyses exam performance data for participants enrolled in technology programmes covering the years 2023 and 2024. The analysis covers 535 participants across 6 programmes and 17 professional certification exams.

The goal is to identify performance trends, highlight at-risk participants, and provide actionable insights for programme managers through an interactive Power BI dashboard.

---

## Tools Used

| Tool | Purpose |
|------|---------|
| Microsoft Excel | Data cleaning and preparation |
| MySQL | Data storage and SQL analysis |
| Power BI | Interactive dashboard and visualisation |

---

## Dataset

| Field | Description |
|-------|-------------|
| Programme | Programme code (GAIP, GCSP, GCTP, GCCP, GSAP, GACP) |
| Cohort | Cohort group (C1 to C9) |
| Year | Year of enrolment (2023 or 2024) |
| Name | Participant full name |
| Status | Enrolment status (Active or Terminate) |
| Exam | Exam name |
| attempt_1 to attempt_6 | Attempt result (1 = pass, 0 = fail, NULL = not attempted) |

**Dataset size:** 1,478 exam records across 535 unique participants

---

## Data Cleaning

Before analysis, two issues were identified and fixed in Excel:

1. **Trailing space** — `Certified Ethical Hacker ` had a trailing space affecting 75 rows in the GCTP programme. Fixed using Find & Replace.

2. **Duplicate name** — `Mohd Faiz Zar'Ie Mohd Fauzi` and `Mohd Faiz Zar'ie Mohd Fauzi` were the same person entered with different capitalisation, causing the participant count to show 536 instead of 535. Standardised to one consistent spelling.

---

## SQL Analysis

The analysis is structured into 7 sections covering 28 queries:

### Section 1 — Participant Overview
- Total participants, by status, by programme, by cohort, by year

### Section 2 — Exam Attempt Analysis
- Total exam records, candidates per exam, average attempts to pass, pass distribution by attempt number, first attempt pass rate

### Section 3 — Programme Performance
- Pass rate per programme, average attempts per cohort, year-over-year comparison, cohort trend analysis

### Section 4 — Exam Level Insights
- Pass rate per exam, total sittings vs passes vs fails, hardest exams ranked by avg attempts, cross-tab pass rate by programme and exam

### Section 5 — Learner Progress Tracking
- Students who never attempted, passed on first attempt, needed multiple attempts, never passed, at-risk summary by cohort

### Section 6 — Status-Based Insights
- Pass rate comparison Active vs Terminate, exam records per status, termination rate per programme

### Section 7 — Advanced Views
- ExamAttempts view, year-over-year comparison using view, full learner summary table

---

## Key Findings

### Overall Performance
- **535 participants** enrolled across 6 programmes
- **92.71% overall pass rate** across all exam records
- **211 straight passers (39.44%)** — passed all exams on first attempt
- **9.35% termination rate** — 50 participants terminated

### Programme Performance
| Programme | Pass Rate | Avg Attempts | Termination Rate |
|-----------|-----------|--------------|-----------------|
| GACP | 100.00% | 1.0 | 0.00% |
| GCTP | 100.00% | 1.5 | 1.33% |
| GAIP | 99.00% | 2.0 | 1.00% |
| GCSP | 99.00% | 1.1 | 2.00% |
| GSAP | 94.62% | 1.3 | 6.45% |
| GCCP | 76.67% | 2.0 | 28.00% |

### CISCO Exams — Most Challenging
CISCO exams consistently ranked as the hardest across both pass rate and average attempts:

| Exam | Pass Rate | Avg Attempts |
|------|-----------|--------------|
| CISCO SWSA | 72.00% | 1.83 |
| CISCO SCOR | 72.67% | 2.28 |
| CISCO CCNA | 76.67% | 1.76 |

### Active vs Terminated Participants
One of the strongest findings in the analysis:
- **Active participants → 100% pass rate**
- **Terminated participants → 22% pass rate**

78% of terminated students never passed a single exam, suggesting a strong correlation between programme engagement and exam success.

### GCCP Year-over-Year Improvement
Despite being the weakest programme overall, GCCP showed significant improvement:

| Year | Pass Rate | Termination Rate |
|------|-----------|-----------------|
| 2023 | 62.50% | 50.00% |
| 2024 | 77.46% | 26.76% |

### At-Risk Participants
83 participants never attempted any exam across all 6 attempts:
- **GCCP — 36 students** (largest at-risk group)
- **GSAP — 4 students**
- **GAIP — 1 student**

GCCP requires the most urgent intervention for participant re-engagement.

---

## Dashboard

The interactive Power BI dashboard includes:

- **7 KPI cards** — Total Participants, Active, Terminated, Total Exams, Straight Passers, Overall Pass Rate, Termination Rate
- **8 charts** — Pass Rate by Programme, Pass Rate by Exam, Termination Rate by Programme, Average Attempts by Programme, Pass Rate by Year and Programme, Pass Rate by Status, At Risk Participants by Programme, Scatter Chart (Pass Rate vs Avg Attempts)
- **5 slicers** — Programme, Year, Cohort, Status, Exam


ata
