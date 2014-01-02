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
/* Star 15095923 DSM: OLS (Object Level Security) enhancements					              	*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from ca_security_profile with (tablockx)
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ols_area_ace]') and OBJECTPROPERTY(id, N'IsUserTable') = 1) 
	Select top 1 1 from ols_area_ace with (tablockx)
GO
 
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].ols_area_def') and OBJECTPROPERTY(id, N'IsUserTable') = 1) 
	Select top 1 1 from ols_area_def with (tablockx)
GO
 
Select top 1 1 from ca_object_ace with (tablockx)
GO
 
Select top 1 1 from ca_class_ace with (tablockx)
GO
 
Select top 1 1 from ca_group_ace with (tablockx)
GO
 
Select top 1 1 from ca_link_dis_user_sec_profile with (tablockx)
GO
 
Select top 1 1 from ca_link_object_owner with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

/* ************************ ols area support begin *************** */

-- security profile table
alter table [dbo].ca_security_profile
	add  area_ace integer default -1;
go

alter table [dbo].ca_security_profile
	add  area_enabled integer default 0
go



-- object ace table
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ols_area_ace]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
create table [dbo].[ols_area_ace] (
	object_def_uuid			binary(16) not null,
	object_type				integer,
	area_ace				integer	not null default -1,
	area_mask				integer default -1,
	security_level			integer	default 0,		 -- creation user level
	creation_user			nvarchar(255)		     -- for diagnostic  only
) ON [PRIMARY]
END
go

/****** Object:  Table [dbo].[ols_area_def]	******/
ALTER TABLE [dbo].[ols_area_ace] WITH NOCHECK ADD
	CONSTRAINT [XPK_ols_area_ace] PRIMARY KEY  CLUSTERED
	(
		object_def_uuid
	)  ON [PRIMARY]
GO

grant select on [dbo].[ols_area_ace] to ca_itrm_group
go
grant insert on [dbo].[ols_area_ace] to ca_itrm_group
go
grant update on [dbo].[ols_area_ace] to ca_itrm_group
go
grant delete on [dbo].[ols_area_ace] to ca_itrm_group
go

grant select on [dbo].[ols_area_ace] to ca_itrm_group_ams
go



/****** Object:  Table [dbo].ols_area_def	 ******/
if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].ols_area_def') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
create table [dbo].[ols_area_def] (
	area_uuid		   binary(16) not null,
	area_id			   integer not null UNIQUE,
	label			   nvarchar(255) collate !!insensitive not null UNIQUE ,
	description		nvarchar(255) collate !!insensitive,
	creation_user	  nvarchar(255) collate !!sensitive,
	creation_date	  integer,
	last_update_user   nvarchar(255) collate !!sensitive,
	last_update_date   integer

) ON [PRIMARY]
END
go

/****** Object:  Table [dbo].[ols_area_def]	******/
ALTER TABLE [dbo].[ols_area_def] WITH NOCHECK ADD
	CONSTRAINT [XPK_ols_area_def] PRIMARY KEY  CLUSTERED
	(
		area_uuid
	)  ON [PRIMARY]
GO

grant select on [dbo].[ols_area_def] to ca_itrm_group
go
grant insert on [dbo].[ols_area_def] to ca_itrm_group
go
grant update on [dbo].[ols_area_def] to ca_itrm_group
go
grant delete on [dbo].[ols_area_def] to ca_itrm_group
go

grant select on [dbo].[ols_area_def] to ca_itrm_group_ams
go





/**
 ********************************************************
 ********************************************************
 additional schema changes to make the stored procedure more agile
 for addition mappings between objects and security classes
 ********************************************************
 ********************************************************
*/

-- the tabe below is used  to configre which object have to
-- be mapped to which security class
create table [dbo].[ols_mapping] (
	uuid				binary(16) not NULL CONSTRAINT ols_mapping_pk PRIMARY KEY   ,
	target_sec_class_id integer not NULL,
	source_type integer not null,
	source_tbl_name		nvarchar(255) not NULL,		-- for debugging only
	source_clmn_name	nvarchar(255) not NULL		-- for debugging only

);
go
grant select on [dbo].ols_mapping to ca_itrm_group
go
grant insert on [dbo].ols_mapping to ca_itrm_group
go
grant update on [dbo].ols_mapping to ca_itrm_group
go
grant delete on [dbo].ols_mapping to ca_itrm_group
go

grant select on [dbo].ols_mapping to ca_itrm_group_ams
go


/**
 ********************************************************
 ********************************************************
 Views, Functions and procedures for area support
 ********************************************************
 ********************************************************
*/

/**
 * view to be used to get the uuid and the settigs if area is enabled
 * based on a user uri
*/

create view ols_v_user_link_profile as
	select	usp.user_uuid as user_uuid,
		min(sp.area_enabled) as area_enabled
	from 
		ca_security_profile sp,
		ca_link_dis_user_sec_profile usp
	where
			usp.security_profile_uuid = sp.security_profile_uuid
		and sp.type != 1			-- exclude everyone
	group by usp.user_uuid
GO

grant select on ols_v_user_link_profile to ca_itrm_group
GO
grant select on ols_v_user_link_profile to ca_itrm_group_ams
GO


create view ols_v_user as
	select	u.user_uuid as user_uuid,
			is_area_enabled = 	case  s.set_val_lng when   0 
								then 0
								/* if user is not inside a profile
								   we asume hard restrictions: area_enabled */
								else  min(isnull(usp.area_enabled,1) )
								end, 
			u.uri as uri
	from 	ca_settings s,
			ca_discovered_user u left join
				ols_v_user_link_profile usp on u.user_uuid = usp.user_uuid,
			ca_settings s2
	where
			s.set_id = 901
			and ( u.domain_uuid = s2.set_val_uuid and	s2.set_id = 1
				)
group by u.user_uuid, u.uri, u.domain_uuid, s.set_val_lng
go

grant select on [dbo].ols_v_user to ca_itrm_group
go
grant select on [dbo].ols_v_user to ca_itrm_group_ams
go


/*
 ****************************************
 calculate area_ace for a user.
 take care that a user can be a memebr of one
 or more security profiles
*/
create function ols_fn_getAreaAceByUser
( @_uri		nvarchar(255)
)
returns  integer
begin

	-- calculate the area code
	declare @_pac			integer;			-- present area code temp. valud of a single security profile
	declare @_cumAreaCode	integer;			-- cumulative area code
	declare @_pae			integer;			-- present area enabled temp. valud of a single security profile

	--- check if user is set
	if ( @_uri is null )
	begin
		select @_cumAreaCode = (select set_val_lng from ca_settings where set_id = 900);
		return @_cumAreaCode;
	end;

	-- open cursor to search all security profile
	-- where the user is a member of and pick up the area_ace
	declare @_found  integer;
	set @_found = 0;
	declare cur_pace cursor for select  area_ace
						from ca_security_profile sp,
							ca_link_dis_user_sec_profile usp,
							ca_discovered_user u
						where  u.uri = @_uri
							and u.user_uuid = usp.user_uuid
							and usp.security_profile_uuid = sp.security_profile_uuid
							and sp.type <> 1;		-- exclude everyone profile


	open cur_pace;
	fetch from cur_pace into @_pac;	-- get first
	set @_cumAreaCode = 0;
	while @@fetch_status = 0
	begin

			set @_cumAreaCode = @_cumAreaCode | @_pac;	-- ORing all aces
			set @_found = 1;
			fetch from cur_pace into @_pac;		--fetch next

	end;
	close cur_pace;
	deallocate cur_pace;

	-- use the config value if a user is not linked to any security profile
	if(@_found = 0)
	begin
		select @_cumAreaCode = (select set_val_lng from ca_settings where set_id = 900);
		return @_cumAreaCode;
	end


	return @_cumAreaCode;
