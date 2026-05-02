# Employee Attrition Analysis

## Overview
This project investigates the root causes of employee attrition at a simulated 
mid-sized organization of 500 employees. Using a relational database built from 
scratch in MySQL, the analysis identifies which departments, roles, and employee 
profiles are most at risk — and provides data-driven recommendations to reduce turnover.

> **Note:** The dataset used in this project is simulated and intended to replicate 
> a real-world HR analytics scenario.

## Database Structure
The database consists of 6 interrelated tables:

| Table | Description |
|---|---|
| `employees` | Core employee demographics, satisfaction scores, and job info |
| `departments` | Department names, heads, and office locations |
| `job_roles` | Role titles, levels, and job families |
| `salary_bands` | Compensation tiers with min/max salary ranges |
| `performance_reviews` | Historical performance ratings per employee |
| `exit_reasons` | Termination records, exit type, and reasons |

## Tools & Concepts
- **Database:** MySQL
- **Skills demonstrated:** Database design, JOINs, subqueries, CASE statements,
aggregations, GROUP BY, HAVING, and calculated fields

## Key Findings

**1. Overall attrition rate is 21.4%** — significantly above the typical industry 
benchmark of 10–15%, indicating a systemic retention problem.

**2. Customer Support is the highest-risk department (32.9% attrition rate)**, 
followed by Sales (24.0%) and Operations (23.2%).

**3. Compensation is a primary driver of attrition.**
Lower salary bands show dramatically higher attrition rates:

| Salary Band | Attrition Rate |
|---|---|
| Band A (lowest) | 31.3% |
| Band B | 24.2% |
| Band C | 17.9% |
| Band D | 13.9% |
| Band E (highest) | 8.9% |

Employees in the lowest salary band are nearly 4x more likely to leave than 
those in the highest band.

**4. Lower performance is associated with higher attrition.**

| Performance Group | Attrition Rate |
|---|---|
| Low | 34.4% |
| Medium | 23.9% |
| High | 17.4% |

This suggests disengaged or underperforming employees are more likely to exit — 
either voluntarily or involuntarily.

**5. Overtime is the single strongest predictor of attrition.** Employees working 
overtime leave at a significantly higher rate regardless of department or role.

**6. Younger employees are more likely to leave.** The under-25 age group shows 
the highest attrition rates across all departments, with an attrition rate of 28.9%.

**7. The highest-risk employee profile** is: overtime + low satisfaction + low 
performance, with an attrition rate of 46.9% — nearly 1 in 2 employees in 
this group will leave.

## Recommendations

- **Immediate review of Customer Support** — address compensation, workload 
distribution, and management practices in this department as a priority
- **Audit overtime policies** — identify roles with chronic overtime and assess 
whether additional headcount or process improvements are needed
- **Targeted retention incentives for lower salary bands** — the steep attrition 
gradient across salary bands suggests compensation adjustments in Band A and B 
could have an outsized impact on overall retention
- **Proactive HR intervention** — employees flagged with overtime, low satisfaction, 
and declining performance represent a 46.9% attrition risk and should trigger 
immediate check-ins before attrition occurs

## Files
| File | Description |
|---|---|
| `employee_attrition_analysis.sql` | Full schema creation and all analysis queries |
| `data_inser.sql` | Sample data used to populate the database |
