SELECT DBSpaceName
	,DBFileName
	,Path
	,SegmentType
	,RWMode
	,Online
	,Usage
	,DBFileSize
	,Reserve
	,StripeSize
	,OkToDrop
FROM dbo.sp_iqfile()
ORDER BY DBSpaceName
	,DBFileName
