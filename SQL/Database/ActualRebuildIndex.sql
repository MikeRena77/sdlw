-- -----------------------------------------------------------------------------------
-- File Name    : http://www.oracle-base.com/dba/miscellaneous/ActualRebuildIndex.sql
-- Author       : Michael Andrews
-- Description  : Rebuilds the specified index, or all indexes.
-- Call Syntax  : @ActualRebuildIndex
-- Last Modified: 25 Sep 2008
-- Generated from script rebuild_index.sql, but generated script originally lacked 
--   table_owner specification for each index and script would not run.
--
-- This script is used for the optimization of the SCM r12 Oracle DB
-- -----------------------------------------------------------------------------------

SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF

-- SPOOL rebuildSCMUser.log


ALTER INDEX SCMUSER.HARACTION_PK REBUILD;                                               
ALTER INDEX SCMUSER.HARACTION_RTID_IND REBUILD;                                         
ALTER INDEX SCMUSER.HARALLCHILDRENPATH_CHILDITEM REBUILD;                               
ALTER INDEX SCMUSER.HARALLCHILDRENPATH_CHILDV_IDX REBUILD;                              
ALTER INDEX SCMUSER.HARALLCHILDRENPATH_ITEMCHILD REBUILD;                               
ALTER INDEX SCMUSER.HARALLCHILDRENPATH_PK REBUILD;                                      
ALTER INDEX SCMUSER.HARALLCHILDRENPATH_VERID_IDX REBUILD;                               
ALTER INDEX SCMUSER.HARALLUSERS_OBJIDNAME REBUILD;                                      
ALTER INDEX SCMUSER.HARALLUSERS_PK REBUILD;                                             
ALTER INDEX SCMUSER.HARAPPROVEHIST_IND REBUILD;                                         
ALTER INDEX SCMUSER.HARAPPROVEHIST_PK REBUILD;                                          
ALTER INDEX SCMUSER.HARAPPROVELIST_IND_IND REBUILD;                                     
ALTER INDEX SCMUSER.HARAPPROVELIST_STGRP REBUILD;                                       
ALTER INDEX SCMUSER.HARAPPROVE_PK REBUILD;                                              
ALTER INDEX SCMUSER.HARASSOCPKG_IND REBUILD;                                            
ALTER INDEX SCMUSER.HARASSOCPKG_PK REBUILD;                                             
ALTER INDEX SCMUSER.HARAUDITEVENTDESCRIPTION_PK REBUILD;                                
ALTER INDEX SCMUSER.HARAUDITEVENTRESOURCEL1_PK REBUILD;                                 
ALTER INDEX SCMUSER.HARAUDITEVENTRESOURCEL2_PK REBUILD;                                 
ALTER INDEX SCMUSER.HARAUDITEVENTRESOURCEL3_PK REBUILD;                                 
ALTER INDEX SCMUSER.HARAUDITEVENTRESOURCEL4_PK REBUILD;                                 
ALTER INDEX SCMUSER.HARAUDITEVENTRSRCL1_RESID_IND REBUILD;                              
ALTER INDEX SCMUSER.HARAUDITEVENTRSRCL1_RTID_IND REBUILD;                               
ALTER INDEX SCMUSER.HARAUDITEVENTRSRCL2_RESID_IND REBUILD;                              
ALTER INDEX SCMUSER.HARAUDITEVENTRSRCL2_RTID_IND REBUILD;                               
ALTER INDEX SCMUSER.HARAUDITEVENTRSRCL3_RESID_IND REBUILD;                              
ALTER INDEX SCMUSER.HARAUDITEVENTRSRCL3_RTID_IND REBUILD;                               
ALTER INDEX SCMUSER.HARAUDITEVENTRSRCL4_RESID_IND REBUILD;                              
ALTER INDEX SCMUSER.HARAUDITEVENTRSRCL4_RTID_IND REBUILD;                               
ALTER INDEX SCMUSER.HARAUDITEVENT_ACTID_IND REBUILD;                                    
ALTER INDEX SCMUSER.HARAUDITEVENT_EVTID_IND REBUILD;                                    
ALTER INDEX SCMUSER.HARAUDITEVENT_PK REBUILD;                                           
ALTER INDEX SCMUSER.HARAUDITEVENT_RESID_IND REBUILD;                                    
ALTER INDEX SCMUSER.HARAUDITEVENT_RTID_IND REBUILD;                                     
ALTER INDEX SCMUSER.HARBRANCH_ISMERGED REBUILD;                                         
ALTER INDEX SCMUSER.HARBRANCH_ITEMID_FK REBUILD;                                        
ALTER INDEX SCMUSER.HARBRANCH_PK REBUILD;                                               
ALTER INDEX SCMUSER.HARBRANCH_PKG REBUILD;                                              
ALTER INDEX SCMUSER.HARCHECKINPROC_PK REBUILD;                                          
ALTER INDEX SCMUSER.HARCHECKOUTPROC_PK REBUILD;                                         
ALTER INDEX SCMUSER.HARCOMMENT_PK REBUILD;                                              
ALTER INDEX SCMUSER.HARCONMRGPROC_PK REBUILD;                                           
ALTER INDEX SCMUSER.HARCRPKGPROC_PK REBUILD;                                            
ALTER INDEX SCMUSER.HARCRSENVMRGPROC_PK REBUILD;                                        
ALTER INDEX SCMUSER.HARDEFECT_PK REBUILD;                                               
ALTER INDEX SCMUSER.HARDELPKGPROC_PK REBUILD;                                           
ALTER INDEX SCMUSER.HARDELVERSPROC_PK REBUILD;                                          
ALTER INDEX SCMUSER.HARDEMOTEPROC_PK REBUILD;                                           
ALTER INDEX SCMUSER.HARENVACCESS_PK REBUILD;                                            
ALTER INDEX SCMUSER.HARENVIRONMENT_ACTIVE_IND REBUILD;                                  
ALTER INDEX SCMUSER.HARENVIRONMENT_ARCHIVE_IND REBUILD;                                 
ALTER INDEX SCMUSER.HARENVIRONMENT_BASELINE_IND REBUILD;                                
ALTER INDEX SCMUSER.HARENVIRONMENT_IND REBUILD;                                         
ALTER INDEX SCMUSER.HARENVIRONMENT_PK REBUILD;                                          
ALTER INDEX SCMUSER.HARESD_PK REBUILD;                                                  
ALTER INDEX SCMUSER.HAREXECUTABLEACTION_PK REBUILD;                                     
ALTER INDEX SCMUSER.HARFILEEXTENSION_PK REBUILD;                                        
ALTER INDEX SCMUSER.HARFORMATTACHMENT_IND REBUILD;                                      
ALTER INDEX SCMUSER.HARFORMATTACHMENT_IND2 REBUILD;                                     
ALTER INDEX SCMUSER.HARFORMATTACHMENT_PK REBUILD;                                       
ALTER INDEX SCMUSER.HARFORMHIST_IND REBUILD;                                            
ALTER INDEX SCMUSER.HARFORMTEMPLATES_PK REBUILD;                                        
ALTER INDEX SCMUSER.HARFORMTYPEACCESS_PK REBUILD;                                       
ALTER INDEX SCMUSER.HARFORMTYPEDEFS_ALT REBUILD;                                        
ALTER INDEX SCMUSER.HARFORMTYPEDEFS_IND REBUILD;                                        
ALTER INDEX SCMUSER.HARFORMTYPEDEFS_PK REBUILD;                                         
ALTER INDEX SCMUSER.HARFORMTYPE_PK REBUILD;                                             
ALTER INDEX SCMUSER.HARFORMTYPE_TABLENAME_IND REBUILD;                                  
ALTER INDEX SCMUSER.HARFORMTYPE_TYPENAME_IND REBUILD;                                   
ALTER INDEX SCMUSER.HARFORM_IND REBUILD;                                                
ALTER INDEX SCMUSER.HARFORM_PK REBUILD;                                                 
ALTER INDEX SCMUSER.HARGLOBALAUDITPOLICY_ACTID_IND REBUILD;                             
ALTER INDEX SCMUSER.HARGLOBALAUDITPOLICY_PK REBUILD;                                    
ALTER INDEX SCMUSER.HARHARVEST_PK REBUILD;                                              
ALTER INDEX SCMUSER.HARINTMRGPROC_PK REBUILD;                                           
ALTER INDEX SCMUSER.HARITEMACCESS_PK REBUILD;                                           
ALTER INDEX SCMUSER.HARITEMACCESS_USRGRP REBUILD;                                       
ALTER INDEX SCMUSER.HARITEMACCESS_VIEW REBUILD;                                         
ALTER INDEX SCMUSER.HARITEMNAME_ITEMNAME REBUILD;                                       
ALTER INDEX SCMUSER.HARITEMNAME_ITEMNAMEUPPER REBUILD;                                  
ALTER INDEX SCMUSER.HARITEMNAME_OBJIDNAME REBUILD;                                      
ALTER INDEX SCMUSER.HARITEMNAME_PK REBUILD;                                             
ALTER INDEX SCMUSER.HARITEMS_IND_TYPE REBUILD;                                          
ALTER INDEX SCMUSER.HARITEMS_ITEMNAME REBUILD;                                          
ALTER INDEX SCMUSER.HARITEMS_ITEMNAMEUPPER REBUILD;                                     
ALTER INDEX SCMUSER.HARITEMS_PARENTTYPE REBUILD;                                        
ALTER INDEX SCMUSER.HARITEMS_PID_FK REBUILD;                                            
ALTER INDEX SCMUSER.HARITEMS_PK REBUILD;                                                
ALTER INDEX SCMUSER.HARITEMS_REPOSITOBJID REBUILD;                                      
ALTER INDEX SCMUSER.HARLINKEDPROCESS_IND REBUILD;                                       
ALTER INDEX SCMUSER.HARLINKEDPROCESS_PARENT REBUILD;                                    
ALTER INDEX SCMUSER.HARLINKEDPROCESS_PK REBUILD;                                        
ALTER INDEX SCMUSER.HARLINKEDPROCESS_POBJID REBUILD;                                    
ALTER INDEX SCMUSER.HARLINKEDPROCESS_STATEOBJID REBUILD;                                
ALTER INDEX SCMUSER.HARLISTDIFFPROC_PK REBUILD;                                         
ALTER INDEX SCMUSER.HARLISTVERSPROC_PK REBUILD;                                         
ALTER INDEX SCMUSER.HARMOVEITEMPROC_PK REBUILD;                                         
ALTER INDEX SCMUSER.HARMOVEPATHPROC_PK REBUILD;                                         
ALTER INDEX SCMUSER.HARMOVEPKGPROC_PK REBUILD;                                          
ALTER INDEX SCMUSER.HARMR_PK REBUILD;                                                   
ALTER INDEX SCMUSER.HARNOTIFYLIST_IND REBUILD;                                          
ALTER INDEX SCMUSER.HARNOTIFYLIST_PARENTPROCOBJID REBUILD;                              
ALTER INDEX SCMUSER.HARNOTIFY_PARENTPROCOBJID REBUILD;                                  
ALTER INDEX SCMUSER.HARNOTIFY_PK REBUILD;                                               
ALTER INDEX SCMUSER.HAROBJECTSEQUENCEID_PK REBUILD;                                     
ALTER INDEX SCMUSER.HARPACKAGEGROUP_PK REBUILD;                                         
ALTER INDEX SCMUSER.HARPACKAGENAMEGEN_PK REBUILD;                                       
ALTER INDEX SCMUSER.HARPACKAGESTATUS_C_IDX REBUILD;                                     
ALTER INDEX SCMUSER.HARPACKAGESTATUS_PK REBUILD;                                        
ALTER INDEX SCMUSER.HARPACKAGESTATUS_S_IDX REBUILD;                                     
ALTER INDEX SCMUSER.HARPACKAGE_IND REBUILD;                                             
ALTER INDEX SCMUSER.HARPACKAGE_IND_ENV REBUILD;                                         
ALTER INDEX SCMUSER.HARPACKAGE_PK REBUILD;                                              
ALTER INDEX SCMUSER.HARPAC_PK REBUILD;                                                  
ALTER INDEX SCMUSER.HARPASSWORDHISTORY_PK REBUILD;                                      
ALTER INDEX SCMUSER.HARPATHFULLNAME_PATH REBUILD;                                       
ALTER INDEX SCMUSER.HARPATHFULLNAME_PK REBUILD;                                         
ALTER INDEX SCMUSER.HARPATHFULLNAME_PUPPER REBUILD;                                     
ALTER INDEX SCMUSER.HARPKGGRP_IND REBUILD;                                              
ALTER INDEX SCMUSER.HARPKGHISTORY_ACTION_IND REBUILD;                                   
ALTER INDEX SCMUSER.HARPKGHIST_IND REBUILD;                                             
ALTER INDEX SCMUSER.HARPKGSINCMEW_PK REBUILD;                                           
ALTER INDEX SCMUSER.HARPKGSINPKGGRP_IND REBUILD;                                        
ALTER INDEX SCMUSER.HARPKGSINPKGGRP_PK REBUILD;                                         
ALTER INDEX SCMUSER.HARPMSTATUS_PK REBUILD;                                             
ALTER INDEX SCMUSER.HARPROBLEMREPORT_PK REBUILD;                                        
ALTER INDEX SCMUSER.HARPROMOTEPROC_PK REBUILD;                                          
ALTER INDEX SCMUSER.HARQANDA_PK REBUILD;                                                
ALTER INDEX SCMUSER.HARREMITEMPROC_PK REBUILD;                                          
ALTER INDEX SCMUSER.HARREMOVEPATHPROC_PK REBUILD;                                       
ALTER INDEX SCMUSER.HARRENAMEITEMPROC_PK REBUILD;                                       
ALTER INDEX SCMUSER.HARRENAMEPATHPROC_PK REBUILD;                                       
ALTER INDEX SCMUSER.HARREPINVIEW_PK REBUILD;                                            
ALTER INDEX SCMUSER.HARREPINVIEW_REPOSITOBJID REBUILD;                                  
ALTER INDEX SCMUSER.HARREPOSITORYACCESS_PK REBUILD;                                     
ALTER INDEX SCMUSER.HARREPOSITORY_IND REBUILD;                                          
ALTER INDEX SCMUSER.HARREPOSITORY_PK REBUILD;                                           
ALTER INDEX SCMUSER.HARRESOURCETYPECHILD_PK REBUILD;                                    
ALTER INDEX SCMUSER.HARRESOURCETYPEDESCENDANT_PK REBUILD;                               
ALTER INDEX SCMUSER.HARRESOURCETYPE_PK REBUILD;                                         
ALTER INDEX SCMUSER.HARSNAPVIEWPROC_PK REBUILD;                                         
ALTER INDEX SCMUSER.HARSTATEACCESS_PK REBUILD;                                          
ALTER INDEX SCMUSER.HARSTATEPROCESSACCESS_PK REBUILD;                                   
ALTER INDEX SCMUSER.HARSTATEPROCESSACCESS_PUE REBUILD;                                  
ALTER INDEX SCMUSER.HARSTATEPROCESS_PK REBUILD;                                         
ALTER INDEX SCMUSER.HARSTATEPROC_IND REBUILD;                                           
ALTER INDEX SCMUSER.HARSTATEPROC_POBJID REBUILD;                                        
ALTER INDEX SCMUSER.HARSTATE_ENVOBJID REBUILD;                                          
ALTER INDEX SCMUSER.HARSTATE_IND REBUILD;                                               
ALTER INDEX SCMUSER.HARSTATE_LIST REBUILD;                                              
ALTER INDEX SCMUSER.HARSTATE_PK REBUILD;                                                
ALTER INDEX SCMUSER.HARSWITCHPKGPROC_PK REBUILD;                                        
ALTER INDEX SCMUSER.HARTESTINGINFO_PK REBUILD;                                          
ALTER INDEX SCMUSER.HARUDP_PARENTPROCOBJID REBUILD;                                     
ALTER INDEX SCMUSER.HARUDP_PK REBUILD;                                                  
ALTER INDEX SCMUSER.HARUDP_PSOBJID REBUILD;                                             
ALTER INDEX SCMUSER.HARUDP_PSTATEOBJID REBUILD;                                         
ALTER INDEX SCMUSER.HARUSDCOMPUTERNAMES_NAME_IND REBUILD;                               
ALTER INDEX SCMUSER.HARUSDDEPLOYINFO_ATTACH_IND REBUILD;                                
ALTER INDEX SCMUSER.HARUSDDEPLOYINFO_FRM_IND REBUILD;                                   
ALTER INDEX SCMUSER.HARUSDDEPLOYINFO_PKG_IND REBUILD;                                   
ALTER INDEX SCMUSER.HARUSDGROUPNAMES_NAME_IND REBUILD;                                  
ALTER INDEX SCMUSER.HARUSDPACKAGEINFO_FRM_IND REBUILD;                                  
ALTER INDEX SCMUSER.HARUSDPACKAGENAMES_NAME_IND REBUILD;                                
ALTER INDEX SCMUSER.HARUSDPLATFORMINFO_FRM_IND REBUILD;                                 
ALTER INDEX SCMUSER.HARUSERCONTACT_PK REBUILD;                                          
ALTER INDEX SCMUSER.HARUSERDATA_PK REBUILD;                                             
ALTER INDEX SCMUSER.HARUSERGROUP_IND REBUILD;                                           
ALTER INDEX SCMUSER.HARUSERGROUP_PK REBUILD;                                            
ALTER INDEX SCMUSER.HARUSERSINGROUP_BASELINE_IND REBUILD;                               
ALTER INDEX SCMUSER.HARUSERSINGROUP_PK REBUILD;                                         
ALTER INDEX SCMUSER.HARUSER_IND REBUILD;                                                
ALTER INDEX SCMUSER.HARUSER_PK REBUILD;                                                 
ALTER INDEX SCMUSER.HARVERSIONDATA_ITMID_FK REBUILD;                                    
ALTER INDEX SCMUSER.HARVERSIONDATA_PK REBUILD;                                          
ALTER INDEX SCMUSER.HARVERSIONDELTA_PARENT REBUILD;                                     
ALTER INDEX SCMUSER.HARVERSIONDELTA_PK REBUILD;                                         
ALTER INDEX SCMUSER.HARVERSIONINVIEW_PK REBUILD;                                        
ALTER INDEX SCMUSER.HARVERSIONS_DATA REBUILD;                                           
ALTER INDEX SCMUSER.HARVERSIONS_INBRTYPSTAT REBUILD;                                    
ALTER INDEX SCMUSER.HARVERSIONS_ITEMMAPPED REBUILD;                                     
ALTER INDEX SCMUSER.HARVERSIONS_ITEMOBJID REBUILD;                                      
ALTER INDEX SCMUSER.HARVERSIONS_ITEM_IND REBUILD;                                       
ALTER INDEX SCMUSER.HARVERSIONS_MERGED_IDX REBUILD;                                     
ALTER INDEX SCMUSER.HARVERSIONS_NAMEITEM REBUILD;                                       
ALTER INDEX SCMUSER.HARVERSIONS_PAR_IND REBUILD;                                        
ALTER INDEX SCMUSER.HARVERSIONS_PK REBUILD;                                             
ALTER INDEX SCMUSER.HARVERSIONS_PKG_IND REBUILD;                                        
ALTER INDEX SCMUSER.HARVERSIONS_REFACTORBY REBUILD;                                     
ALTER INDEX SCMUSER.HARVERSIONS_STATUS REBUILD;                                         
ALTER INDEX SCMUSER.HARVERSIONS_VC REBUILD;                                             
ALTER INDEX SCMUSER.HARVERSIONS_VERITEM REBUILD;                                        
ALTER INDEX SCMUSER.HARVERSIONS_VSTATUS REBUILD;                                        
ALTER INDEX SCMUSER.HARVERSIONTRACKING_FK_IND REBUILD;                                  
ALTER INDEX SCMUSER.HARVERSION_NAMEIDPATHID_IDX REBUILD;                                
ALTER INDEX SCMUSER.HARVERSION_PKGBRANCHSTAT REBUILD;                                   
ALTER INDEX SCMUSER.HARVIEW_ENV_IND REBUILD;                                            
ALTER INDEX SCMUSER.HARVIEW_NAME_IND REBUILD;                                           
ALTER INDEX SCMUSER.HARVIEW_OBJIDNAME REBUILD;                                          
ALTER INDEX SCMUSER.HARVIEW_PK REBUILD;                                                 
ALTER INDEX SCMUSER.HARVIEW_VIEWTYPE REBUILD;                                           
ALTER INDEX SCMUSER.HARVIV_VERS_IND REBUILD;                                            
ALTER INDEX SCMUSER.HONDEMANDCR_PK REBUILD;


SET PAGESIZE 14
SET FEEDBACK ON
SET VERIFY ON
-- spool off

exit