end
go
grant execute on [dbo].ols_fn_getAreaAceByUser to ca_itrm_group
go
grant execute on [dbo].ols_fn_getAreaAceByUser to ca_itrm_group_ams
go


/*
 ****************************************
 calculate area_ace for a user.
 take care that a user can be a member of one
 or more security profiles
*/
create function ols_fn_getAreaAceByUserUuid
( @_user_uuid		binary(16)
)
returns  integer
begin

	-- calculate the area code
	declare @_pac			integer;			-- present area code temp. valud of a single security profile
	declare @_cumAreaCode	integer;			-- cumulative area code
	declare @_pae			integer;			-- present area enabled temp. valud of a single security profile

	--- check if user is set
	if ( @_user_uuid is null )
	begin
		select @_cumAreaCode = (select set_val_lng from ca_settings where set_id = 900);
		return @_cumAreaCode;
	end;

	-- open cursor to search all security profile
	-- where the user is a member of and pick up the area_ace
	declare @_found  integer;
	set @_found = 0;
	declare cur_pace cursor for select  area_ace
						from ca_security_profile sp,
							ca_link_dis_user_sec_profile usp,
							ca_discovered_user u
						where  u.user_uuid = @_user_uuid
							and u.user_uuid = usp.user_uuid
							and usp.security_profile_uuid = sp.security_profile_uuid
							and sp.type <> 1;


	open cur_pace;
	fetch from cur_pace into @_pac;	-- get first
	set @_cumAreaCode = 0;
	while @@fetch_status = 0
	begin

			set @_cumAreaCode = @_cumAreaCode | @_pac;	-- ORing all aces
			set @_found = 1;
			fetch from cur_pace into @_pac;		--fetch next

	end;
	close cur_pace;
	deallocate cur_pace;

	-- use the config value if a user is not linked to any security profile
	if(@_found = 0)
	begin
		select @_cumAreaCode = (select set_val_lng from ca_settings where set_id = 900);
		return @_cumAreaCode;
	end


	return @_cumAreaCode;
end
go

grant execute on [dbo].ols_fn_getAreaAceByUserUuid to ca_itrm_group
go
grant execute on [dbo].ols_fn_getAreaAceByUserUuid to ca_itrm_group_ams
go

/**
 *****************************************************
 ols_getEffectiveAreaAce

	get the effective area permission for a user regarding
	a certain secured object


	if area support is disabled on a gloabl level then
	the function returns  a value -1

	if the area suppot is enabled on global level but disabled
	on profile level (at least in one profile the arae support
	is diabeld where the user is a meber of ) the the value
	-1 is returned (Everyone profile is excluded - will
	not be checked)

	if area code is enabled in all profiles for a user then
	the effective area permission is returned.
	(the ORed area permissons  of the profiles are
	ANDed with the object permissons for the particular object)


	@param @obj_uuid uuid of the secured object

	@param	@usr_uuid uuid of the user
 *****************************************************
 */
create  procedure ols_sp_getEffectiveAreaAce
(	@obj_uuid  binary(16),
	@usr_uuid	binary(16)
)
as
begin
	declare @isEnabled		int;
	declare @eff_obj_area_ace	int;
	declare @eff_sp_area_ace	int;
	select @isEnabled = (select is_area_enabled from ols_v_user where user_uuid = @usr_uuid);
	if ( @isEnabled = 0 )
	begin
		-- area support is disabled, so give full access
		select -1 as eff_area_ace;
		return;
	end

	-- area support is enabled
	-- either at global level or for all security profiles where  the user is
	-- a member of ecluding the Everyone Profile
	-- now calculate the effectve area_ace

	select @eff_obj_area_ace = (select area_ace & area_mask  from ols_area_ace where object_def_uuid = @obj_uuid);
	if( @eff_obj_area_ace is null)
	begin
		-- error
		-- force to return an empty resultset
		select 0 as eff_area_ace;
		return;
	end;

	set @eff_sp_area_ace = (select [dbo].ols_fn_getAreaAceByUserUuid (@usr_uuid));
	if( @eff_sp_area_ace is null)
	begin
		-- error
		-- force to return an empty resultset
		select 0 as eff_area_ace;
		return;
	end;

	select (@eff_sp_area_ace & @eff_obj_area_ace) as eff_area_ace;
	return;

end
GO
grant execute  on [dbo].ols_sp_getEffectiveAreaAce to ca_itrm_group
go
grant execute on [dbo].ols_sp_getEffectiveAreaAce to ca_itrm_group_ams
go

/*
 ****************************************
 calculate security level
 if a user is null then we have to use
 security level = defaullt value
 if a user is linked to a profile then  we have to
 use the creation user level
*/
create function ols_fn_getAreaSecLevelByUser
( @_uri		nvarchar(255)
)
returns  integer
begin

	declare @linkCnt int;

	--- check if user is set
	if ( @_uri is null )
	begin
		-- have to use the config value
		return 4;
	end;

	set @linkCnt = ( select  count(*)
						from ca_security_profile sp,
							ca_link_dis_user_sec_profile usp,
							ca_discovered_user u
						where  u.uri = @_uri
							and u.user_uuid = usp.user_uuid
							and usp.security_profile_uuid = sp.security_profile_uuid
					);


	-- test of the user is linked to any profile
	if(@linkCnt = 0)
	begin
		-- have to use the config value
		return 4;
	end

	-- user is linke to (at least one security profile)

	return 0;
end
go


grant execute on [dbo].ols_fn_getAreaSecLevelByUser to ca_itrm_group
go
grant execute on [dbo].ols_fn_getAreaSecLevelByUser to ca_itrm_group_ams
go


/**
 ******************************************************
 * set a link object owner for a ceration user
 *
 * @param @_uri URI of the creation user
 *
 * @param @_obj_uuid uuid of the created object
 */

create procedure ols_sp_setObjectOwner
(	@_uri		nvarchar(255),
	@_obj_uuid	binary(16)
)
as
begin
	declare @_owner_profile_uuid binary(16);
	declare @_user_uuid			binary(16);

	set nocount on;
	if ( @_uri is null )
	begin
		return 0;
	end;


	/* get the owner profile uuid */
	select @_owner_profile_uuid = (select security_profile_uuid
								  from ca_security_profile
										  where type = 0);

	if( @_owner_profile_uuid is null)
	begin
		return 0;
	end;

	/* get the user uuid  - normally we get only one*/
	declare cur_user cursor for select user_uuid
								from ca_discovered_user
								where uri = @_uri and (user_type = 1 or user_type = 2)
	open cur_user;
	fetch from cur_user into @_user_uuid; -- get first

	while @@fetch_status = 0
	begin
		-- create object owner
		insert into ca_link_object_owner (object_uuid, owner_uuid, security_profile_uuid, version_number)
				values ( @_obj_uuid, @_user_uuid, @_owner_profile_uuid,  0 );


		break;
	end;
	close cur_user;
	deallocate cur_user;
end;
go

grant execute on [dbo].ols_sp_setObjectOwner to ca_itrm_group
go
grant execute on [dbo].ols_sp_setObjectOwner to ca_itrm_group_ams
go


/**
 ******************************************************
 * set/reset area  bit
 * used to manage the area permission in case an area was added, deleted
 */

create procedure ols_sp_area_changed (
	@action		int,		-- 0 area was deleted, 1 area was created	
	@area_id	int		-- area uuid
)
as 
begin
	
	declare @aBit int;
	
	
	if ( @area_id > 31 )
	begin
			raiserror ('Error 9019: Area_id in ols_area_def greater than 31.', 16, 1);
			return;
	end;

	if ( @area_id = 31 )
		set @aBit	= 0x80000000;
	else
		-- < 31
		select @aBit = (power(2,@area_id));


	if (@action = 0)
	begin 
		-- area was deleted - unlink the area
		update ols_area_ace set area_ace = (area_ace & ~(@aBit));
		update ca_security_profile set area_ace = (area_ace & ~(@aBit));
	end;
