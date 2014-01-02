SET LOCK_TIMEOUT 300000
GO
SET DEADLOCK_PRIORITY LOW
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION 
GO

/****************************************************************************************/
/*                                                                                      */
/* Star 15191614 DSM: new procedure ip2hex						*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */

Select top 1 1 from mdb_patch with (tablockx)
GO

/* ************************** 11535 begin **************/



CREATE FUNCTION ip2hex(@ipaddr_str char(15) )  
RETURNS binary(4) 
AS  
BEGIN 
	declare @ipaddr_hex binary(4)
	declare @ipaddr float, @ipbyte int, @temp char(25), @ch char(1), @ipaddr_int int

	if (@ipaddr_str = NULL)
	begin
		select @ipaddr_hex = NULL
		return @ipaddr_hex
	end
	select @ipaddr = 0, @ipbyte = 0, @temp = ltrim(@ipaddr_str)

	while  @ipaddr >= 0
	begin
		select @ch = substring( @temp, 1, 1 )
		if @ch = '.'
		begin
			select @ipaddr = (@ipaddr + @ipbyte) * 256
			select @ipbyte = 0
		end
		else if @ch between '0' and '9'
			select @ipbyte = (@ipbyte * 10) + (ASCII( @ch ) - ASCII( '0' ))
		else
		begin
			select @ipaddr = @ipaddr + @ipbyte
			if @ipaddr > 2147483647.0
			begin
				select @ipaddr = - (4294967295.0 - @ipaddr + 1)
			end
			select @ipaddr_int = convert(int, @ipaddr)
			select @ipaddr_hex = convert(binary(4), @ipaddr_int)
			return @ipaddr_hex
		end
		select @temp = stuff( @temp, 1, 1, ' ' )
		select @temp = ltrim(@temp)
	end

return @ipaddr_hex
END
go

grant execute on [dbo].ip2hex to ca_itrm_group
go
grant execute on [dbo].ip2hex to ca_itrm_group_ams
go 





/* ************************** 11535 end **************/

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15191614, getdate(), 1, 4, 'Star 15191614 DSM: new procedure ip2hex' )
GO

COMMIT TRANSACTION 
GO

