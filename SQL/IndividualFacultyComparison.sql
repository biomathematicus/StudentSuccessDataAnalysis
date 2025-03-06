declare @fac varchar(100), @code varchar(5), @subject1 varchar(5), @subject2 varchar(5)
declare @a float, @b float, @c float, @d float
set @fac = 'Salingaros,Nikos'
set @code = 'MAT'
set @subject1 = '1093'
set @subject2 = '2233'

select	avg([SHRGRDE_QUALITY_POINTS]), stdev([SHRGRDE_QUALITY_POINTS]) 
from	oir 
where	[SHRTCKN_SUBJ_CODE] = @code 
		and [CT_SUBJECT]=@subject1 
		and [INSTRUCTORNAME]<>@fac 
		and [STVSCHD_DESC]= 'Lecture face-to-face'

select	avg([SHRGRDE_QUALITY_POINTS]), stdev([SHRGRDE_QUALITY_POINTS]) 
from	oir 
where	[SHRTCKN_SUBJ_CODE] = @code 
		and [CT_SUBJECT]=@subject1 
		and [INSTRUCTORNAME]=@fac 
		and [STVSCHD_DESC]= 'Lecture face-to-face'

select	avg([SHRGRDE_QUALITY_POINTS]), stdev([SHRGRDE_QUALITY_POINTS]) 
from	oir 
where	[SHRTCKN_SUBJ_CODE] = @code 
		and [CT_SUBJECT]=@subject2 
		and [INSTRUCTORNAME]<>@fac 
		and [STVSCHD_DESC]= 'Lecture face-to-face'

select	avg([SHRGRDE_QUALITY_POINTS]), stdev([SHRGRDE_QUALITY_POINTS]) 
from	oir 
where	[SHRTCKN_SUBJ_CODE] = @code 
		and [CT_SUBJECT]=@subject2 
		and [INSTRUCTORNAME]=@fac 
		and [STVSCHD_DESC]= 'Lecture face-to-face'

select	avg([SHRGRDE_QUALITY_POINTS]), stdev([SHRGRDE_QUALITY_POINTS]) 
from	oir 
where	[SHRTCKN_SUBJ_CODE] = @code 
		and [CT_SUBJECT]=@subject2 
		and [CURRENTTERM] = '2018.0' 
		and [INSTRUCTORNAME]<>@fac 
		and [STVSCHD_DESC]= 'Lecture face-to-face'

select	avg([SHRGRDE_QUALITY_POINTS]), stdev([SHRGRDE_QUALITY_POINTS]) 
from	oir 
where	[SHRTCKN_SUBJ_CODE] = @code 
		and [CT_SUBJECT]=@subject2 
		and [CURRENTTERM] = '2018.0' 
		and [INSTRUCTORNAME]=@fac 
		and [STVSCHD_DESC]= 'Lecture face-to-face'

