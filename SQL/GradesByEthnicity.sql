select	[ETHNICITY], count(*),  avg([SHRGRDE_QUALITY_POINTS])
from	OIR
group by [ETHNICITY]


select	[ETHNICITY], count(*),  avg([SHRGRDE_QUALITY_POINTS])
from	OIR
where [SHRTCKG_GRDE_CODE_FINAL] not in ('D', 'F', 'W')
group by [ETHNICITY]
