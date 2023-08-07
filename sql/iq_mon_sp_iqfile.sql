SELECT @@servername
	,DBSpaceName
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
ORDER BY DBSpaceName ASC
	,DBFileName ASC
