create database hr_analyst;
use hr_analyst;

ALTER TABLE hr1
ADD COLUMN Attrition_Flag INT;

SET SQL_SAFE_UPDATES = 0;

UPDATE hr1
SET Attrition_Flag = 
    CASE 
        WHEN Attrition = 'Yes' THEN 1
        WHEN Attrition = 'No' THEN 0
        ELSE NULL
    END;
    
    ALTER TABLE hr2 
MODIFY worklifebalance_name VARCHAR(20);

    
    UPDATE hr2
SET worklifebalance_name = 
    CASE 
        WHEN WorkLifeBalance = 1 THEN 'Poor'
        WHEN WorkLifeBalance = 2 THEN 'Average'
         WHEN WorkLifeBalance = 3 THEN 'Good'
        WHEN WorkLifeBalance = 4 THEN 'Excellent'
        ELSE NULL
    END;
    
SELECT Attrition, Attrition_Flag
FROM hr1
LIMIT 10;

select * from hr1;

-- 1. Average Attrition rate for all Departments

SELECT 
    Department,
    concat(round(AVG(Attrition_Flag) * 100, 2), "%") AS Attrition_Percentage
FROM hr1
GROUP BY Department;

-- 2.  Average Hourly rate of Male Research Scientist

SELECT round(avg(HourlyRate)) as Avg_HourlyRate
FROM hr1
WHERE Gender = 'male'
  AND JobRole = 'Research Scientist';
  
  -- 3.  Attrition rate Vs Monthly income stats
  
  select  
    case
         when MonthlyIncome between 0 and 10000 then '0-10K'
         when MonthlyIncome between 10001 and 20000 then '10K-20K'
         when MonthlyIncome between 20001 and 30000 then '20K-30K'
         when MonthlyIncome between 30001 and 40000 then '30K-40K'
         when MonthlyIncome between 40001 and 50000 then '40K-50K'
         when MonthlyIncome between 50001 and 60000 then '50K-60K'
      end as monthlyincome_range ,   
  
concat(round(AVG(Attrition_Flag) * 100, 2), "%") AS Attrition_Percentage, 
  concat(ROUND(SUM(MonthlyIncome)/1000000,2),"M") as MonthlyIncome
  from hr1 as hr join hr2 as h on hr.EmployeeNumber= h.`Employee ID`
   group by monthlyincome_range order by monthlyincome_range ;
  
  -- 4.  Average working years for each Department

  select Department, round(avg(TotalWorkingYears)) as Avg_Workingyears from hr1 as hr join hr2 as h on hr.EmployeeNumber= h.`Employee ID`
   group by Department;
   
   -- 5. Job Role Vs Work life balance
   
   select JobRole,worklifebalance_name,concat(round(count(`Employee ID`)/1000,2),"K") as  JobRole_vs_WorkLifeBalance from  hr1 as hr join hr2 as h on hr.EmployeeNumber= h.`Employee ID`
   group by JobRole ,worklifebalance_name order by JobRole asc;
   
   -- 6. Attrition rate Vs Year since last promotion relation

   select  Department ,
         case 
            when YearsSinceLastPromotion between 1 and 10 then '1-10'
            when YearsSinceLastPromotion between 11 and 20 then '11-20'
            when YearsSinceLastPromotion between 21 and 30 then '21-30'
            when YearsSinceLastPromotion between 31 and 40 then '31-40'
         end as YearsSinceLastPromotion_name,   
	concat(round(AVG(Attrition_Flag) * 100, 2), "%") AS Attrition_Percentage, avg(YearsSinceLastPromotion) as avg_YearsSinceLastPromotion from hr1 as hr join hr2 as h on hr.EmployeeNumber= h.`Employee ID`
    group by YearsSinceLastPromotion_name, Department order by  Department,YearsSinceLastPromotion_name;