/*
	else
	begin 
		-- area was set
		declare @g_area_ace int;

		select @g_area_ace = (select set_val_lng from ca_settings where set_id = 900);
		if(  @g_area_ace is null )
			return;
		if ( (@g_area_ace & @aBit) != 0 )
		begin
			-- bit is set in global settings
			--update ols_area_ace set area_ace= area_ace | @aBit;
			-- update ca_security_profile set area_ace= area_ace | @aBit;
		end
		else
			-- bit is not set in global settings
			begin 
				
			update ols_area_ace set area_ace = (area_ace & ~(@aBit));
			update ca_security_profile set area_ace = (area_ace & ~(@aBit));
			end
		
	end;
*/
end
go

grant execute on [dbo].ols_sp_area_changed to ca_itrm_group
go
grant execute on [dbo].ols_sp_area_changed to ca_itrm_group_ams
go



/**
 ******************************************************
 * set the area mask  of the ols_area_def table
 *	the area mask defiend whcih area bit is valid
 *
 * @param @obj_uuid if null all entries will be updated
 *				if set then onyl the row is set where the
 *				object_def_uuid  matches
 *
 */

create procedure ols_sp_applyAreaMask
(	@obj_uuid binary(16)
)
as
begin
	declare @area_mask integer;
	declare @aid	   integer;
	declare @abit	   integer;

	set nocount on;
	set @area_mask = 0;

	DECLARE amcur1 CURSOR
		FOR select area_id  from ols_area_def;

	OPEN amcur1
	FETCH NEXT FROM amcur1 INTO @aid	-- get first

	WHILE @@FETCH_STATUS = 0
	BEGIN
		if ( @aid > 31 )
		begin
			raiserror ('Error 9019: Area_id in ols_area_def greater than 31.', 16, 1);
		end;
		if ( @aid = 31 )
			set @abit	= 0x80000000;
		else
			select @abit = (power(2,@aid));
		set @area_mask = @area_mask | @abit;

		FETCH NEXT FROM amcur1 INTO @aid;	 -- get next

	END

	CLOSE amcur1
	DEALLOCATE amcur1

	if (@obj_uuid is null)
	begin
		-- update all rows of the table
		update ols_area_ace set area_mask = @area_mask;
	end
	else
	begin
		-- update a single object only
		update ols_area_ace set area_mask = @area_mask
			where object_def_uuid = @obj_uuid;
	end;
end;
go


grant execute on [dbo].ols_sp_applyAreaMask to ca_itrm_group
go
grant execute on [dbo].ols_sp_applyAreaMask to ca_itrm_group_ams
go


/**
 ******************************************************
 * set the area code for a ceration user for a secured
 * object
 *
 * @param @_uri URI of the creation user
 *
 * @param @_obj_uuid uuid of the created object
 */

create procedure ols_sp_setAreaCodeByUser
(	@_uri		nvarchar(255),
	@_obj_uuid	binary(16),
	@_object_type integer
)
as
begin
	declare @def_area_ace integer;
	declare @sec_level int;

	set nocount on;
	if( @_uri is null)
	begin
		-- update area settings - take it from the user's security profile

		set @def_area_ace = (select set_val_lng from ca_settings where set_id = 900);
		set @sec_level = 4; -- config level
	end
	else
	begin
		-- Uri given . calclaue the area ace
		select @def_area_ace = (select [dbo].ols_fn_getAreaAceByUser(@_uri));

		-- assert that we got a default area ace by URI
		if ( @def_area_ace is null)
		begin
			raiserror ('Error 9017: OLS: default area ace in ca_settings not found', 16,1);
			return;
		end;
		
		-- check if the area ace based on URI or default
		-- because we need to know if ols_fn_getAreaAceByUser() has found that the user is linke to a profiler
		set @sec_level = (select [dbo].ols_fn_getAreaSecLevelByUser(@_uri));

	end;


	if( select count(*) from ols_area_ace where object_def_uuid = @_obj_uuid) > 0
	begin
			-- area ace exists --> update needed
			update ols_area_ace
				set area_ace = @def_area_ace, security_level = @sec_level
				where object_def_uuid = @_obj_uuid;
	end
	else
	begin
		-- area ace doesn't exist --> insert needed
   	   insert into ols_area_ace  (object_def_uuid, area_ace, object_type,  security_level, creation_user)
						values (@_obj_uuid, @def_area_ace, @_object_type,  @sec_level, @_uri);

	end;

end;
go

grant execute on [dbo].ols_sp_setAreaCodeByUser to ca_itrm_group
go
grant execute on [dbo].ols_sp_setAreaCodeByUser to ca_itrm_group_ams
go

/*
 *********************************************************
 *********************************************************
 * Procedures and rules to manage security profiles
 *********************************************************
 *********************************************************
 */
/*
 *****************************************************
 procedure for updating the security_level of a area definition
 as well as the area permission in case of reverting 
	The security API sets the Security_level = 3 to signal that 
	we need to reverting the area permissiosn as follow:

	if obejct is member of a securiyt group
		--> revert to sec level 1  :: group level

	if( object i not member of a group but creation user is known)
		--> revert to sec level = 0 :: creation user level

	others
		--> revert to default value


	Note: reverting is onyl needed if
	current security level = 3		
			previous securiyt level = 2 ( object level)


	@param 			@_level curent securoty level (should be 3)

	@param			@object_uuid uuid of the objects to be updated

	@object_uuid	@_level_before	old securiyt level

	@param	@_object_type	object type
 */

create procedure [dbo].proc_u_so_area_revert(
			@_level 		integer,		  /* new.security_level */
			@object_uuid	binary(16),	   /* old.object_def_uuid */
			@_level_before	integer,		  /* old.security_level */
			@_object_type 	integer		   /* old.object_type */

)
as
begin
	
	declare @gcnt integer;

	set nocount on;
	if ( @_level = 3 -- reverting
		and @_level_before = 2 ) -- object level before. Set to group ace
	begin

		  set @gcnt = 0;
		  select @gcnt = ( select count(*) cnt from ca_group_member where member_uuid = @object_uuid);
		  if( @gcnt > 0 )
		  begin
			-- the object is a member of a group, then we need to recalculate the area_ace
			-- revert to group level

			declare @_object_class_uuid binary(16);
			declare @object_ace integer;
			declare @object_access integer;
			declare @object_level integer;
			declare @parent_ace integer;
			declare @parent_access integer;
			declare @ace_found integer;

			set @parent_ace = 0;	-- set default value
			set @object_ace = 0;	-- set default value

			declare parent_ace_list cursor for
			select area_ace
			from ols_area_ace
			where object_def_uuid in
			(select g.group_uuid from ca_group_member m , ca_group_def g
			where m.member_uuid = @object_uuid
					and m.group_uuid = g.group_uuid
					and g.security_group = 1)

			select @object_level = 0 -- set security level
			open parent_ace_list
			fetch from parent_ace_list into @parent_ace --get first ace
			while @@fetch_status = 0
			begin
				select @ace_found = 1  -- ace calculated
				if @object_level = 0 -- still class level
					begin
						select @object_ace = @parent_ace
					end
				else if @object_level = 1
					begin
						select @object_ace = (@object_ace | @parent_ace)
					end

				select @object_level = 1 -- set security level = group level

				fetch from parent_ace_list into @parent_ace  --get next ace
			end
			close parent_ace_list
			deallocate parent_ace_list


			update ols_area_ace set area_ace = @object_ace, security_level = @object_level
			  where object_def_uuid = @object_uuid;
		  end
		  else
		  begin
			-- the object is NOT member of a group
			-- we need to revert to creation user level / OR global level
			declare @uri nvarchar(255);
			
			select @uri = (	select creation_user from ols_area_ace 
				where object_def_uuid =  @object_uuid)
			-- in case of null then  we will get the gloabl settings
			execute ols_sp_setAreaCodeByUser @uri, @object_uuid, @_object_type;
		   end;
	end;


