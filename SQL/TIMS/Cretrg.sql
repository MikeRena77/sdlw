%% ============================================================
%%   Database name:  PROJECT                                   
%%   DBMS name:      Sybase SQL Anywhere 5.5                   
%%   Created on:     14/11/1997  12:48                         
%% ============================================================

%  Before insert trigger "tib_compose" for table "PROJ.COMPOSE"
create trigger tib_compose before insert on PROJ.COMPOSE
referencing new as new_ins for each row
begin
    declare user_defined_exception exception for SQLSTATE '99999';
    declare insert_child_parent_exist_exception exception for SQLSTATE '99991';
    declare insert_too_many_children_exception exception for SQLSTATE '99992';
    declare found integer;
    
    %  Parent "PROJ.MATERIAL" must exist when inserting a child in "PROJ.COMPOSE"
    if (new_ins.MATNUM is not null) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.MATERIAL
                      where  MATNUM = new_ins.MATNUM);
       if found <> 1 then
          signal insert_child_parent_exist_exception
       end if;
    end
    end if;
    
    %  Parent "PROJ.MATERIAL" must exist when inserting a child in "PROJ.COMPOSE"
    if (new_ins.MAT_MATNUM is not null) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.MATERIAL
                      where  MATNUM = new_ins.MAT_MATNUM);
       if found <> 1 then
          signal insert_child_parent_exist_exception
       end if;
    end
    end if;
exception
when insert_child_parent_exist_exception then
   message 'Error: Trigger(tib_compose) of table PROJ.COMPOSE';
   message '        Parent code must exist when inserting a child!';
   signal user_defined_exception;
when insert_too_many_children_exception then
   message 'Error: Trigger(tib_compose) of table PROJ.COMPOSE';
   message '        The maximum cardinality of a child has been exceeded!';
   signal user_defined_exception;
when others then
   message 'Exception in before insert trigger(tib_compose) of table PROJ.COMPOSE';
   resignal;
end
/

%  Before update trigger "tub_compose" for table "PROJ.COMPOSE"
create trigger tub_compose before update of MATNUM,
                                            MAT_MATNUM
on PROJ.COMPOSE
referencing new as new_upd old as old_upd for each row
begin
declare user_defined_exception exception for SQLSTATE '99999';
    declare update_change_column_exception exception for SQLSTATE '99991';
    declare update_child_change_parent_exception exception for SQLSTATE '99992';
    declare update_child_parent_exist_exception exception for SQLSTATE '99993';
    declare update_parent_restrict_exception exception for SQLSTATE '99994';
    declare update_too_many_children_exception exception for SQLSTATE '99995';
    declare found integer;
    
    %  Parent "PROJ.MATERIAL" must exist when updating a child in "PROJ.COMPOSE"
    if (new_upd.MATNUM is not null and
        ((old_upd.MATNUM is null) or
         (new_upd.MATNUM <> old_upd.MATNUM))) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.MATERIAL
                      where  MATNUM = new_upd.MATNUM);
       if found <> 1 then
          signal update_child_parent_exist_exception
       end if;
    end
    end if;
    
    %  Parent "PROJ.MATERIAL" must exist when updating a child in "PROJ.COMPOSE"
    if (new_upd.MAT_MATNUM is not null and
        ((old_upd.MAT_MATNUM is null) or
         (new_upd.MAT_MATNUM <> old_upd.MAT_MATNUM))) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.MATERIAL
                      where  MATNUM = new_upd.MAT_MATNUM);
       if found <> 1 then
          signal update_child_parent_exist_exception
       end if;
    end
    end if;
exception
when update_change_column_exception then
   message 'Error: Trigger(tub_compose) of table PROJ.COMPOSE';
   message '        Non modifiable column cannot be modified!';
   signal user_defined_exception;
when update_child_change_parent_exception then
   message 'Error: Trigger(tub_compose) of table PROJ.COMPOSE';
   message '        Cannot modify parent code in child!';
   signal user_defined_exception;
when update_child_parent_exist_exception then
   message 'Error: Trigger(tub_compose) of table PROJ.COMPOSE';
   message '        Parent must exist when updating a child!';
   signal user_defined_exception;
when update_parent_restrict_exception then
   message 'Error: Trigger(tub_compose) of table PROJ.COMPOSE';
   message '        Cannot modify parent code if children still exist!';
   signal user_defined_exception;
when update_too_many_children_exception then
   message 'Error: Trigger(tub_compose) of table PROJ.COMPOSE';
   message '        The maximum cardinality of a child has been exceeded!';
   signal user_defined_exception;
when others then
   message 'Exception in before update trigger(tub_compose) of table PROJ.COMPOSE';
   resignal;
end
/

%  Before update trigger "tub_customer" for table "PROJ.CUSTOMER"
create trigger tub_customer before update of CUSNUM
on PROJ.CUSTOMER
referencing new as new_upd old as old_upd for each row
begin
declare user_defined_exception exception for SQLSTATE '99999';
    declare update_change_column_exception exception for SQLSTATE '99991';
    declare update_child_change_parent_exception exception for SQLSTATE '99992';
    declare update_child_parent_exist_exception exception for SQLSTATE '99993';
    declare update_parent_restrict_exception exception for SQLSTATE '99994';
    declare update_too_many_children_exception exception for SQLSTATE '99995';
    declare found integer;
    
    %  Cannot modify parent code in "PROJ.CUSTOMER" if children still exist in "PROJ.PROJECT"
    if (new_upd.CUSNUM <> old_upd.CUSNUM ) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.PROJECT
                      where  CUSNUM = old_upd.CUSNUM);
       if found = 1 then
          signal update_parent_restrict_exception
       end if;
    end
    end if;
exception
when update_change_column_exception then
   message 'Error: Trigger(tub_customer) of table PROJ.CUSTOMER';
   message '        Non modifiable column cannot be modified!';
   signal user_defined_exception;
when update_child_change_parent_exception then
   message 'Error: Trigger(tub_customer) of table PROJ.CUSTOMER';
   message '        Cannot modify parent code in child!';
   signal user_defined_exception;
when update_child_parent_exist_exception then
   message 'Error: Trigger(tub_customer) of table PROJ.CUSTOMER';
   message '        Parent must exist when updating a child!';
   signal user_defined_exception;
when update_parent_restrict_exception then
   message 'Error: Trigger(tub_customer) of table PROJ.CUSTOMER';
   message '        Cannot modify parent code if children still exist!';
   signal user_defined_exception;
