CREATE DATABASE realistic_project;
USE realistic_projects;
CREATE TABLE employees (
	id INT PRIMARY KEY AUTO_INCREMENT,
    salary_band_id INT NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female') NOT NULL,
    age INT NOT NULL,
    hire_date TIMESTAMP DEFAULT NOW(),
    attrition_status ENUM('Active', 'Attrited') NOT NULL,
    department_id INT NOT NULL,
    job_role_id INT NOT NULL,
    job_satisfaction_score INT NOT NULL CHECK (job_satisfaction_score BETWEEN 1 AND 5),
    overtime_status ENUM('Yes', 'No') NOT NULL,
    FOREIGN KEY (department_id) REFERENCES departments (id),
    FOREIGN KEY (job_role_id) REFERENCES job_roles (id)
);

CREATE TABLE departments (
	id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    department_head VARCHAR(100) NOT NULL,
    location_id INT NOT NULL,
    FOREIGN KEY (location_id) REFERENCES locations (id)
);
    
SET FOREIGN_KEY_CHECKS = 0;
    
CREATE TABLE job_roles (
	id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(150) NOT NULL,
    job_level VARCHAR(100) NOT NULL,
    job_family VARCHAR(100) NOT NULL
);

CREATE TABLE salary_bands (
	id INT PRIMARY KEY AUTO_INCREMENT,
    salary_band_name VARCHAR(100) NOT NULL,
    min_salary DECIMAL(10,2) NOT NULL,
    max_salary DECIMAL(10,2) NOT NULL
);

CREATE TABLE locations (
	id INT PRIMARY KEY AUTO_INCREMENT,
    city VARCHAR(100) NOT NULL,
    province VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL,
    office_type VARCHAR(100) NOT NULL
);

CREATE TABLE performance_reviews (
	id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    review_date TIMESTAMP DEFAULT NOW(),
    performance_rating INT NOT NULL CHECK (performance_rating BETWEEN 1 AND 5),
    promotion_eligibility ENUM ('Yes', 'No') NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees (id)
);

CREATE TABLE exit_reasons (
	id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    termination_date DATE NOT NULL,
    exit_reason VARCHAR(300),
	exit_type ENUM ('Voluntary', 'Involuntary') NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employees (id)
);
    
SELECT * FROM locations;
SELECT * FROM departments;
SELECT * FROM job_roles;
SELECT * FROM salary_bands;
SELECT * FROM employees;
SELECT * FROM performance_reviews;
SELECT * FROM exit_reasons;

-- Attrition Rate: 

SELECT ((SELECT COUNT(id) FROM exit_reasons) /(SELECT COUNT(id) FROM employees))
AS attrition_rate;

-- Therefore, the overall attrition rate of the company is .2140

-- Which 3 departments have the highest attrition rate

SELECT 
	departments.id, 
    departments.name, 
	(COUNT(exit_reasons.id)) / (COUNT(employees.id)) AS attrition_rate
FROM departments
LEFT JOIN employees ON employees.department_id = departments.id 
LEFT JOIN exit_reasons ON exit_reasons.employee_id = employees.id
GROUP BY departments.id ORDER BY attrition_rate DESC LIMIT 3;

-- Therefore, 1) customer support (.3294), 2) sales (.24), and 3) operations (.2317)
-- are the departments with the highest attrition rates

-- Which 4 job roles experience the most attrition?

SELECT 
	job_roles.id,
    job_roles.role_name,
    (COUNT(exit_reasons.id)) / (COUNT(employees.id)) AS attrition_rate
FROM job_roles
LEFT JOIN employees ON employees.job_role_id = job_roles.id 
LEFT JOIN exit_reasons ON exit_reasons.employee_id = employees.id
GROUP BY job_roles.id ORDER BY attrition_rate DESC LIMIT 4;

-- The job roles that experience the most attrition are: 1) Customer support 
-- specialist (.3636), 2) Account executive (.2941), 3) Operations coordinator (.2766),
--  4) Financial analyst (.25). Notice that there is an obvious problem with customer
-- support.

-- Does salary level affect attrition?

SELECT
	salary_bands.id, 
    salary_bands. salary_band_name, 
    (COUNT(exit_reasons.id)) / (COUNT(employees.id)) AS attrition_rate
