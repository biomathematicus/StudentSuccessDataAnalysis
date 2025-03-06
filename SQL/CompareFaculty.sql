--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
declare @CT_SUBJECT_TARGET varchar(50)
declare @INSTRUCTORNAME varchar(50)
declare @CT_SUBJECT_ORIGIN varchar(50)
declare @SHRTCKN_SEQ_NUMB varchar(50)
declare @SHRTCKN_SUBJ_ORIGIN varchar(50)
declare @SHRTCKN_SUBJ_TARGET varchar(50)

select @INSTRUCTORNAME = 'Halfin,Igor' --Aghayan,Reza'--'Sharon,Zachery'--'%'--'Shirinkam,Sara'

SELECT @SHRTCKN_SUBJ_ORIGIN = 'MAT'
select @CT_SUBJECT_ORIGIN = '%' 
SELECT @SHRTCKN_SUBJ_TARGET = 'MAT'
select @CT_SUBJECT_TARGET = '%'

select @SHRTCKN_SEQ_NUMB = '%'

select	'TREATMENT', STVSCHD_DESC,  count(distinct identifier), avg([SHRGRDE_QUALITY_POINTS])  as GPA 
from	oir O1
where	SHRTCKN_SUBJ_CODE like @SHRTCKN_SUBJ_TARGET 
		--and CAP = 1
		and STVSCHD_DESC = 'Lecture face-to-face'
		and CURRENTTERM >= 2018.65
		and CT_SUBJECT like @CT_SUBJECT_TARGET 
		and  IDENTIFIER in (
			select  IDENTIFIER
			from	oir O2
			where	SHRTCKN_SUBJ_CODE like @SHRTCKN_SUBJ_ORIGIN 
					and CT_SUBJECT like @CT_SUBJECT_ORIGIN 
					and SHRTCKN_SEQ_NUMB like @SHRTCKN_SEQ_NUMB
					and instructorname like @INSTRUCTORNAME
		)		
group by STVSCHD_DESC
union
select 'CONTROL', STVSCHD_DESC,  count(distinct identifier), avg([SHRGRDE_QUALITY_POINTS])  as GPA 
from oir O1
where	SHRTCKN_SUBJ_CODE like @SHRTCKN_SUBJ_TARGET 
		--and CAP = 1
		and STVSCHD_DESC = 'Lecture face-to-face'
		and CURRENTTERM >= 2018.65
		and CT_SUBJECT like @CT_SUBJECT_TARGET 
		and IDENTIFIER not in (
			select  IDENTIFIER
			from	oir O2
			where	SHRTCKN_SUBJ_CODE like @SHRTCKN_SUBJ_ORIGIN 
					and CT_SUBJECT like @CT_SUBJECT_ORIGIN 
					and SHRTCKN_SEQ_NUMB like @SHRTCKN_SEQ_NUMB
					and instructorname like @INSTRUCTORNAME
		)		
group by STVSCHD_DESC

/*
select distinct [SHRGRDE_QUALITY_POINTS],[SHRTCKG_GRDE_CODE_FINAL] from OIR order by [SHRTCKG_GRDE_CODE_FINAL]
--exec spStudents 'Sciences','Mathematics',2014.66,2019

select avg([SHRGRDE_QUALITY_POINTS]), count(distinct identifier)
from oir 
where	SHRTCKN_SUBJ_CODE = 'MAT' 
		and CT_SUBJECT = '1214'
		and CAP = 1
		and SHRTCKN_SEQ_NUMB = '01S' 



select SHRTCKN_SUBJ_CODE, CT_SUBJECT, count(distinct identifier) 
from oir
where identifier in (
	select identifier from oir where SHRTCKN_SUBJ_CODE = 'MAT' and CT_SUBJECT = '1133'
	)
group by SHRTCKN_SUBJ_CODE, CT_SUBJECT
order by count(distinct identifier) desc --SHRTCKN_SUBJ_CODE, CT_SUBJECT

*/

