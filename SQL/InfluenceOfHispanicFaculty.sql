select	O2.ethnicity, O2.gender, count(*) as Numb, avg(O2.AGIAvg) as [AGI], avg(O2.CH) as CH, avg(O2.GPA) as GPA, avg(HP) as HP 
from	(
		select		distinct O1.identifier, O1.ethnicity, O1.gender, 
					(
						select	count(*) 
						from	OIR O3 join INSTRUCTOR I 
								on  O3.PRIMARY_INSTRUCTOR_ID = I.PRIMARY_INSTRUCTOR_ID
						where	I.HISPANIC = 0 
								and O1.IDENTIFIER = O3.IDENTIFIER
					) as HP,
					avg(O1.AGINum) as [AGIAvg], 
					sum(O1.SHRTCKG_CREDIT_HOURS) as CH, 
					avg(O1.SHRGRDE_QUALITY_POINTS) as GPA
		from		OIR O1
		where		O1.SHRTCKG_GRDE_CODE_FINAL  in ('F','IN','NC','NR','W') --'A+', 'A', 'A-','C','C+','C-','CR','D','D+','D-',
					and cast(CT_SUBJECT as int) >=4000
		group by	O1.identifier, O1.ethnicity, O1.gender
		) O2--oir 
where O2.AGIAvg > 0
group by ethnicity, gender
having count(*) > 200
order by avg(O2.AGIAvg) desc