when update_too_many_children_exception then
   message 'Error: Trigger(tub_customer) of table PROJ.CUSTOMER';
   message '        The maximum cardinality of a child has been exceeded!';
   signal user_defined_exception;
when others then
   message 'Exception in before update trigger(tub_customer) of table PROJ.CUSTOMER';
   resignal;
end
/

%  Before delete trigger "tdb_customer" for table "PROJ.CUSTOMER"
create trigger tdb_customer before delete on PROJ.CUSTOMER
referencing old as old_del for each row
begin
    declare user_defined_exception exception for SQLSTATE '99999';
    declare delete_parent_restrict_exception exception for SQLSTATE '99991';
    declare found integer;
    
    %  Cannot delete parent "PROJ.CUSTOMER" if children still exist in "PROJ.PROJECT"
    set found = 0;
    select 1
     into  found
     from  dummy
    where  exists (select 1
                    from  PROJ.PROJECT
                   where  CUSNUM = old_del.CUSNUM);
    if found = 1 then
       signal delete_parent_restrict_exception
    end if;
exception
when delete_parent_restrict_exception then
   message 'Error: Trigger(tdb_customer) of table PROJ.CUSTOMER';
   message '        Cannot delete parent if children still exist!';
   signal user_defined_exception;
when others then
   message 'Exception in before delete trigger(tdb_customer) of table PROJ.CUSTOMER';
   resignal;
end
/

%  Before update trigger "tub_division" for table "ADMIN.DIVISION"
create trigger tub_division before update of DIVNUM
on ADMIN.DIVISION
referencing new as new_upd old as old_upd for each row
begin
declare user_defined_exception exception for SQLSTATE '99999';
    declare update_change_column_exception exception for SQLSTATE '99991';
    declare update_child_change_parent_exception exception for SQLSTATE '99992';
    declare update_child_parent_exist_exception exception for SQLSTATE '99993';
    declare update_parent_restrict_exception exception for SQLSTATE '99994';
    declare update_too_many_children_exception exception for SQLSTATE '99995';
    declare found integer;
    
    %  Cannot modify parent code in "ADMIN.DIVISION" if children still exist in "PROJ.EMPLOYEE"
    if (new_upd.DIVNUM <> old_upd.DIVNUM ) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.EMPLOYEE
                      where  DIVNUM = old_upd.DIVNUM);
       if found = 1 then
          signal update_parent_restrict_exception
       end if;
    end
    end if;
exception
when update_change_column_exception then
   message 'Error: Trigger(tub_division) of table ADMIN.DIVISION';
   message '        Non modifiable column cannot be modified!';
   signal user_defined_exception;
when update_child_change_parent_exception then
   message 'Error: Trigger(tub_division) of table ADMIN.DIVISION';
   message '        Cannot modify parent code in child!';
   signal user_defined_exception;
when update_child_parent_exist_exception then
   message 'Error: Trigger(tub_division) of table ADMIN.DIVISION';
   message '        Parent must exist when updating a child!';
   signal user_defined_exception;
when update_parent_restrict_exception then
   message 'Error: Trigger(tub_division) of table ADMIN.DIVISION';
   message '        Cannot modify parent code if children still exist!';
   signal user_defined_exception;
when update_too_many_children_exception then
   message 'Error: Trigger(tub_division) of table ADMIN.DIVISION';
   message '        The maximum cardinality of a child has been exceeded!';
   signal user_defined_exception;
when others then
   message 'Exception in before update trigger(tub_division) of table ADMIN.DIVISION';
   resignal;
end
/

%  Before delete trigger "tdb_division" for table "ADMIN.DIVISION"
create trigger tdb_division before delete on ADMIN.DIVISION
referencing old as old_del for each row
begin
    declare user_defined_exception exception for SQLSTATE '99999';
    declare delete_parent_restrict_exception exception for SQLSTATE '99991';
    declare found integer;
    
    %  Cannot delete parent "ADMIN.DIVISION" if children still exist in "PROJ.EMPLOYEE"
    set found = 0;
    select 1
     into  found
     from  dummy
    where  exists (select 1
                    from  PROJ.EMPLOYEE
                   where  DIVNUM = old_del.DIVNUM);
    if found = 1 then
       signal delete_parent_restrict_exception
    end if;
exception
when delete_parent_restrict_exception then
   message 'Error: Trigger(tdb_division) of table ADMIN.DIVISION';
   message '        Cannot delete parent if children still exist!';
   signal user_defined_exception;
when others then
   message 'Exception in before delete trigger(tdb_division) of table ADMIN.DIVISION';
   resignal;
end
/

%  Before insert trigger "tib_employee" for table "PROJ.EMPLOYEE"
create trigger tib_employee before insert on PROJ.EMPLOYEE
referencing new as new_ins for each row
begin
    declare user_defined_exception exception for SQLSTATE '99999';
    declare insert_child_parent_exist_exception exception for SQLSTATE '99991';
    declare insert_too_many_children_exception exception for SQLSTATE '99992';
    declare found integer;
    
    %  Parent "PROJ.EMPLOYEE" must exist when inserting a child in "PROJ.EMPLOYEE"
    if (new_ins.EMP_EMPNUM is not null) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.EMPLOYEE
                      where  EMPNUM = new_ins.EMP_EMPNUM);
       if found <> 1 then
          signal insert_child_parent_exist_exception
       end if;
    end
    end if;
    
    %  Parent "ADMIN.DIVISION" must exist when inserting a child in "PROJ.EMPLOYEE"
    if (new_ins.DIVNUM is not null) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  ADMIN.DIVISION
                      where  DIVNUM = new_ins.DIVNUM);
       if found <> 1 then
          signal insert_child_parent_exist_exception
       end if;
    end
    end if;
exception
when insert_child_parent_exist_exception then
   message 'Error: Trigger(tib_employee) of table PROJ.EMPLOYEE';
   message '        Parent code must exist when inserting a child!';
   signal user_defined_exception;
when insert_too_many_children_exception then
   message 'Error: Trigger(tib_employee) of table PROJ.EMPLOYEE';
   message '        The maximum cardinality of a child has been exceeded!';
   signal user_defined_exception;
when others then
   message 'Exception in before insert trigger(tib_employee) of table PROJ.EMPLOYEE';
   resignal;
end
/

%  Before update trigger "tub_employee" for table "PROJ.EMPLOYEE"
create trigger tub_employee before update of EMPNUM,
                                             EMP_EMPNUM,
                                             DIVNUM
