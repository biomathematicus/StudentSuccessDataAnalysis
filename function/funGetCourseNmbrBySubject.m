function out = funGetCourseNmbrBySubject(sSubject)
    out = funQuery2Cell(['select distinct [SHRTCKN_SUBJ_CODE],[CT_SUBJECT],[SHRTCKN_CRSE_TITLE] from OIR where [SHRTCKN_SUBJ_CODE]  = ''' sSubject ''' order by [CT_SUBJECT]']); 
end