FROM salary_bands
LEFT JOIN employees ON employees.salary_band_id = salary_bands.id
LEFT JOIN exit_reasons ON exit_reasons.employee_id = employees.id
GROUP BY salary_bands.id;	

-- Therefore, lower salary levels is significantly associated with higher attrition 
-- rates. This might explain why customer service has the highest attrition level.

-- 	Does overtime correlate with attrition?

SELECT
	overtime_status,
    COUNT(overtime_status) AS total,
    COUNT(exit_reasons.id) AS attrited,
    (COUNT(exit_reasons.id)) / (COUNT(employees.id)) AS attrition_rate
FROM employees
LEFT JOIN exit_reasons ON employee_id = employees.id
GROUP BY overtime_status;
-- overtime significantly correlates with attrition

-- Does employee performance relate to attrition?

SELECT 
    CASE 
        WHEN avg_rating <= 2 THEN 'Low'
        WHEN avg_rating = 3 THEN 'Medium'
        ELSE 'High'
    END AS rating_group,
    COUNT(*) AS total,
    COUNT(exit_reasons.id) AS attrited,
    ROUND(COUNT(exit_reasons.id) * 1.0 / COUNT(*), 3) AS attrition_rate
FROM
(
    SELECT 
        employee_id,
        AVG(performance_rating) AS avg_rating
    FROM performance_reviews
    GROUP BY employee_id
) AS ratings
LEFT JOIN exit_reasons
    ON ratings.employee_id = exit_reasons.employee_id
GROUP BY rating_group
ORDER BY attrition_rate;
-- attrition rate correlates with lower employee performance

-- Does job satisfaction influence attrition?

SELECT 
	job_satisfaction_score,
    COUNT(job_satisfaction_score) AS total,
    COUNT(exit_reasons.id) AS attirted,
    (COUNT(exit_reasons.id)) / (COUNT(employees.id)) AS attrition_rate
FROM employees
LEFT JOIN exit_reasons ON exit_reasons.employee_id = employees.id
GROUP BY job_satisfaction_score ORDER BY job_satisfaction_score;
-- There is a negative correlation between job satisfaction score and attrition rate.

-- Are certain age groups more likely to leave?
SELECT 
	CASE
		WHEN age < 25 THEN '25-'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        ELSE '45+'
	END AS age_group,
    COUNT(*) AS total,
    COUNT(exit_reasons.id) AS attirted,
    (COUNT(exit_reasons.id)) / (COUNT(employees.id)) AS attrition_rate
FROM employees
LEFT JOIN exit_reasons ON exit_reasons.employee_id = employees.id
GROUP BY age_group ORDER BY age_group;
-- younger age groups are correlated with  higher attrition rate.

-- Which combination of factors indicates the highest risk?

SELECT 
	overtime_status AS overtime, 
    CASE 
		WHEN job_satisfaction_score <= 2 THEN 'Low'
        WHEN job_satisfaction_score = 3 THEN 'Medium'
        WHEN job_satisfaction_score >= 4 THEN 'High'
	END AS satisfaction,
    CASE 
		WHEN avg_rating <= 1.99999 THEN 'Low'
        WHEN avg_rating BETWEEN 2 AND 3.99999 THEN 'Medium'
        WHEN avg_rating >= 4 THEN 'High'
	END AS performance,
    COUNT(employees.id) AS total_employees,
    COUNT(exit_reasons.id) AS exited,
    (COUNT(exit_reasons.id)) / (COUNT(employees.id)) AS attrition
FROM 
(
SELECT 
	performance_reviews.employee_id,
    AVG(performance_rating) AS avg_rating FROM performance_reviews
    GROUP BY employee_id
) AS perf
JOIN employees ON employees.id = perf.employee_id
LEFT JOIN exit_reasons ON exit_reasons.employee_id = employees.id
WHERE perf.avg_rating IS NOT NULL
GROUP BY overtime, satisfaction, performance 
HAVING COUNT(DISTINCT employees.id) >= 10 
ORDER BY attrition DESC;

-- Therefore, overtime + low satisfaction + low performance is correlated 
-- with the highest attrition rate. Also, overtime is the biggest indicator that 
-- attrition would be high, followed by satisfaction, followed by performance.