end

go

grant execute on [dbo].proc_u_so_area_revert to ca_itrm_group
go
grant execute on [dbo].proc_u_so_area_revert to ca_itrm_group_ams
go



/*
 ***********************************************
 procedure start if a new security profile
 was created
 addes a class ace for the new security profile
*/

alter procedure proc_i_new_so_security_profile
	@_obj_uuid binary(16), 	/* new.security_profile_uuid */
	@_type integer,
	@_default_ace integer   /* new.default_ace */

as
begin
	 declare @_access integer;

	set nocount on;
	-- Give this new object an ACL. Copy it from its class
	-- IMPL-NOTE: cursor  replace be INSERT ..SELECT
	insert into ca_object_ace (object_def_uuid, security_profile_uuid, ace, access, security_level, object_type)
		select @_obj_uuid, security_profile_uuid, ace, access, 0, 2
		from ca_class_ace
		where class_def_uuid = (select class_def_uuid from ca_security_class_def where class_id = 2)



	/* -- Now, as this new object is a security profile we must add its ace to each acl. */
	/* -- 1 means everyone */
	/* insert into log (des) values('bodbod test 2'); */
	select @_access=1;

	if( @_default_ace = 0)
		begin
		select @_access=0
		end
	if( @_type = 1 )
   	begin
		select @_access = 1
		end

	insert into ca_class_ace (class_def_uuid, security_profile_uuid, ace, access)
		select			cd.class_def_uuid,	 @_obj_uuid, @_default_ace, @_access
		from ca_security_class_def cd;

	insert into ca_object_ace(object_def_uuid, security_profile_uuid, ace, access, security_level, object_type )
		select distinct o.object_def_uuid, @_obj_uuid, @_default_ace, @_access, 0, o.object_type
		from ca_object_ace o;

	insert into ca_group_ace (group_def_uuid, security_profile_uuid, ace, access, enable_inheritance,   object_type )
		select distinct g.group_def_uuid, @_obj_uuid, @_default_ace, @_access, g.enable_inheritance,   g.object_type
		from ca_group_ace g

	-- create area ace but only if security class is defined
	-- this is important  to setup the model
	-- we do it in  the same way as the genesis of the object_ace
	-- set security level always to 0  and area_ace to -1 to make it visible in all areas
	if ((select count(*) from ca_security_class_def) > 0)
	begin
		insert into ols_area_ace (object_def_uuid, object_type, area_ace, security_level )
			values( @_obj_uuid, 2,  -1, 0)	;
	end;

	-- calcluate and apply the correct area-mask
	execute ols_sp_applyAreaMask @obj_uuid=@_obj_uuid;




end
go


/*
 ***********************************************
 procedure starts if a security profile was removed
 deletes all entries assigned to the deleted
 security profile in the
 ca_class_ace,
 ca_group_ace
 ca_object_ace
 ca_link_dis_user_sec_profile
 ca_link_object_owner
 ols_area_ace
 tables
*/
alter procedure  proc_d_so_removed_security_prof
	 @dsp_uuid binary(16)
as
begin

	set nocount on;
	delete from ca_class_ace
		   where security_profile_uuid = @dsp_uuid;

	delete from ca_group_ace
		   where security_profile_uuid = @dsp_uuid;

	delete from ca_object_ace
		   where security_profile_uuid = @dsp_uuid
				 or object_def_uuid = @dsp_uuid;

	delete from ca_link_dis_user_sec_profile
		   where security_profile_uuid = @dsp_uuid;

	delete from ca_link_object_owner
		   where object_uuid = @dsp_uuid;

	delete from ols_area_ace
		where object_def_uuid = @dsp_uuid;
end;
go



/*
 ***********************************************
 rule for insert a new security profile
*/
alter trigger rule_i_new_so_security_profile
	on ca_security_profile
	after insert
as
begin
	declare  @_obj_uuid binary(16);
	declare  @_type integer;
	declare  @_default_ace	integer;
	declare  @_default_area	integer;
	declare  @_area_enabled	integer;

	set nocount on;
	select @_obj_uuid = (select security_profile_uuid from inserted);
	select @_type	 = (select type from inserted);
	select @_default_ace	= (select default_ace from inserted);
	select @_default_area	= (select area_ace from inserted);
	select @_area_enabled	= (select area_enabled from inserted);

	execute  proc_i_new_so_security_profile  @_obj_uuid,  @_type,  @_default_ace;

end;
go








/*
 **********************************************
 * purpose:
 *	 procedure starts if a new group object was created
 *	Give this new object a group ACL
 *	and an object ACL. Copy them from its class
 *
 * parameters:
 *	_obj_uuid - object uuid of the created group
 *	_security_group - security group flag of the new group
 * 	_grp_type - type of the created group
 *
 * post-condition:
 *	entry created in the ca_group_ace table
 *	entry created in the ca_object_ace table
 *	in both cases the given _grp_type is mapped into the
 *	correct security class id
 *
 */


alter procedure  proc_i_new_so_group
	 @_obj_uuid  binary(16),
	 @_security_group integer,
	 @_grp_type integer,
	 @_uri nvarchar(255)


as
begin

	 declare @_sp_uuid  binary(16);
	 declare @_ace	 integer;
	 declare @_access  integer;
	 declare @_owner_profile_uuid binary(16);
	 declare @_user_uuid binary(16);
	 declare @_grp_class_id integer;


	set nocount on;

	/* get security class id for software job OR policy/template */

	select @_grp_class_id = (select target_sec_class_id
								from ols_mapping
								where source_tbl_name = 'ca_group_def'
										and source_type = @_grp_type);


	if (@_grp_type = 300)
		 /* softwareGrp*/
		select @_grp_class_id = 2002;
	else if (@_grp_type = 301)
		 /* procedureGrp */
		select @_grp_class_id = 2003;
	else
		select @_grp_class_id = (select target_sec_class_id
								from ols_mapping
								where source_tbl_name = 'ca_group_def'
										and source_type = @_grp_type);

	if( @_grp_class_id is null)
	begin
		raiserror ('Error 9016: OLS: target security class id not found in OLS-Mapping table', 16,1);
		select @_grp_class_id = 1005;
	end;

	-- IMPL-NOTE:  cursor replaced by INSERT ..: SELECT
  	-- create group ace object
   	insert into ca_group_ace (group_def_uuid, security_profile_uuid, ace, access, enable_inheritance, object_type)
		  	select @_obj_uuid, security_profile_uuid, ace, access, @_security_group, @_grp_class_id
			from ca_class_ace
				where class_def_uuid = (select class_def_uuid from ca_security_class_def where class_id = @_grp_class_id);

	-- create matching object ace object
	insert into ca_object_ace (object_def_uuid, security_profile_uuid, ace, access, security_level, object_type)
	  		select @_obj_uuid, security_profile_uuid, ace, access, 0, @_grp_class_id
			from ca_class_ace
				where class_def_uuid = (select class_def_uuid from ca_security_class_def where class_id = @_grp_class_id);


	-- now assign the object owner
	execute ols_sp_setObjectOwner @_uri, 	@_obj_uuid;

	-- set the area ace
	execute ols_sp_setAreaCodeByUser @_uri, @_obj_uuid, @_grp_class_id;

	-- calcluate and apply the correct area-mask
	execute ols_sp_applyAreaMask @obj_uuid=@_obj_uuid;

end
go

/*
 **********************************************
 procedure runs if a group entity was deleted
 delete assigned entries in
 ca_group_ace
 ca_object_ace
 ca_link_object_owner
 */

/*
 **********************************************
 * cleanup OLS if a group entity was deleted
 */
