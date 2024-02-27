USE bankloans;

SELECT * FROM loan_details;

UPDATE loan_details
SET issue_date=str_to_date(issue_date,"%d-%m-%Y");

ALTER TABLE loan_details
MODIFY issue_date date;

-- TOTAL LOAN APPLICATIONS
SELECT COUNT(id) Total_Loan_Applications FROM loan_details;

-- MTD LOAN APPLICATIONS
SELECT COUNT(id) MTD_Loan_Applications FROM loan_details
WHERE MONTH(issue_date)=12 AND YEAR(issue_date)=2021;

-- PMTD LOAN APPLICATIONS
SELECT COUNT(id) PMTD_Loan_Applications FROM loan_details
WHERE MONTH(issue_date)=11 AND YEAR(issue_date)=2021;

-- TOTAL FUNDED AMOUNT
SELECT SUM(loan_amount) Total_Funded_Amount FROM loan_details;

-- MTD FUNDED AMOUNT
SELECT SUM(loan_amount) MTD_Funded_Amount FROM loan_details
WHERE MONTH(issue_date)=12 AND YEAR(issue_date)=2021;

-- PMTD FUNDED AMOUNT
SELECT SUM(loan_amount) PMTD_Funded_Amount FROM loan_details
WHERE MONTH(issue_date)=11 AND YEAR(issue_date)=2021;

-- TOTAL AMOUNT RECEIVED
SELECT SUM(total_payment) Total_Amount_Received FROM loan_details;

-- MTD AMOUNT RECEIVED
SELECT SUM(total_payment) MTD_Amount_Received FROM loan_details
WHERE MONTH(issue_date)=12 AND YEAR(issue_date)=2021;

-- PMTD AMOUNT RECEIVED
SELECT SUM(total_payment) PMTD_Amount_Received FROM loan_details
WHERE MONTH(issue_date)=11 AND YEAR(issue_date)=2021;

-- AVERAGE INTEREST RATE
SELECT ROUND(AVG(int_rate)*100,2) Avg_Interest_rate FROM loan_details;

-- MTD AVERAGE INTEREST RATE
SELECT ROUND(AVG(int_rate)*100,2) MTD_Avg_Interest_rate FROM loan_details
WHERE MONTH(issue_date)=12 AND YEAR(issue_date)=2021;

-- PMTD AVERAGE INTEREST RATE
SELECT ROUND(AVG(int_rate)*100,2) PMTD_Avg_Interest_rate FROM loan_details
WHERE MONTH(issue_date)=11 AND YEAR(issue_date)=2021;

-- AVERAGE DTI RATE
SELECT ROUND(AVG(dti)*100,2) Avg_DTI FROM loan_details;

-- MTD DTI RATE
SELECT ROUND(AVG(dti)*100,2) MTD_Avg_DTI FROM loan_details
WHERE MONTH(issue_date)=12 AND YEAR(issue_date)=2021;

-- PMTD DTI RATE
SELECT ROUND(AVG(dti)*100,2) PMTD_Avg_DTI FROM loan_details
WHERE MONTH(issue_date)=11 AND YEAR(issue_date)=2021;

-- GOOD LOAN APPLICATION PERCENTAGE
SELECT 
(COUNT(CASE WHEN loan_status="Fully Paid" OR loan_status="Current" THEN id END)*100)
/
COUNT(id) Good_loan_Application_Percentage
FROM loan_details;

-- GOOD LOAN APPLICATIONS
SELECT COUNT(id) Good_Loan_Applications
FROM loan_details
WHERE loan_status="Fully Paid" OR loan_status="Current";

-- GOOD LOAN FUNDED AMOUNT
SELECT SUM(loan_amount) Good_Loan_Funded_Amount
FROM loan_details
WHERE loan_status="Fully Paid" OR loan_status="Current";

-- GOOD LOAN TOTAL RECEIVED AMOUNT
SELECT SUM(total_payment) Good_Loan_Received_Amount
FROM loan_details
WHERE loan_status="Fully Paid" OR loan_status="Current";

-- BAD LOAN APPLICATION PERCENTAGE
SELECT 
(COUNT(CASE WHEN loan_status="Charged Off"THEN id END)*100)
/
COUNT(id) Bad_loan_Application_Percentage
FROM loan_details;

-- BAD LOAN APPLICATIONS
SELECT COUNT(id) Bad_Loan_Applications
FROM loan_details
WHERE loan_status="Charged Off";

-- BAD LOAN FUNDED AMOUNT
SELECT SUM(loan_amount) Bad_Loan_Funded_Amount
FROM loan_details
WHERE loan_status="Charged Off";

-- BAD LOAN TOTAL RECEIVED AMOUNT
SELECT SUM(total_payment) Bad_Loan_Received_Amount
FROM loan_details
WHERE loan_status="Charged Off";

-- LOAN STATUS GRID VIEW
SELECT
loan_status,
COUNT(id) AS Total_Loan_Applications,
SUM(total_payment) AS Total_Amount_Received,
SUM(loan_amount) AS Total_Funded_Amount,
AVG(int_rate * 100) AS Interest_Rate,
AVG(dti * 100) AS DTI
FROM loan_details
GROUP BY loan_status;

SELECT loan_status,
SUM(total_payment) AS MTD_Amount_Received,
SUM(loan_amount) AS MTD_Funded_Amount
FROM loan_details
WHERE MONTH(issue_date)=12 AND YEAR(issue_date)=2021
GROUP BY loan_status;

-- MONTHLY TREND BY ISSUE DATE
SELECT MONTH(issue_date) AS Month_Munber, 
MONTHNAME(issue_date) AS Month_name, 
COUNT(id) AS Total_Loan_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Amount_Received
FROM loan_details
GROUP BY MONTH(issue_date), MONTHNAME(issue_date)
ORDER BY MONTH(issue_date);

-- REGION 
SELECT address_state, 
COUNT(id) AS Total_Loan_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Amount_Received
FROM loan_details
GROUP BY address_state
ORDER BY address_state;

-- TERM
SELECT term, 
COUNT(id) AS Total_Loan_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Amount_Received
FROM loan_details
GROUP BY term
ORDER BY term;

-- EMPLOYEE LENGTH
SELECT emp_length, 
COUNT(id) AS Total_Loan_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Amount_Received
FROM loan_details
GROUP BY emp_length
ORDER BY emp_length;

-- PURPOSE
SELECT purpose, 
COUNT(id) AS Total_Loan_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Amount_Received
FROM loan_details
GROUP BY purpose
ORDER BY purpose;


-- HOMEOWNERSHIP
SELECT home_ownership, 
COUNT(id) AS Total_Loan_Applications,
SUM(loan_amount) AS Total_Funded_Amount,
SUM(total_payment) AS Total_Amount_Received
FROM loan_details
GROUP BY home_ownership
ORDER BY home_ownership;