on PROJ.EMPLOYEE
referencing new as new_upd old as old_upd for each row
begin
declare user_defined_exception exception for SQLSTATE '99999';
    declare update_change_column_exception exception for SQLSTATE '99991';
    declare update_child_change_parent_exception exception for SQLSTATE '99992';
    declare update_child_parent_exist_exception exception for SQLSTATE '99993';
    declare update_parent_restrict_exception exception for SQLSTATE '99994';
    declare update_too_many_children_exception exception for SQLSTATE '99995';
    declare found integer;
    
    %  Parent "PROJ.EMPLOYEE" must exist when updating a child in "PROJ.EMPLOYEE"
    if (new_upd.EMP_EMPNUM is not null and
        ((old_upd.EMP_EMPNUM is null) or
         (new_upd.EMP_EMPNUM <> old_upd.EMP_EMPNUM))) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.EMPLOYEE
                      where  EMPNUM = new_upd.EMP_EMPNUM);
       if found <> 1 then
          signal update_child_parent_exist_exception
       end if;
    end
    end if;
    
    %  Parent "ADMIN.DIVISION" must exist when updating a child in "PROJ.EMPLOYEE"
    if (new_upd.DIVNUM is not null and
        ((old_upd.DIVNUM is null) or
         (new_upd.DIVNUM <> old_upd.DIVNUM))) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  ADMIN.DIVISION
                      where  DIVNUM = new_upd.DIVNUM);
       if found <> 1 then
          signal update_child_parent_exist_exception
       end if;
    end
    end if;
    
    %  Cannot modify parent code in "PROJ.EMPLOYEE" if children still exist in "PROJ.MEMBER"
    if (new_upd.EMPNUM <> old_upd.EMPNUM ) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.MEMBER
                      where  EMPNUM = old_upd.EMPNUM);
       if found = 1 then
          signal update_parent_restrict_exception
       end if;
    end
    end if;
    
    %  Cannot modify parent code in "PROJ.EMPLOYEE" if children still exist in "PROJ.EMPLOYEE"
    if (new_upd.EMPNUM <> old_upd.EMPNUM ) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.EMPLOYEE
                      where  EMP_EMPNUM = old_upd.EMPNUM);
       if found = 1 then
          signal update_parent_restrict_exception
       end if;
    end
    end if;
    
    %  Cannot modify parent code in "PROJ.EMPLOYEE" if children still exist in "PROJ.PROJECT"
    if (new_upd.EMPNUM <> old_upd.EMPNUM ) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.PROJECT
                      where  EMPNUM = old_upd.EMPNUM);
       if found = 1 then
          signal update_parent_restrict_exception
       end if;
    end
    end if;
    
    %  Cannot modify parent code in "PROJ.EMPLOYEE" if children still exist in "PROJ.USED"
    if (new_upd.EMPNUM <> old_upd.EMPNUM ) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.USED
                      where  EMPNUM = old_upd.EMPNUM);
       if found = 1 then
          signal update_parent_restrict_exception
       end if;
    end
    end if;
    
    %  Cannot modify parent code in "PROJ.EMPLOYEE" if children still exist in "PROJ.PARTICIPATE"
    if (new_upd.EMPNUM <> old_upd.EMPNUM ) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.PARTICIPATE
                      where  EMPNUM = old_upd.EMPNUM);
       if found = 1 then
          signal update_parent_restrict_exception
       end if;
    end
    end if;
exception
when update_change_column_exception then
   message 'Error: Trigger(tub_employee) of table PROJ.EMPLOYEE';
   message '        Non modifiable column cannot be modified!';
   signal user_defined_exception;
when update_child_change_parent_exception then
   message 'Error: Trigger(tub_employee) of table PROJ.EMPLOYEE';
   message '        Cannot modify parent code in child!';
   signal user_defined_exception;
when update_child_parent_exist_exception then
   message 'Error: Trigger(tub_employee) of table PROJ.EMPLOYEE';
   message '        Parent must exist when updating a child!';
   signal user_defined_exception;
when update_parent_restrict_exception then
   message 'Error: Trigger(tub_employee) of table PROJ.EMPLOYEE';
   message '        Cannot modify parent code if children still exist!';
   signal user_defined_exception;
when update_too_many_children_exception then
   message 'Error: Trigger(tub_employee) of table PROJ.EMPLOYEE';
   message '        The maximum cardinality of a child has been exceeded!';
   signal user_defined_exception;
when others then
   message 'Exception in before update trigger(tub_employee) of table PROJ.EMPLOYEE';
   resignal;
end
/

%  Before delete trigger "tdb_employee" for table "PROJ.EMPLOYEE"
create trigger tdb_employee before delete on PROJ.EMPLOYEE
referencing old as old_del for each row
begin
    declare user_defined_exception exception for SQLSTATE '99999';
    declare delete_parent_restrict_exception exception for SQLSTATE '99991';
    declare found integer;
    
    %  Cannot delete parent "PROJ.EMPLOYEE" if children still exist in "PROJ.MEMBER"
    set found = 0;
    select 1
     into  found
     from  dummy
    where  exists (select 1
                    from  PROJ.MEMBER
                   where  EMPNUM = old_del.EMPNUM);
    if found = 1 then
       signal delete_parent_restrict_exception
    end if;
    
    %  Cannot delete parent "PROJ.EMPLOYEE" if children still exist in "PROJ.EMPLOYEE"
    set found = 0;
    select 1
     into  found
     from  dummy
    where  exists (select 1
                    from  PROJ.EMPLOYEE
                   where  EMP_EMPNUM = old_del.EMPNUM);
    if found = 1 then
       signal delete_parent_restrict_exception
    end if;
    
    %  Cannot delete parent "PROJ.EMPLOYEE" if children still exist in "PROJ.PROJECT"
    set found = 0;
    select 1
     into  found
     from  dummy
    where  exists (select 1
                    from  PROJ.PROJECT
                   where  EMPNUM = old_del.EMPNUM);
    if found = 1 then
       signal delete_parent_restrict_exception
    end if;
    
    %  Cannot delete parent "PROJ.EMPLOYEE" if children still exist in "PROJ.USED"
    set found = 0;
    select 1
     into  found
     from  dummy
    where  exists (select 1
                    from  PROJ.USED
                   where  EMPNUM = old_del.EMPNUM);
    if found = 1 then
       signal delete_parent_restrict_exception
    end if;
    
    %  Cannot delete parent "PROJ.EMPLOYEE" if children still exist in "PROJ.PARTICIPATE"
    set found = 0;
    select 1
     into  found
     from  dummy
    where  exists (select 1
                    from  PROJ.PARTICIPATE
                   where  EMPNUM = old_del.EMPNUM);
    if found = 1 then
       signal delete_parent_restrict_exception
    end if;
