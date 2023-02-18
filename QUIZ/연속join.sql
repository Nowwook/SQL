-- https://www.hackerrank.com/challenges/the-company/problem


- INENR JOIN 사용
SELECT company.company_code, company.founder, lead.lead_count, senior.senior_count, manager.manager_count, employee.employee_count
FROM company
 INNER JOIN (SELECT company_code, COUNT(DISTINCT(lead_manager_code)) AS lead_count
             FROM lead_manager
             GROUP BY company_code) lead ON company.company_code = lead.company_code
 INNER JOIN (SELECT company_code, COUNT(DISTINCT(senior_manager_code)) AS senior_count
             FROM senior_manager
             GROUP BY company_code) senior ON company.company_code = senior.company_code
 INNER JOIN (SELECT company_code, COUNT(DISTINCT(manager_code)) AS manager_count
             FROM manager
             GROUP BY company_code) manager ON company.company_code = manager.company_code
 INNER JOIN (SELECT company_code, COUNT(DISTINCT(employee_code)) AS employee_count
             FROM employee
             GROUP BY company_code) employee ON company.company_code = employee.company_code
ORDER BY company.company_code


- WHERE 사용
SELECT c.company_code, c.founder,
       COUNT(DISTINCT(l.lead_manager_code)), COUNT(DISTINCT(s.senior_manager_code)),
       COUNT(DISTINCT(m.manager_code)), COUNT(DISTINCT(e.employee_code))
FROM company c, lead_manager l, senior_manager s, manager m, employee e
WHERE c.company_code = l.company_code AND
      l.lead_manager_code = s.lead_manager_code AND
      s.senior_manager_code = m.senior_manager_code AND
      m.manager_code = e.manager_code
GROUP BY c.company_code, c.founder 
ORDER BY c.company_code
