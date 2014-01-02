-----------------------------------------------------------------------------
--   Script Unit: mais_purge_script.sql
--   This script contains the commands to delete all the data from
--   the MAIS configuration database.  The script must be run from 
--   within dbaccess.  Dbaccess will prompt for a deletion confirm
--   request for each table.  
--                                                                           
-- MAIS Version:     1.0                                                     
-- SDL Hierarchy:    /fqt/target/app_files
 
-----------------------------------------------------------------------------
-- Responsible Engineer(s):                                                  
--  Id           Name                 Organization
--  ==========   ==================   =============================
--  mckinzie     Eric McKinzie        Loral Space and Range Systems
--
-----------------------------------------------------------------------------
-- Revision History:                                                         
--  Change    Date      SP/CR#     Id           Description
--  =======   ========  =======   ==========   ============================== 
--    1       01/03/96  C3-3317   mckinzie     First ADL entry 
--    2       10/25/96  C3-3518   mckinzie     Modified to include
--                                             firing_elem_ammo
--

------------------------------------------------------------------------------
-- IFDC Revision History:                                                         
--  Change    Date      SP/CR#     Id           Description
--  =======   ========  =======   ==========   ============================== 
--    1       03/25/97  IFDC-24   mckinzie     Added tables for IFDC

-----------------------------------------------------------------------------

DELETE FROM area_boundary;
DELETE FROM ext_dev_config;
DELETE FROM hutt_angle_0;
DELETE FROM hutt_angle_45;
DELETE FROM hutt_angle_90;
DELETE FROM enforced_filters;
DELETE FROM player_crew;
DELETE FROM grp_pre_prgm_ifdc;
DELETE FROM pu_pre_prgm_ifdc;
DELETE FROM group_membership;
DELETE FROM group;
DELETE FROM authorized_users;
DELETE FROM player_slot;
DELETE FROM player_type;
DELETE FROM player_weapon;
DELETE FROM player_unit;
DELETE FROM wp_1553_config;
DELETE FROM wp_serial_port;
DELETE FROM tcu;
DELETE FROM tdma;
DELETE FROM tdma_rtca;
DELETE FROM tdma_slot_plcmnt;
DELETE FROM encryption;
DELETE FROM encryption_key_idx;
DELETE FROM dr_slot;
DELETE FROM awe_rtca_configs;
DELETE FROM c3_relay;
DELETE FROM platform_table;
DELETE FROM firing_elem_ammo;
DELETE FROM firing_element;
DELETE FROM pre_prgm_missions;
DELETE FROM dir_vulnerability;
DELETE FROM ind_vulnerability;
DELETE FROM ammo_index;
DELETE FROM ammo;
DELETE FROM weapon;
DELETE FROM platform;
DELETE FROM scenario;