exception
when delete_parent_restrict_exception then
   message 'Error: Trigger(tdb_employee) of table PROJ.EMPLOYEE';
   message '        Cannot delete parent if children still exist!';
   signal user_defined_exception;
when others then
   message 'Exception in before delete trigger(tdb_employee) of table PROJ.EMPLOYEE';
   resignal;
end
/

%  Before update trigger "tub_material" for table "PROJ.MATERIAL"
create trigger tub_material before update of MATNUM
on PROJ.MATERIAL
referencing new as new_upd old as old_upd for each row
begin
declare user_defined_exception exception for SQLSTATE '99999';
    declare update_change_column_exception exception for SQLSTATE '99991';
    declare update_child_change_parent_exception exception for SQLSTATE '99992';
    declare update_child_parent_exist_exception exception for SQLSTATE '99993';
    declare update_parent_restrict_exception exception for SQLSTATE '99994';
    declare update_too_many_children_exception exception for SQLSTATE '99995';
    declare found integer;
    
    %  Cannot modify parent code in "PROJ.MATERIAL" if children still exist in "PROJ.USED"
    if (new_upd.MATNUM <> old_upd.MATNUM ) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.USED
                      where  MATNUM = old_upd.MATNUM);
       if found = 1 then
          signal update_parent_restrict_exception
       end if;
    end
    end if;
    
    %  Cannot modify parent code in "PROJ.MATERIAL" if children still exist in "PROJ.COMPOSE"
    if (new_upd.MATNUM <> old_upd.MATNUM ) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.COMPOSE
                      where  MATNUM = old_upd.MATNUM);
       if found = 1 then
          signal update_parent_restrict_exception
       end if;
    end
    end if;
    
    %  Cannot modify parent code in "PROJ.MATERIAL" if children still exist in "PROJ.COMPOSE"
    if (new_upd.MATNUM <> old_upd.MATNUM ) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.COMPOSE
                      where  MAT_MATNUM = old_upd.MATNUM);
       if found = 1 then
          signal update_parent_restrict_exception
       end if;
    end
    end if;
exception
when update_change_column_exception then
   message 'Error: Trigger(tub_material) of table PROJ.MATERIAL';
   message '        Non modifiable column cannot be modified!';
   signal user_defined_exception;
when update_child_change_parent_exception then
   message 'Error: Trigger(tub_material) of table PROJ.MATERIAL';
   message '        Cannot modify parent code in child!';
   signal user_defined_exception;
when update_child_parent_exist_exception then
   message 'Error: Trigger(tub_material) of table PROJ.MATERIAL';
   message '        Parent must exist when updating a child!';
   signal user_defined_exception;
when update_parent_restrict_exception then
   message 'Error: Trigger(tub_material) of table PROJ.MATERIAL';
   message '        Cannot modify parent code if children still exist!';
   signal user_defined_exception;
when update_too_many_children_exception then
   message 'Error: Trigger(tub_material) of table PROJ.MATERIAL';
   message '        The maximum cardinality of a child has been exceeded!';
   signal user_defined_exception;
when others then
   message 'Exception in before update trigger(tub_material) of table PROJ.MATERIAL';
   resignal;
end
/

%  Before delete trigger "tdb_material" for table "PROJ.MATERIAL"
create trigger tdb_material before delete on PROJ.MATERIAL
referencing old as old_del for each row
begin
    declare user_defined_exception exception for SQLSTATE '99999';
    declare delete_parent_restrict_exception exception for SQLSTATE '99991';
    declare found integer;
    
    %  Cannot delete parent "PROJ.MATERIAL" if children still exist in "PROJ.USED"
    set found = 0;
    select 1
     into  found
     from  dummy
    where  exists (select 1
                    from  PROJ.USED
                   where  MATNUM = old_del.MATNUM);
    if found = 1 then
       signal delete_parent_restrict_exception
    end if;
    
    %  Cannot delete parent "PROJ.MATERIAL" if children still exist in "PROJ.COMPOSE"
    set found = 0;
    select 1
     into  found
     from  dummy
    where  exists (select 1
                    from  PROJ.COMPOSE
                   where  MATNUM = old_del.MATNUM);
    if found = 1 then
       signal delete_parent_restrict_exception
    end if;
    
    %  Cannot delete parent "PROJ.MATERIAL" if children still exist in "PROJ.COMPOSE"
    set found = 0;
    select 1
     into  found
     from  dummy
    where  exists (select 1
                    from  PROJ.COMPOSE
                   where  MAT_MATNUM = old_del.MATNUM);
    if found = 1 then
       signal delete_parent_restrict_exception
    end if;
exception
when delete_parent_restrict_exception then
   message 'Error: Trigger(tdb_material) of table PROJ.MATERIAL';
   message '        Cannot delete parent if children still exist!';
   signal user_defined_exception;
when others then
   message 'Exception in before delete trigger(tdb_material) of table PROJ.MATERIAL';
   resignal;
end
/

%  Before insert trigger "tib_member" for table "PROJ.MEMBER"
create trigger tib_member before insert on PROJ.MEMBER
referencing new as new_ins for each row
begin
    declare user_defined_exception exception for SQLSTATE '99999';
    declare insert_child_parent_exist_exception exception for SQLSTATE '99991';
    declare insert_too_many_children_exception exception for SQLSTATE '99992';
    declare found integer;
    
    %  Parent "PROJ.TEAM" must exist when inserting a child in "PROJ.MEMBER"
    if (new_ins.TEANUM is not null) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.TEAM
                      where  TEANUM = new_ins.TEANUM);
       if found <> 1 then
          signal insert_child_parent_exist_exception
       end if;
    end
    end if;
    
    %  Parent "PROJ.EMPLOYEE" must exist when inserting a child in "PROJ.MEMBER"
    if (new_ins.EMPNUM is not null) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.EMPLOYEE
                      where  EMPNUM = new_ins.EMPNUM);
       if found <> 1 then
          signal insert_child_parent_exist_exception
       end if;
    end
    end if;