alter trigger rule_d_so_removed_group
 on ca_group_def
 after delete
as
begin

  set nocount on;
  delete ca_group_ace
	from deleted d
	where ca_group_ace.group_def_uuid = d.group_uuid;

  delete ca_object_ace
	from deleted d
  	where ca_object_ace.object_def_uuid = d.group_uuid;

  delete ca_link_object_owner
	from deleted d
	where object_uuid = d.group_uuid;

  delete ols_area_ace
	from deleted d
	where object_def_uuid = d.group_uuid;

end
go

/*
 ********************************************
 procedure runs if a new member was created
 in the ca_group_member table

 parameters
	@ngmem_uuid		uuid of the new group member
	@nggroup_uuid	uuid of the assigned group


  post-condition
	if it is not and inheritance group then nothinig was done

	if it is inheritance group  then the object_ace was
	calculated based on the object_ace of the parent group

	In case  the security_level of the member object_ace
	is set to class level,
	then the member object_ace is set to the parent group ace

	else the security_level of the object_ace is set to group level
	In this case the new member object_ace is ORed with the parent group
	ace

 */
alter procedure  proc_i_new_so_group_member
	@ngmem_uuid binary(16),
	@nggroup_uuid binary(16)

as

  declare @_inherit_ace integer;
  declare @_sp_uuid  binary(16);
  declare @_object_level  integer;
  declare @_object_ace  integer;
  declare @_parent_ace  integer;

  declare @_temp_ace  integer;
  declare @_parent_access  integer;

begin

	set nocount on;
	-- check if it's a security group
	select @_inherit_ace = (select g.security_group
								from ca_group_def g
								where g.group_uuid = @nggroup_uuid);

	if(@_inherit_ace = 1)
	begin
		-- it is a security group
		 declare cur_sp cursor
			for select o.security_profile_uuid, o.security_level, o.ace, g.ace, g.access
			from ca_object_ace o, ca_group_ace g
			where g.group_def_uuid = @nggroup_uuid AND
				o.object_def_uuid = @ngmem_uuid  AND
				o.security_profile_uuid = g.security_profile_uuid
		 open cur_sp
		 fetch cur_sp into @_sp_uuid, @_object_level, @_object_ace, @_parent_ace, @_parent_access;
		 while @@fetch_status = 0
		 begin
			-- Calculate a new ace from the new parent
			if (@_object_level = 0)-- class
			begin
				update ca_object_ace
					set ace = @_parent_ace, access = @_parent_access, security_level = 1
					where object_def_uuid = @ngmem_uuid AND security_profile_uuid = @_sp_uuid;
				 end
			else if (@_object_level = 1) -- group
			begin
				select @_temp_ace = (@_object_ace | @_parent_ace);

				if(@_temp_ace <> @_object_ace  )
				begin
					update ca_object_ace
						set ace = @_temp_ace, access = @_parent_access, security_level = 1
						where object_def_uuid = @ngmem_uuid AND security_profile_uuid = @_sp_uuid;
				end;
			end;

			fetch cur_sp into @_sp_uuid, @_object_level, @_object_ace, @_parent_ace, @_parent_access;
		  end;	-- end while
		  close cur_sp;
		  deallocate cur_sp;


		-- re-caclulate the area ace now

		-- update area ace of the group member
		declare @_level_before integer;
		select @_level_before = (select security_level from ols_area_ace where object_def_uuid = @ngmem_uuid) ;

		declare @_object_type integer;
		select @_object_type = (select object_type from ols_area_ace where object_def_uuid = @ngmem_uuid) ;

		execute proc_u_so_area_revert 3, @ngmem_uuid, @_level_before, @_object_type;


   end;
end
go


/*
 **********************************************
 * procedure starts if a group member was deleted
 */
ALTER procedure  [dbo].[proc_d_so_removed_group_member]
		@_object_uuid binary(16) /* old.member_uuid; */

as

  declare  @_sp_uuid 	binary(16);
  declare  @_object_class_uuid binary(16);
  declare  @_object_ace 	integer;
  declare  @_object_access 	integer;
  declare  @_object_level 	integer;
  declare  @_object_type	integer;
  declare  @_parent_ace 	integer;
  declare  @_parent_access 	integer;


begin

	set nocount on;

	declare cur_oace cursor
	for select security_profile_uuid, object_type
		from ca_object_ace
		where object_def_uuid = @_object_uuid AND security_level = 1

	open cur_oace;
	fetch cur_oace into @_sp_uuid, @_object_type;
	while @@fetch_status = 0
	begin

		select @_object_class_uuid = (select class_def_uuid
												from ca_security_class_def
												where class_id = @_object_type);

		-- start with class ace values
		select @_object_ace = (select ace from ca_class_ace
												where class_def_uuid = @_object_class_uuid and security_profile_uuid = @_sp_uuid);
		select @_object_access = (select  access from ca_class_ace
												where class_def_uuid = @_object_class_uuid and security_profile_uuid = @_sp_uuid);

		select @_object_level = 0;


		-- Calculate a new ace from all its parents that has inheritance enabled
		declare cur_gace cursor
		for select a.ace, a.access
			from ca_group_ace a, ca_group_member m
			where a.security_profile_uuid = @_sp_uuid and a.enable_inheritance = 1
				and a.group_def_uuid=  m.group_uuid and m.member_uuid = @_object_uuid

		open cur_gace;
		fetch cur_gace into @_parent_ace, @_parent_access --get first ace;
		while @@fetch_status = 0
		begin

			-- message 3 'proc_d_so_removed_group_member ca_group_ace';
			if ( @_object_level = 0 ) -- still class level

					select @_object_ace = @_parent_ace;
			else if (@_object_level = 1)

				select @_object_ace = (@_object_ace | @_parent_ace);


			select @_object_access = @_parent_access;
			select @_object_level = 1; -- set security level = group level
			if (@_parent_access = 0)

				break;

			fetch cur_gace into @_parent_ace, @_parent_access --get next ace;
		end; -- while
		close cur_gace;
		deallocate cur_gace;

		update ca_object_ace
			set ace = @_object_ace, access = @_object_access, security_level = @_object_level
			where object_def_uuid = @_object_uuid AND security_profile_uuid = @_sp_uuid;


		fetch cur_oace into @_sp_uuid, @_object_type; -- get next
	end; -- end while
	close cur_oace;
	deallocate cur_oace;


	-- update area ace of the group member
	declare @_level_before integer;
	select @_level_before = (select security_level from ols_area_ace where object_def_uuid = @_object_uuid) ;

	select @_object_type = (select object_type from ols_area_ace where object_def_uuid = @_object_uuid) ;

	execute proc_u_so_area_revert 3, @_object_uuid, @_level_before, @_object_type;


end;
go




/*
 ************************************************
 trigger for updating a area ace
 - either area_ace of a group object
 - security level ( reverting)
*/
create trigger rule_u_so_updated_group_area
 on ols_area_ace
 after update
as
begin

