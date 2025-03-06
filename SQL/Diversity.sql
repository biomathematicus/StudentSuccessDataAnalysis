declare @gender varchar(15); set @gender = 'female'
declare @ethnicity varchar(15); set @ethnicity = 'white'
declare @subject varchar(4); set @subject = 'mat'
declare @pell varchar(15); set @pell = 'No Pell'
select count(distinct IDENTIFIER) from oir where [SHRTCKN_SUBJ_CODE] = @subject and gender = @gender and PELLSTATUS = @pell and cast([CT_SUBJECT] as integer) > 4000
 
select count(distinct IDENTIFIER) from oir where [SHRTCKN_SUBJ_CODE] = @subject and gender <> @gender  and PELLSTATUS = @pell and cast([CT_SUBJECT] as integer) > 4000

select count(distinct IDENTIFIER) from oir where [SHRTCKN_SUBJ_CODE] = @subject and [RACEETHNICITY] = @ethnicity  and PELLSTATUS = @pell and cast([CT_SUBJECT] as integer) > 4000
 
select count(distinct IDENTIFIER) from oir where [SHRTCKN_SUBJ_CODE] = @subject and [RACEETHNICITY] <> @ethnicity  and PELLSTATUS = @pell and cast([CT_SUBJECT] as integer) > 4000