exception
when insert_child_parent_exist_exception then
   message 'Error: Trigger(tib_member) of table PROJ.MEMBER';
   message '        Parent code must exist when inserting a child!';
   signal user_defined_exception;
when insert_too_many_children_exception then
   message 'Error: Trigger(tib_member) of table PROJ.MEMBER';
   message '        The maximum cardinality of a child has been exceeded!';
   signal user_defined_exception;
when others then
   message 'Exception in before insert trigger(tib_member) of table PROJ.MEMBER';
   resignal;
end
/

%  Before update trigger "tub_member" for table "PROJ.MEMBER"
create trigger tub_member before update of TEANUM,
                                           EMPNUM
on PROJ.MEMBER
referencing new as new_upd old as old_upd for each row
begin
declare user_defined_exception exception for SQLSTATE '99999';
    declare update_change_column_exception exception for SQLSTATE '99991';
    declare update_child_change_parent_exception exception for SQLSTATE '99992';
    declare update_child_parent_exist_exception exception for SQLSTATE '99993';
    declare update_parent_restrict_exception exception for SQLSTATE '99994';
    declare update_too_many_children_exception exception for SQLSTATE '99995';
    declare found integer;
    
    %  Parent "PROJ.TEAM" must exist when updating a child in "PROJ.MEMBER"
    if (new_upd.TEANUM is not null and
        ((old_upd.TEANUM is null) or
         (new_upd.TEANUM <> old_upd.TEANUM))) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.TEAM
                      where  TEANUM = new_upd.TEANUM);
       if found <> 1 then
          signal update_child_parent_exist_exception
       end if;
    end
    end if;
    
    %  Parent "PROJ.EMPLOYEE" must exist when updating a child in "PROJ.MEMBER"
    if (new_upd.EMPNUM is not null and
        ((old_upd.EMPNUM is null) or
         (new_upd.EMPNUM <> old_upd.EMPNUM))) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.EMPLOYEE
                      where  EMPNUM = new_upd.EMPNUM);
       if found <> 1 then
          signal update_child_parent_exist_exception
       end if;
    end
    end if;
exception
when update_change_column_exception then
   message 'Error: Trigger(tub_member) of table PROJ.MEMBER';
   message '        Non modifiable column cannot be modified!';
   signal user_defined_exception;
when update_child_change_parent_exception then
   message 'Error: Trigger(tub_member) of table PROJ.MEMBER';
   message '        Cannot modify parent code in child!';
   signal user_defined_exception;
when update_child_parent_exist_exception then
   message 'Error: Trigger(tub_member) of table PROJ.MEMBER';
   message '        Parent must exist when updating a child!';
   signal user_defined_exception;
when update_parent_restrict_exception then
   message 'Error: Trigger(tub_member) of table PROJ.MEMBER';
   message '        Cannot modify parent code if children still exist!';
   signal user_defined_exception;
when update_too_many_children_exception then
   message 'Error: Trigger(tub_member) of table PROJ.MEMBER';
   message '        The maximum cardinality of a child has been exceeded!';
   signal user_defined_exception;
when others then
   message 'Exception in before update trigger(tub_member) of table PROJ.MEMBER';
   resignal;
end
/

%  Before insert trigger "tib_participate" for table "PROJ.PARTICIPATE"
create trigger tib_participate before insert on PROJ.PARTICIPATE
referencing new as new_ins for each row
begin
    declare user_defined_exception exception for SQLSTATE '99999';
    declare insert_child_parent_exist_exception exception for SQLSTATE '99991';
    declare insert_too_many_children_exception exception for SQLSTATE '99992';
    declare found integer;
    
    %  Parent "PROJ.EMPLOYEE" must exist when inserting a child in "PROJ.PARTICIPATE"
    if (new_ins.EMPNUM is not null) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.EMPLOYEE
                      where  EMPNUM = new_ins.EMPNUM);
       if found <> 1 then
          signal insert_child_parent_exist_exception
       end if;
    end
    end if;
    
    %  Parent "PROJ.TASK" must exist when inserting a child in "PROJ.PARTICIPATE"
    if (new_ins.PRONUM is not null and
        new_ins.TSKNAME is not null) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.TASK
                      where  PRONUM = new_ins.PRONUM
                       and   TSKNAME = new_ins.TSKNAME);
       if found <> 1 then
          signal insert_child_parent_exist_exception
       end if;
    end
    end if;
exception
when insert_child_parent_exist_exception then
   message 'Error: Trigger(tib_participate) of table PROJ.PARTICIPATE';
   message '        Parent code must exist when inserting a child!';
   signal user_defined_exception;
when insert_too_many_children_exception then
   message 'Error: Trigger(tib_participate) of table PROJ.PARTICIPATE';
   message '        The maximum cardinality of a child has been exceeded!';
   signal user_defined_exception;
when others then
   message 'Exception in before insert trigger(tib_participate) of table PROJ.PARTICIPATE';
   resignal;
end
/

%  Before update trigger "tub_participate" for table "PROJ.PARTICIPATE"
create trigger tub_participate before update of PRONUM,
                                                TSKNAME,
                                                EMPNUM
on PROJ.PARTICIPATE
referencing new as new_upd old as old_upd for each row
begin
declare user_defined_exception exception for SQLSTATE '99999';
    declare update_change_column_exception exception for SQLSTATE '99991';
    declare update_child_change_parent_exception exception for SQLSTATE '99992';
    declare update_child_parent_exist_exception exception for SQLSTATE '99993';
    declare update_parent_restrict_exception exception for SQLSTATE '99994';
    declare update_too_many_children_exception exception for SQLSTATE '99995';
    declare found integer;
    
    %  Parent "PROJ.EMPLOYEE" must exist when updating a child in "PROJ.PARTICIPATE"
    if (new_upd.EMPNUM is not null and
        ((old_upd.EMPNUM is null) or
         (new_upd.EMPNUM <> old_upd.EMPNUM))) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.EMPLOYEE
                      where  EMPNUM = new_upd.EMPNUM);
       if found <> 1 then
          signal update_child_parent_exist_exception
       end if;
    end
    end if;
    
    %  Parent "PROJ.TASK" must exist when updating a child in "PROJ.PARTICIPATE"
    if (new_upd.PRONUM is not null and
        new_upd.TSKNAME is not null and
        ((old_upd.PRONUM is null and
          old_upd.TSKNAME is null) or
         (new_upd.PRONUM <> old_upd.PRONUM or
          new_upd.TSKNAME <> old_upd.TSKNAME))) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.TASK
                      where  PRONUM = new_upd.PRONUM
                       and   TSKNAME = new_upd.TSKNAME);
       if found <> 1 then
          signal update_child_parent_exist_exception
       end if;
    end
    end if;