if update(area_ace)
begin
	

	declare @_inherit_ace integer;
	declare @_group_uuid binary(16);
	declare @_member_uuid binary(16);

	declare @_group_area_ace_new integer;
	declare @_member_area_ace integer;
	declare @_group_area_ace_old integer;

	declare @_object_level integer;
	declare @_temp_ace integer;


	set nocount on;
	DECLARE gcur_aace CURSOR LOCAL
		FOR select inserted.object_def_uuid, inserted.area_ace, g.security_group,
					 deleted.area_ace from deleted, inserted, ca_group_def g
			where deleted.object_def_uuid = inserted.object_def_uuid
				and g.group_uuid = inserted.object_def_uuid -- only valid for group updates

	OPEN gcur_aace
	FETCH NEXT FROM gcur_aace INTO @_group_uuid, @_group_area_ace_new, @_inherit_ace, @_group_area_ace_old
	WHILE @@FETCH_STATUS = 0
	BEGIN

			-- check if it's a security group

			if(@_inherit_ace = 1)
			begin
				-- it is a security group

				-- for update area_ace for all members of the group
				declare cur_gace cursor LOCAL
					for select gm.member_uuid, oa.area_ace, oa.security_level
					from ca_group_member gm, ols_area_ace ga, ols_area_ace oa
					where ga.object_def_uuid = @_group_uuid
						AND ga.object_def_uuid = gm.group_uuid
						and oa.object_def_uuid = gm.member_uuid;

				open cur_gace
				fetch cur_gace into  @_member_uuid, @_member_area_ace, @_object_level;
				while @@fetch_status = 0
				begin
					-- Calculate a new ace from the new parent
					if (@_object_level != 2)-- not object level
					begin

						select @_temp_ace = (@_group_area_ace_old & ~(@_member_area_ace)  ) | @_group_area_ace_new;

						if(@_temp_ace <> @_member_area_ace  )
						begin
							update ols_area_ace
								set area_ace = @_temp_ace,
									security_level = 1    -- now group level
								where object_def_uuid = @_member_uuid
                                
						end;
					end;

				fetch cur_gace into  @_member_uuid, @_member_area_ace, @_object_level;
				end;	-- end while
				close cur_gace;
				deallocate cur_gace;

			end
	FETCH NEXT FROM gcur_aace INTO @_group_uuid, @_group_area_ace_new, @_inherit_ace, @_group_area_ace_old ;

	END -- while end
	CLOSE gcur_aace
	DEALLOCATE gcur_aace

end;


   if update(security_level)
   begin
	IF ( (SELECT trigger_nestlevel( object_ID('rule_u_so_updated_group_area') ) ) < 2 )
	begin
		declare 	@_level 		integer;
		declare 	@_object_uuid	binary(16);
		declare 	@_level_before	integer;
		declare 	@_object_type 	integer;

		declare c_aace_upd cursor LOCAL for 
		select i.security_level, i.object_def_uuid, d.security_level, d.object_type
		from inserted as i, deleted as d where
						i.object_def_uuid = d.object_def_uuid ;
						--	and i.object_type = d.object_type;


		open c_aace_upd
		fetch from c_aace_upd into @_level, @_object_uuid, @_level_before,@_object_type --get first row

		while @@fetch_status = 0
		begin

		   execute  proc_u_so_area_revert @_level, @_object_uuid, @_level_before, @_object_type;
		   fetch from c_aace_upd into @_level, @_object_uuid,  @_level_before,@_object_type  --get next row

		end
		close c_aace_upd;
		deallocate c_aace_upd;
	end
   end;


end
go

/**
 ********************************************
  trigger to manage configuration updates
	e.g area permission
 */

create trigger rule_so_area_setting
 on ca_settings
 after update
as
begin

	set nocount on;
	if update(set_val_lng)
	begin
		declare @cnt int;

		select @cnt = (select count(*) from inserted where set_id = 900);
		if( @cnt <> 0 )
		begin
			-- config value for area permissons is changed
			update ols_area_ace set area_ace = s.set_val_lng
					from ca_settings s
					where security_level = 4
						and s.set_id = 900;
		end;
	end;

end
go



 /*
 *********************************************************
 *********************************************************
 * Procedures and rules to manage objects
 * except group objects
 *********************************************************
 *********************************************************
 */

/*
 ***********************************************
 update object ace tabel for each new object
 give this new object an ACL. Copy it from its class
*/
alter procedure proc_i_new_so_object
	@_obj_uuid binary(16), 			 /* new.security_profile_uuid */
	@_clsid integer,				 /* security class */
	@_uri nvarchar(255)			  /* creation user */

as
begin
	declare @_sp_uuid binary(16);
	declare @_ace integer;
	declare @_access integer;

	declare @_owner_profile_uuid binary(16);
	declare @_user_uuid binary(16);

	set nocount on;
	-- IMPL-NOTE: cursor replaced by INSERT..SELECT

	insert into ca_object_ace (object_def_uuid, security_profile_uuid, ace, access, security_level, object_type)
			select distinct @_obj_uuid, a.security_profile_uuid, a.ace, a.access, 0, @_clsid
				from ca_class_ace a, ca_security_class_def s
				where a.class_def_uuid = s.class_def_uuid and s.class_id = @_clsid;



	-- create object owner  if creation user is know
	execute  ols_sp_setObjectOwner @_uri, 	@_obj_uuid;

	-- set the area ace
	execute ols_sp_setAreaCodeByUser @_uri, @_obj_uuid, @_clsid;

	-- calcluate and apply the correct area-mask
	execute ols_sp_applyAreaMask @obj_uuid=@_obj_uuid;

end;
go

/*
 ******************************************
  procedure runs if a secured object is deleted
	- delete the entries of object_ace table
	- delete the entries of ca_link_object_owner table
	- delete the entry of ols_area_ace table

*/

ALTER procedure  [dbo].[proc_d_so_removed_object]
	   @obj_uuid binary(16)

as
begin
	set nocount on;
	 delete from ca_object_ace
		   where object_def_uuid = @obj_uuid;

	 delete from ca_link_object_owner
			where object_uuid = @obj_uuid;

	delete from ols_area_ace
			where object_def_uuid = @obj_uuid;

end
go

/*
 *******************************************
  procedure starts if a user is deleted
  deletes all ca_object_ace entries for
  the deleted user
  deletes all ca_link_object_woner entries
  deletes all link to the securiyt profile
*/
alter procedure  proc_d_so_removed_user
	   @duser_uuid binary(16)


as
begin
	set nocount on;
  delete from ols_area_ace
		where object_def_uuid = @duser_uuid;

  delete from ca_object_ace
		 where object_def_uuid = @duser_uuid;

  delete from ca_link_object_owner
		 where owner_uuid = @duser_uuid;

  delete from ca_link_dis_user_sec_profile
		 where user_uuid = @duser_uuid;
end
go



/*
 *********************************************************
 *********************************************************
 * Procedures and rules to manage user objects
 *********************************************************
 *********************************************************
 */

/********************************************
 procedure to handle new discovered_users
 creates an ca_object_ace entry for each security class and security profile
 the ace will be taken from the class ace
*/
alter procedure  proc_i_new_so_user
	   @obj_uuid binary(16)

as
begin
	 declare @sp_uuid binary(16);
	 declare @ace int;
	 declare @access int;

	set nocount on;
	-- IMPL-NOTE: cursor replaces by INSERT..SELECT

	insert into ca_object_ace (object_def_uuid, security_profile_uuid, ace, access, security_level, object_type)
  		select @obj_uuid, security_profile_uuid, ace, access, 0, 1002
				from ca_class_ace
				where class_def_uuid = (select class_def_uuid from ca_security_class_def where class_id = 1002)


	-- set the area ace
	declare @_uri nvarchar(255);
	select @_uri = (select uri from ca_discovered_user where user_uuid = @obj_uuid);
	execute ols_sp_setAreaCodeByUser @_uri, @obj_uuid, 1002;

	-- calcluate and apply the correct area-mask
	execute ols_sp_applyAreaMask @obj_uuid=@obj_uuid;

end
go




/*
 *********************************************************
 *********************************************************
 * Procedures and rules to manage area objects
 *********************************************************
 *********************************************************
 */




/*
 ****************************************************
 trigger for creating a new area
	step 1) create the object permission
	step 2) calculate&set new area mask and
 */
create trigger [dbo].rule_i_new_so_area
 on ols_area_def
 after insert
