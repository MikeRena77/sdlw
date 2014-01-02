--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE

Drop Sequence harBranchSeq;
Drop Sequence harEnvironmentSeq;
Drop Sequence harFormSeq;
Drop Sequence harItemsSeq;
Drop Sequence harPackageSeq;
Drop Sequence harPackageGroupSeq;
Drop Sequence harProcessSeq;
Drop Sequence harRepositorySeq;
Drop Sequence harStateSeq;
Drop Sequence harUserSeq;
Drop Sequence harUserGroupSeq;
Drop Sequence harVersionDataSeq;
Drop Sequence harVersionsSeq;
Drop Sequence harViewSeq;

Delete From harObjectSequenceId Where hartablename != 'harFormAttachment';

@CreateSequence.sql

EXIT