exception
when update_change_column_exception then
   message 'Error: Trigger(tub_participate) of table PROJ.PARTICIPATE';
   message '        Non modifiable column cannot be modified!';
   signal user_defined_exception;
when update_child_change_parent_exception then
   message 'Error: Trigger(tub_participate) of table PROJ.PARTICIPATE';
   message '        Cannot modify parent code in child!';
   signal user_defined_exception;
when update_child_parent_exist_exception then
   message 'Error: Trigger(tub_participate) of table PROJ.PARTICIPATE';
   message '        Parent must exist when updating a child!';
   signal user_defined_exception;
when update_parent_restrict_exception then
   message 'Error: Trigger(tub_participate) of table PROJ.PARTICIPATE';
   message '        Cannot modify parent code if children still exist!';
   signal user_defined_exception;
when update_too_many_children_exception then
   message 'Error: Trigger(tub_participate) of table PROJ.PARTICIPATE';
   message '        The maximum cardinality of a child has been exceeded!';
   signal user_defined_exception;
when others then
   message 'Exception in before update trigger(tub_participate) of table PROJ.PARTICIPATE';
   resignal;
end
/

%  Before insert trigger "tib_project" for table "PROJ.PROJECT"
create trigger tib_project before insert on PROJ.PROJECT
referencing new as new_ins for each row
begin
    declare user_defined_exception exception for SQLSTATE '99999';
    declare insert_child_parent_exist_exception exception for SQLSTATE '99991';
    declare insert_too_many_children_exception exception for SQLSTATE '99992';
    declare found integer;
    
    %  Parent "PROJ.CUSTOMER" must exist when inserting a child in "PROJ.PROJECT"
    if (new_ins.CUSNUM is not null) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.CUSTOMER
                      where  CUSNUM = new_ins.CUSNUM);
       if found <> 1 then
          signal insert_child_parent_exist_exception
       end if;
    end
    end if;
    
    %  Parent "PROJ.EMPLOYEE" must exist when inserting a child in "PROJ.PROJECT"
    if (new_ins.EMPNUM is not null) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.EMPLOYEE
                      where  EMPNUM = new_ins.EMPNUM);
       if found <> 1 then
          signal insert_child_parent_exist_exception
       end if;
    end
    end if;
exception
when insert_child_parent_exist_exception then
   message 'Error: Trigger(tib_project) of table PROJ.PROJECT';
   message '        Parent code must exist when inserting a child!';
   signal user_defined_exception;
when insert_too_many_children_exception then
   message 'Error: Trigger(tib_project) of table PROJ.PROJECT';
   message '        The maximum cardinality of a child has been exceeded!';
   signal user_defined_exception;
when others then
   message 'Exception in before insert trigger(tib_project) of table PROJ.PROJECT';
   resignal;
end
/

%  Before update trigger "tub_project" for table "PROJ.PROJECT"
create trigger tub_project before update of PRONUM,
                                            CUSNUM,
                                            EMPNUM
on PROJ.PROJECT
referencing new as new_upd old as old_upd for each row
begin
declare user_defined_exception exception for SQLSTATE '99999';
    declare update_change_column_exception exception for SQLSTATE '99991';
    declare update_child_change_parent_exception exception for SQLSTATE '99992';
    declare update_child_parent_exist_exception exception for SQLSTATE '99993';
    declare update_parent_restrict_exception exception for SQLSTATE '99994';
    declare update_too_many_children_exception exception for SQLSTATE '99995';
    declare found integer;
    
    %  Parent "PROJ.CUSTOMER" must exist when updating a child in "PROJ.PROJECT"
    if (new_upd.CUSNUM is not null and
        ((old_upd.CUSNUM is null) or
         (new_upd.CUSNUM <> old_upd.CUSNUM))) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.CUSTOMER
                      where  CUSNUM = new_upd.CUSNUM);
       if found <> 1 then
          signal update_child_parent_exist_exception
       end if;
    end
    end if;
    
    %  Parent "PROJ.EMPLOYEE" must exist when updating a child in "PROJ.PROJECT"
    if (new_upd.EMPNUM is not null and
        ((old_upd.EMPNUM is null) or
         (new_upd.EMPNUM <> old_upd.EMPNUM))) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.EMPLOYEE
                      where  EMPNUM = new_upd.EMPNUM);
       if found <> 1 then
          signal update_child_parent_exist_exception
       end if;
    end
    end if;
    
    %  Cannot modify parent code in "PROJ.PROJECT" if children still exist in "PROJ.TASK"
    if (new_upd.PRONUM <> old_upd.PRONUM ) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.TASK
                      where  PRONUM = old_upd.PRONUM);
       if found = 1 then
          signal update_parent_restrict_exception
       end if;
    end
    end if;
exception
when update_change_column_exception then
   message 'Error: Trigger(tub_project) of table PROJ.PROJECT';
   message '        Non modifiable column cannot be modified!';
   signal user_defined_exception;
when update_child_change_parent_exception then
   message 'Error: Trigger(tub_project) of table PROJ.PROJECT';
   message '        Cannot modify parent code in child!';
   signal user_defined_exception;
when update_child_parent_exist_exception then
   message 'Error: Trigger(tub_project) of table PROJ.PROJECT';
   message '        Parent must exist when updating a child!';
   signal user_defined_exception;
when update_parent_restrict_exception then
   message 'Error: Trigger(tub_project) of table PROJ.PROJECT';
   message '        Cannot modify parent code if children still exist!';
   signal user_defined_exception;
when update_too_many_children_exception then
   message 'Error: Trigger(tub_project) of table PROJ.PROJECT';
   message '        The maximum cardinality of a child has been exceeded!';
   signal user_defined_exception;
when others then
   message 'Exception in before update trigger(tub_project) of table PROJ.PROJECT';
   resignal;
end
/

%  Before delete trigger "tdb_project" for table "PROJ.PROJECT"
create trigger tdb_project before delete on PROJ.PROJECT
referencing old as old_del for each row
begin
    declare user_defined_exception exception for SQLSTATE '99999';
    declare delete_parent_restrict_exception exception for SQLSTATE '99991';
    declare found integer;
    
    %  Cannot delete parent "PROJ.PROJECT" if children still exist in "PROJ.TASK"
    set found = 0;
    select 1
     into  found
     from  dummy
    where  exists (select 1
                    from  PROJ.TASK
                   where  PRONUM = old_del.PRONUM);
    if found = 1 then
       signal delete_parent_restrict_exception
    end if;