as
begin
	declare @_obj_uuid 	binary(16);
	declare @_clsid integer;
	declare @_uri nvarchar(255);
	declare @area_id int;

	set nocount on;
	select @_clsid = 3;

	DECLARE cur_nsoa CURSOR
		FOR select area_uuid, creation_user, area_id  from inserted

	OPEN cur_nsoa
	FETCH NEXT FROM cur_nsoa INTO @_obj_uuid, @_uri, @area_id	-- get first

	WHILE @@FETCH_STATUS = 0
	BEGIN

		execute  proc_i_new_so_object @_obj_uuid, @_clsid, @_uri;

		-- update area permissions because a new area was created
		execute ols_sp_area_changed 1, @area_id;

		FETCH NEXT FROM cur_nsoa INTO @_obj_uuid, @_uri, @area_id;	  -- get next

	END

	CLOSE cur_nsoa
	DEALLOCATE cur_nsoa

	-- apply area mask
	execute ols_sp_applyAreaMask @obj_uuid=null;

end;
go



/*
 ****************************************************
 trigger for deleting a area definition
	step 1) delete the object permission
	step 2) re-calculate&set new area mask
 */
create trigger [dbo].rule_d_so_removed_area
  on ols_area_def
  after delete

as
begin
	declare @area_uuid binary(16);
	declare @area_id int;
	set nocount on;

	DECLARE cur_rsoa CURSOR
		FOR select area_uuid, area_id from deleted

	OPEN cur_rsoa
	FETCH NEXT FROM cur_rsoa INTO @area_uuid, @area_id
	WHILE @@FETCH_STATUS = 0
	BEGIN

		execute  proc_d_so_removed_object @area_uuid

		-- update area permissons because a raea was deleted/unused now
		execute ols_sp_area_changed 0, @area_id;

		FETCH NEXT FROM cur_rsoa INTO @area_uuid, @area_id;

	END

	CLOSE cur_rsoa
	DEALLOCATE cur_rsoa

	-- apply area mask
	execute ols_sp_applyAreaMask @obj_uuid=null;
	
	

end;
go








/**
 *********************************************************
 *********************************************************
 optimization only
 *********************************************************
 *********************************************************
*/
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


/*
 ****************************************
 rule if a new group_ace was inserted
 trigger checks for consistence of object_type
 all object_type attributes in one group must have
 the same value
*/


ALTER trigger [dbo].[r_i_inserted_group_ace]
	   on [dbo].[ca_group_ace]
	   after insert
as
begin
	SET NOCOUNT ON;

	declare	@_count integer;				/* number of groups */

	set @_count = ( select count(*) from ca_group_ace gace, inserted i
					where gace.group_def_uuid = i.group_def_uuid
							and gace.object_type != i.object_type )

	if ( @_count > 0 )
	begin
		raiserror ('Error 9015: insert of group_ace denied, group with different object type exists', 16,1);
		return
	end

end;
go

/*
 ************************************************
 trigger for updating a group ace
*/
alter trigger rule_u_so_updated_group_ace
 on ca_group_ace
 after update
as
begin
	if update(ace)
	begin
		declare @_group_uuid binary(16);
		declare @_sp_uuid binary(16);
		declare @_group_ace integer;
		declare @_group_enable_inheritance integer;
		declare @_group_old_ace integer;
		declare @_group_old_enable_inheritance integer;

		set nocount on;

		DECLARE mycur CURSOR
			FOR select inserted.group_def_uuid, inserted.security_profile_uuid, inserted.ace,
					inserted.enable_inheritance, deleted.ace, deleted.enable_inheritance from deleted, inserted

		OPEN mycur
		FETCH NEXT FROM mycur INTO @_group_uuid, @_sp_uuid, @_group_ace, @_group_enable_inheritance, @_group_old_ace, @_group_old_enable_inheritance
		WHILE @@FETCH_STATUS = 0
		BEGIN

			execute  proc_u_so_updated_group_ace @_group_uuid, @_sp_uuid, @_group_ace, @_group_enable_inheritance, @_group_old_ace, @_group_old_enable_inheritance
			FETCH NEXT FROM mycur INTO @_group_uuid, @_sp_uuid, @_group_ace, @_group_enable_inheritance, @_group_old_ace, @_group_old_enable_inheritance

		END

		CLOSE mycur
		DEALLOCATE mycur
	end
end
go

/**
*******************************************************
* new procs and changes for USD area support 
*******************************************************
*/

-- New procedure that will call the old security procedure but also change the area ace
-- from the default to that of the "parent" sw package
create procedure proc_i_new_so_procedure_object
	@_obj_uuid binary(16),
	@target_class_id integer,
	@_uri nvarchar(255)
	
as
begin

set nocount on;
 
	execute   proc_i_new_so_object @_obj_uuid, @target_class_id, @_uri


		-- at this point in time the area_ace of the new secured object is set as defined by 
		-- the creation user but now we switch it to the same area_ace as defined for the 
		-- associated software package
		declare @swp_area_ace integer						-- read area_ace from the assign group
	
		set @swp_area_ace = (select area_ace 
						from ols_area_ace as gace, 
							 usd_actproc as ap
						where  ap.objectid = @_obj_uuid
							and ap.rsw = gace.object_def_uuid)

		-- update the area_ace only if there was a swp assigned
		if ( @swp_area_ace is not null )
		begin
		   update ols_area_ace set area_ace = @swp_area_ace	-- assign swp area_ace to the procedure
		   where  object_def_uuid = @_obj_uuid
		end
end
go

-- Old trigger that will call a new procedure for special behaviour with regards to area codes
ALTER  trigger rule_i_new_so_usd_actproc
	 on usd_actproc
	 after insert
as
begin
  declare @_obj_uuid binary(16);
  declare @_clsid integer;
  declare @_uri nvarchar(255);

set nocount on;

  select @_obj_uuid = (select objectid from inserted);
  select @_clsid = 2001;
  select @_uri = (select creation_user from inserted);

  execute proc_i_new_so_procedure_object	@_obj_uuid, @_clsid, @_uri;
		
end
go

-- New procedure that will call the old security procedure but also change the area ace
-- from the default to that of the "parent" job container
create procedure proc_i_new_so_activity_object
	@_obj_uuid binary(16),
	@target_class_id integer,
	@_uri nvarchar(255)
	
as
begin
 
set nocount on;

	execute   proc_i_new_so_object @_obj_uuid, @target_class_id, @_uri


		-- at this point in time the area_ace of the new secured object is set as defined by 
		-- the creation user but now we switch it to the same area_ace as defined for the 
		-- associated software package
		declare @jcont_area_ace integer		-- read area_ace from the assign group
	
		set @jcont_area_ace = (select area_ace 
						from ols_area_ace as gace, 
							 usd_link_jc_act as ljcact
						where  ljcact.activity = @_obj_uuid
							and ljcact.jcont = gace.object_def_uuid)

		-- update the area_ace only if there was a swp assigned
		if ( @jcont_area_ace is not null )
		begin
		   update ols_area_ace set area_ace = @jcont_area_ace -- assign jobcont area_ace to the activity
		   where  object_def_uuid = @_obj_uuid
		end
end
go

-- Old trigger that will call a new procedure for special behaviour with regards to area codes
ALTER trigger rule_i_new_so_usd_job
	 on usd_activity
	 after insert
as 
begin
    declare @_obj_uuid binary(16)
    declare @_clsid integer
    declare @_uri nvarchar(255)
   
set nocount on;

    select @_obj_uuid = (select objectid from inserted)
    select @_clsid = 2005
    select @_uri = (select creation_user from inserted)
							
    execute   proc_i_new_so_activity_object @_obj_uuid, @_clsid, @_uri
							
end
go

-- Trigger for updating an area ace and moving related objects too
create trigger rule_u_so_area_updated
 on ols_area_ace
 after update
as
begin 
	
    if update(area_ace)
    begin 
	declare @objCount integer

