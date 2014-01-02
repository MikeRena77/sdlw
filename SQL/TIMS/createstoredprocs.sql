
create procedure GetFormNo

as

declare @LastFormNo int
declare @Today datetime

select @Today = getdate()
select @LastFormNo = (select FormNo from LastFormNo (TabLock))
if @LastFormNo = null
  select @LastFormNo = 1
else
  select @LastFormNo = @LastFormNo + 1
update LastFormNo set FormNo = @LastFormNo, 
                    LastUpDate = @Today
from LastFormNo (TabLockX)

select @LastFormNo

GO

create procedure GetInvRecordNo

as

declare @LastInvRecordNo int
declare @Today datetime

select @Today = getdate()
select @LastInvRecordNo = (select InvRecordNo from LastInvRecordNo (TabLock)) + 1
update LastInvRecordNo set InvRecordNo = @LastInvRecordNo, 
                    LastUpDate = @Today
from LastInvRecordNo (TabLockX)

select @LastInvRecordNo


GO


create procedure GetRecordNo

as

declare @LastRecordNo int
declare @Today datetime

select @Today = getdate()
select @LastRecordNo = (select RecordNo from LastPropRecordNo (TabLock)) + 1
update LastPropRecordNo set RecordNo = @LastRecordNo, 
                    LastUpDate = @Today
from LastPropRecordNo (TabLockX)

select @LastRecordNo

GO

create procedure GetTransaction

as

declare @LastTransaction decimal
declare @Today datetime
declare @SiteCode decimal
declare @LastBase smallint
declare @Year decimal
declare @Month int
declare @Day int

select @Today = getdate()
select @SiteCode = 10*1000000000000
select @Year = datepart(year,@Today)*1000000
select @Year = @Year * 100
select @Month = datepart(month,@Today)*1000000
select @Day = datepart(day,@Today)*10000
select @LastBase = (select LastBase from LastTransaction (TabLock)) + 1
if @LastBase = null
  select @LastBase = 0
select @LastTransaction = @SiteCode + @Year + @Month + @Day + @LastBase
update LastTransaction set LastTransaction = @LastTransaction, 
                    LastBase = @LastBase,
                    LastDate = @Today
from LastTransaction (TabLockX)

select @LastTransaction
GO


create procedure GetTestNo

as

declare @LastTestNo smallint
declare @Today datetime

select @Today = getdate()
select @LastTestNo = (select TestNo from LastTestNo (TabLock))
if @LastTestNo = null
  select @LastTestNo = 1
else
  select @LastTestNo = @LastTestNo + 1
update LastTestNo set TestNo = @LastTestNo, 
                    LastUpDate = @Today
from LastTestNo (TabLockX)

select @LastTestNo

GO

create procedure GetNextStockNo @FSC char(4) 

as

declare @seqno char(4)
declare @stockno char(16)
declare @exists tinyint

select @seqno = null

select @seqno = SeqNo
from LastStockNo
where FSC = @FSC

if @@rowcount = 0
  begin
    select @seqno = "0001"
    insert into LastStockNo
    values (@FSC, @seqno)
  end
else
  begin
    select @seqno = convert(char(4),convert(int,@seqno) + 1)
    if convert(int,@seqno) < 10
      select @seqno = "000" + @seqno
    else if convert(int,@seqno) < 100
      select @seqno = "00" + @seqno
    else if convert(int,@seqno) < 1000
      select @seqno = "0" + @seqno
    select @exists = 0
    while (@exists = 0)
      begin
        select @stockno = stockno 
        from property 
        where stockno = @FSC + "-01-Z33-" + @seqno
        if @@rowcount = 0
          begin
            update LastStockNo
            set SeqNo = @seqno
            where FSC = @FSC
            select @exists = 1
          end
        else
          begin          
            select @seqno = convert(char(4),convert(int,@seqno) + 1)
            if convert(int,@seqno) < 10
              select @seqno = "000" + @seqno
            else if convert(int,@seqno) < 100
              select @seqno = "00" + @seqno
            else if convert(int,@seqno) < 1000
              select @seqno = "0" + @seqno
          end
       end
    end
select @stockno = @FSC + "-01-Z33-" + @seqno
select @stockno

go