exception
when delete_parent_restrict_exception then
   message 'Error: Trigger(tdb_project) of table PROJ.PROJECT';
   message '        Cannot delete parent if children still exist!';
   signal user_defined_exception;
when others then
   message 'Exception in before delete trigger(tdb_project) of table PROJ.PROJECT';
   resignal;
end
/

%  Before insert trigger "tib_task" for table "PROJ.TASK"
create trigger tib_task before insert on PROJ.TASK
referencing new as new_ins for each row
begin
    declare user_defined_exception exception for SQLSTATE '99999';
    declare insert_child_parent_exist_exception exception for SQLSTATE '99991';
    declare insert_too_many_children_exception exception for SQLSTATE '99992';
    declare found integer;
    
    %  Parent "PROJ.PROJECT" must exist when inserting a child in "PROJ.TASK"
    if (new_ins.PRONUM is not null) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.PROJECT
                      where  PRONUM = new_ins.PRONUM);
       if found <> 1 then
          signal insert_child_parent_exist_exception
       end if;
    end
    end if;
exception
when insert_child_parent_exist_exception then
   message 'Error: Trigger(tib_task) of table PROJ.TASK';
   message '        Parent code must exist when inserting a child!';
   signal user_defined_exception;
when insert_too_many_children_exception then
   message 'Error: Trigger(tib_task) of table PROJ.TASK';
   message '        The maximum cardinality of a child has been exceeded!';
   signal user_defined_exception;
when others then
   message 'Exception in before insert trigger(tib_task) of table PROJ.TASK';
   resignal;
end
/

%  Before update trigger "tub_task" for table "PROJ.TASK"
create trigger tub_task before update of PRONUM,
                                         TSKNAME
on PROJ.TASK
referencing new as new_upd old as old_upd for each row
begin
declare user_defined_exception exception for SQLSTATE '99999';
    declare update_change_column_exception exception for SQLSTATE '99991';
    declare update_child_change_parent_exception exception for SQLSTATE '99992';
    declare update_child_parent_exist_exception exception for SQLSTATE '99993';
    declare update_parent_restrict_exception exception for SQLSTATE '99994';
    declare update_too_many_children_exception exception for SQLSTATE '99995';
    declare found integer;
    
    %  Parent "PROJ.PROJECT" must exist when updating a child in "PROJ.TASK"
    if (new_upd.PRONUM is not null and
        ((old_upd.PRONUM is null) or
         (new_upd.PRONUM <> old_upd.PRONUM))) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.PROJECT
                      where  PRONUM = new_upd.PRONUM);
       if found <> 1 then
          signal update_child_parent_exist_exception
       end if;
    end
    end if;
    
    %  Cannot modify parent code in "PROJ.TASK" if children still exist in "PROJ.PARTICIPATE"
    if (new_upd.PRONUM <> old_upd.PRONUM or
        new_upd.TSKNAME <> old_upd.TSKNAME ) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.PARTICIPATE
                      where  PRONUM = old_upd.PRONUM
                       and   TSKNAME = old_upd.TSKNAME);
       if found = 1 then
          signal update_parent_restrict_exception
       end if;
    end
    end if;
exception
when update_change_column_exception then
   message 'Error: Trigger(tub_task) of table PROJ.TASK';
   message '        Non modifiable column cannot be modified!';
   signal user_defined_exception;
when update_child_change_parent_exception then
   message 'Error: Trigger(tub_task) of table PROJ.TASK';
   message '        Cannot modify parent code in child!';
   signal user_defined_exception;
when update_child_parent_exist_exception then
   message 'Error: Trigger(tub_task) of table PROJ.TASK';
   message '        Parent must exist when updating a child!';
   signal user_defined_exception;
when update_parent_restrict_exception then
   message 'Error: Trigger(tub_task) of table PROJ.TASK';
   message '        Cannot modify parent code if children still exist!';
   signal user_defined_exception;
when update_too_many_children_exception then
   message 'Error: Trigger(tub_task) of table PROJ.TASK';
   message '        The maximum cardinality of a child has been exceeded!';
   signal user_defined_exception;
when others then
   message 'Exception in before update trigger(tub_task) of table PROJ.TASK';
   resignal;
end
/

%  Before delete trigger "tdb_task" for table "PROJ.TASK"
create trigger tdb_task before delete on PROJ.TASK
referencing old as old_del for each row
begin
    declare user_defined_exception exception for SQLSTATE '99999';
    declare delete_parent_restrict_exception exception for SQLSTATE '99991';
    declare found integer;
    
    %  Cannot delete parent "PROJ.TASK" if children still exist in "PROJ.PARTICIPATE"
    set found = 0;
    select 1
     into  found
     from  dummy
    where  exists (select 1
                    from  PROJ.PARTICIPATE
                   where  PRONUM = old_del.PRONUM
                    and   TSKNAME = old_del.TSKNAME);
    if found = 1 then
       signal delete_parent_restrict_exception
    end if;
exception
when delete_parent_restrict_exception then
   message 'Error: Trigger(tdb_task) of table PROJ.TASK';
   message '        Cannot delete parent if children still exist!';
   signal user_defined_exception;
when others then
   message 'Exception in before delete trigger(tdb_task) of table PROJ.TASK';
   resignal;
end
/

%  Before update trigger "tub_team" for table "PROJ.TEAM"
create trigger tub_team before update of TEANUM
on PROJ.TEAM
referencing new as new_upd old as old_upd for each row
begin
declare user_defined_exception exception for SQLSTATE '99999';
    declare update_change_column_exception exception for SQLSTATE '99991';
    declare update_child_change_parent_exception exception for SQLSTATE '99992';
    declare update_child_parent_exist_exception exception for SQLSTATE '99993';
    declare update_parent_restrict_exception exception for SQLSTATE '99994';
    declare update_too_many_children_exception exception for SQLSTATE '99995';
    declare found integer;
    
    %  Cannot modify parent code in "PROJ.TEAM" if children still exist in "PROJ.MEMBER"
    if (new_upd.TEANUM <> old_upd.TEANUM ) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.MEMBER
                      where  TEANUM = old_upd.TEANUM);
       if found = 1 then
          signal update_parent_restrict_exception
       end if;
    end
    end if;
