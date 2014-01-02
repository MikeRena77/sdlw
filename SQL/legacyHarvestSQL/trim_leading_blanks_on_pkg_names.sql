CREATE OR REPLACE TRIGGER hp_ltrim_pkgname
BEFORE INSERT OR UPDATE ON harpackage
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
begin
    :new.packagename := ltrim(:new.packagename);
end;
/

CREATE OR REPLACE TRIGGER hpg_ltrim_pkgname
BEFORE INSERT OR UPDATE ON harpackagegroup
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
begin
    :new.pkggrpname := ltrim(:new.pkggrpname);
end;
/