set nocount on;

	set @objCount = (select count(*) from inserted where object_type = 2000)

	-- If classid is sw package, move the procedures too
	if(@objCount > 0)
	begin
		-- Move all procedures for these sw packages too
		update ols_area_ace set area_ace = inserted.area_ace, security_level = inserted.security_level
		from inserted, usd_actproc
		where usd_actproc.rsw = inserted.object_def_uuid
		and ols_area_ace.object_def_uuid = usd_actproc.objectid
	end

	set @objCount = (select count(*) from inserted where object_type = 2004)

	-- If classid is job cont, move the activities too
	if(@objCount > 0)
	begin
		-- Move all procedures for these sw packages too
		update ols_area_ace set area_ace = inserted.area_ace
		from inserted, usd_link_jc_act
		where usd_link_jc_act.jcont = inserted.object_def_uuid
		and ols_area_ace.object_def_uuid = usd_link_jc_act.activity

	end
    end
end 
go

/* ************************ ols area support end  *************** */

-- populate the tabel with predefiend data
-- using hard coded uuids
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0x624E8425CD42C04392281309FFDE84E4, 4000, 1008, 'csm_object', 'class_id')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0x96AC932684DBBB4DBB699A53434512B8, 4000, 1006, 'csm_object', 'class_id')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0x219CAFB38D12144198F38435430BAC4C, 4500, 2000, 'csm_object', 'class_id')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0xFBFCDADD905A664CA31887B3EF478111, 4501, 2002, 'csm_object', 'class_id')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0x8EE8E9D88011ED4B87CD839470B978A0, 2002, 1, 'usd_sw_fold', 'type')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0x6716F9CFF18B8941B918332D7D46863B, 2003, 2, 'usd_sw_fold', 'type')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0x05CC29E4C34CB84FB8122DDCF2FF4BD2, 3100, 1, 'ncjobcfg', 'job_category')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0xE4145DF057000C4D941B69BF7B6255A8, 3101, 2, 'ncjobcfg', 'job_category')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0x4417D6ED63DF39418005BDDC51262A43, 3201, 12, 'ncmodcfg', 'motype')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0xADF7D36F9286C448BB0999C2DFF30717, 3202, 16, 'ncmodcfg', 'motype')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0x7756C860CB62634AB0DAF73EA3B5F806, 3203, 6, 'ncmodcfg', 'motype')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0x4DFF772CD4F3D24BB309B03929E0D8ED, 3204, 7, 'ncmodcfg', 'motype')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0x2B2550C263034C438CF4A14447D3DFC3, 8000, 3, 'rptree', 'type')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0x60B20861E5D3E846A892E6A4C3F0F06E, 8001, 40, 'rptree', 'type')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0xF916F67F400D6E468BABF57F53D4BF53, 2004, 3, 'usd_job_cont', 'type')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0xC473A4D7D8BAE84A8386AA2801E2E8FE, 2009, 4, 'usd_job_cont', 'type')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0x23F5E1DB48E7464D8B896387419687AD, 7000, 1, 'ca_group_def', 'member_type')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0x598C83B23E974148986483A51417FB76, 7006, 4, 'ca_group_def', 'member_type')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0xD2F267E1D1F6AA428DD46BEFB6B9FB2F, 7007, 6, 'ca_group_def', 'member_type')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0x44ED79E9AAD30E44B58EF03908D3D898, 7004, 7, 'ca_group_def', 'member_type')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0xFD667471B3F2964B92690327377A0CF8, 7008, 8, 'ca_group_def', 'member_type')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0x5F6759E2D8EF5B41825A287A40B69ABC, 7009, 9, 'ca_group_def', 'member_type')
go
insert into ols_mapping (uuid, target_sec_class_id, source_type, source_tbl_name, source_clmn_name)
				values (0x0AA8CD57B2F30A489A22D834BBE2C978, 7010, 10, 'ca_group_def', 'member_type')
go

/* ********************* ols area support begin ************* */

/**
 ********************************************************
 ********************************************************
 Views, Functions and procedures for upgrade OLS 
 from prev. version
 ********************************************************
 ********************************************************
*/

/**
 *******************************************************
 ols_ac_reset
 
 reset all the area permissons to the configuration default values
 for all secured objects
 reset also enable/disable area support of all profiles
 *******************************************************
 */
if  exists (select * from dbo.sysobjects where id = object_id(N'[dbo].ols_ac_reset') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
	drop procedure [dbo].ols_ac_reset;
END
go

create procedure ols_ac_reset
as
begin 
-- setup security profiles
--
update ca_security_profile set area_ace = s.set_val_lng from ca_settings s
	where  s.set_id = 900;

update ca_security_profile set area_enabled = s.set_val_lng from ca_settings s
	where s.set_id = 901;


-- setup the ols_area_ace table
insert into ols_area_ace ( object_def_uuid, object_type )
		select distinct object_def_uuid, object_type 
			from ca_object_ace ;
			
update ols_area_ace set area_ace = s.set_val_lng from ca_settings s
	where  s.set_id = 900;

end
go

grant execute on [dbo].ols_ac_reset to ca_itrm_group
go

/**
 *****************************************************
 ols_ac_setup_sp

 This procedure is used to create the default area ace 
 for each existing security profile in case it is not 
 set (column contains null value)
 *****************************************************
*/
if  exists (select * from dbo.sysobjects where id = object_id(N'[dbo].ols_ac_setup_sp') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
	drop procedure [dbo].ols_ac_setup_sp;
END
go
create procedure ols_ac_setup_sp

as
begin 

	declare @_ae integer;
	declare @_ace integer;

	set @_ae = (select set_val_lng from ca_settings where set_id = 901);
	-- set @_ae = 0;
	set @_ace = (select set_val_lng from ca_settings where set_id = 900);

	
	update ca_security_profile set area_enabled=@_ae, area_ace = @_ace
		where area_enabled is null or area_ace is null;

	-- make sure that the EVERYONE profile has no access always
	
	update ca_security_profile set area_enabled=@_ae, area_ace = 0
		where type = 1;

end;
go

grant execute on [dbo].ols_ac_setup_sp to ca_itrm_group
go



/**
 ******************************************************
 ols_ac_setup_area_ace

 This procedure is used to  
 create the default area ace for each existing 
 secured object
 ******************************************************
*/
if  exists (select * from dbo.sysobjects where id = object_id(N'[dbo].ols_ac_setup_area_ace') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
	drop procedure [dbo].ols_ac_setup_area_ace;
END
go

create procedure ols_ac_setup_area_ace

as
begin 

	-- get default values
	declare @_ace integer;
	set @_ace = (select set_val_lng from ca_settings where set_id = 900);


	insert into ols_area_ace ( object_def_uuid, area_ace, object_type, security_level ) 
			select distinct object_def_uuid, @_ace, object_type, 4 from ca_object_ace ace 
					where object_def_uuid not in ( select object_def_uuid from ols_area_ace);


end;
go

grant execute on [dbo].ols_ac_setup_area_ace to ca_itrm_group
go

/**
 *********************************************************************
 *********************************************************************
 *
 * Entry point for upgrading an DSM r11.1 MDB tp DSM 11.2 area code support
 *
 *********************************************************************
  *********************************************************************
*/

-- insert default config parameter for the default area
if not exists (select set_id from ca_settings where set_id = 900) 
begin
insert into ca_settings ( set_id, set_val_lng) values (900, 0xffffffff)
end
go

if not exists (select set_id from ca_settings where set_id = 901) 
begin
insert into ca_settings ( set_id, set_val_lng) values (901, 0)
end
go

-- upgrading the security profiles
exec ols_ac_setup_sp
go

-- creating the area permisions 
exec ols_ac_setup_area_ace
go
/* ****************** ols area support end  ************************ */






/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15095923, getdate(), 1, 4, 'Star 15095923 (MODIFIED 16208491 v1) DSM: OLS (Object Level Security) enhancements' )
GO

COMMIT TRANSACTION 
GO