exception
when update_change_column_exception then
   message 'Error: Trigger(tub_team) of table PROJ.TEAM';
   message '        Non modifiable column cannot be modified!';
   signal user_defined_exception;
when update_child_change_parent_exception then
   message 'Error: Trigger(tub_team) of table PROJ.TEAM';
   message '        Cannot modify parent code in child!';
   signal user_defined_exception;
when update_child_parent_exist_exception then
   message 'Error: Trigger(tub_team) of table PROJ.TEAM';
   message '        Parent must exist when updating a child!';
   signal user_defined_exception;
when update_parent_restrict_exception then
   message 'Error: Trigger(tub_team) of table PROJ.TEAM';
   message '        Cannot modify parent code if children still exist!';
   signal user_defined_exception;
when update_too_many_children_exception then
   message 'Error: Trigger(tub_team) of table PROJ.TEAM';
   message '        The maximum cardinality of a child has been exceeded!';
   signal user_defined_exception;
when others then
   message 'Exception in before update trigger(tub_team) of table PROJ.TEAM';
   resignal;
end
/

%  Before delete trigger "tdb_team" for table "PROJ.TEAM"
create trigger tdb_team before delete on PROJ.TEAM
referencing old as old_del for each row
begin
    declare user_defined_exception exception for SQLSTATE '99999';
    declare delete_parent_restrict_exception exception for SQLSTATE '99991';
    declare found integer;
    
    %  Cannot delete parent "PROJ.TEAM" if children still exist in "PROJ.MEMBER"
    set found = 0;
    select 1
     into  found
     from  dummy
    where  exists (select 1
                    from  PROJ.MEMBER
                   where  TEANUM = old_del.TEANUM);
    if found = 1 then
       signal delete_parent_restrict_exception
    end if;
exception
when delete_parent_restrict_exception then
   message 'Error: Trigger(tdb_team) of table PROJ.TEAM';
   message '        Cannot delete parent if children still exist!';
   signal user_defined_exception;
when others then
   message 'Exception in before delete trigger(tdb_team) of table PROJ.TEAM';
   resignal;
end
/

%  Before insert trigger "tib_used" for table "PROJ.USED"
create trigger tib_used before insert on PROJ.USED
referencing new as new_ins for each row
begin
    declare user_defined_exception exception for SQLSTATE '99999';
    declare insert_child_parent_exist_exception exception for SQLSTATE '99991';
    declare insert_too_many_children_exception exception for SQLSTATE '99992';
    declare found integer;
    
    %  Parent "PROJ.MATERIAL" must exist when inserting a child in "PROJ.USED"
    if (new_ins.MATNUM is not null) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.MATERIAL
                      where  MATNUM = new_ins.MATNUM);
       if found <> 1 then
          signal insert_child_parent_exist_exception
       end if;
    end
    end if;
    
    %  Parent "PROJ.EMPLOYEE" must exist when inserting a child in "PROJ.USED"
    if (new_ins.EMPNUM is not null) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.EMPLOYEE
                      where  EMPNUM = new_ins.EMPNUM);
       if found <> 1 then
          signal insert_child_parent_exist_exception
       end if;
    end
    end if;
exception
when insert_child_parent_exist_exception then
   message 'Error: Trigger(tib_used) of table PROJ.USED';
   message '        Parent code must exist when inserting a child!';
   signal user_defined_exception;
when insert_too_many_children_exception then
   message 'Error: Trigger(tib_used) of table PROJ.USED';
   message '        The maximum cardinality of a child has been exceeded!';
   signal user_defined_exception;
when others then
   message 'Exception in before insert trigger(tib_used) of table PROJ.USED';
   resignal;
end
/

%  Before update trigger "tub_used" for table "PROJ.USED"
create trigger tub_used before update of MATNUM,
                                         EMPNUM
on PROJ.USED
referencing new as new_upd old as old_upd for each row
begin
declare user_defined_exception exception for SQLSTATE '99999';
    declare update_change_column_exception exception for SQLSTATE '99991';
    declare update_child_change_parent_exception exception for SQLSTATE '99992';
    declare update_child_parent_exist_exception exception for SQLSTATE '99993';
    declare update_parent_restrict_exception exception for SQLSTATE '99994';
    declare update_too_many_children_exception exception for SQLSTATE '99995';
    declare found integer;
    
    %  Parent "PROJ.MATERIAL" must exist when updating a child in "PROJ.USED"
    if (new_upd.MATNUM is not null and
        ((old_upd.MATNUM is null) or
         (new_upd.MATNUM <> old_upd.MATNUM))) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.MATERIAL
                      where  MATNUM = new_upd.MATNUM);
       if found <> 1 then
          signal update_child_parent_exist_exception
       end if;
    end
    end if;
    
    %  Parent "PROJ.EMPLOYEE" must exist when updating a child in "PROJ.USED"
    if (new_upd.EMPNUM is not null and
        ((old_upd.EMPNUM is null) or
         (new_upd.EMPNUM <> old_upd.EMPNUM))) then
    begin
       set found = 0;
       select 1
        into  found
        from  dummy
       where  exists (select 1
                       from  PROJ.EMPLOYEE
                      where  EMPNUM = new_upd.EMPNUM);
       if found <> 1 then
          signal update_child_parent_exist_exception
       end if;
    end
    end if;
exception
when update_change_column_exception then
   message 'Error: Trigger(tub_used) of table PROJ.USED';
   message '        Non modifiable column cannot be modified!';
   signal user_defined_exception;
when update_child_change_parent_exception then
   message 'Error: Trigger(tub_used) of table PROJ.USED';
   message '        Cannot modify parent code in child!';
   signal user_defined_exception;
when update_child_parent_exist_exception then
   message 'Error: Trigger(tub_used) of table PROJ.USED';
   message '        Parent must exist when updating a child!';
   signal user_defined_exception;
when update_parent_restrict_exception then
   message 'Error: Trigger(tub_used) of table PROJ.USED';
   message '        Cannot modify parent code if children still exist!';
   signal user_defined_exception;
when update_too_many_children_exception then
   message 'Error: Trigger(tub_used) of table PROJ.USED';
   message '        The maximum cardinality of a child has been exceeded!';
   signal user_defined_exception;
when others then
   message 'Exception in before update trigger(tub_used) of table PROJ.USED';
   resignal;
end
/

