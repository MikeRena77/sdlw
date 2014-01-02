-----------------------------------------------------------------------------
--   Script Unit: mais_restore_script.sql
--   This script contains the commands to restore all the data previously
--   saved back into the MAIS configuration database.  This command must
--   be run within dbaccess.  It is recommended that the database being used
--   for population of this data be empty of any other data.  This is to 
--   avoid referential constraint problems.  The data is loaded from the
--   /MAIS/db_data directory.
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

------------------------------------------------------------------------------
-- IFDC Revision History:                                                         
--  Change    Date      SP/CR#     Id           Description
--  =======   ========  =======   ==========   ============================== 
--    1       03/25/97  IFDC-24   mckinzie     Added tables for IFDC

-----------------------------------------------------------------------------

LOAD FROM "/MAIS/db_data/authorized_users.data" INSERT INTO authorized_users;
LOAD FROM "/MAIS/db_data/platform.data" INSERT INTO platform;
LOAD FROM "/MAIS/db_data/platform_table.data" INSERT INTO platform_table;
LOAD FROM "/MAIS/db_data/weapon.data" INSERT INTO weapon;
LOAD FROM "/MAIS/db_data/ammo.data" INSERT INTO ammo;
LOAD FROM "/MAIS/db_data/ammo_index.data" INSERT INTO ammo_index;
LOAD FROM "/MAIS/db_data/firing_element.data" INSERT INTO firing_element;
LOAD FROM "/MAIS/db_data/firing_elem_ammo.data" INSERT INTO firing_elem_ammo;
LOAD FROM "/MAIS/db_data/pre_prgm_missions.data" INSERT INTO pre_prgm_missions;
LOAD FROM "/MAIS/db_data/dir_vulnerability.data" INSERT INTO dir_vulnerability;
LOAD FROM "/MAIS/db_data/ind_vulnerability.data" INSERT INTO ind_vulnerability;
LOAD FROM "/MAIS/db_data/hutt_angle_0.data" INSERT INTO hutt_angle_0;
LOAD FROM "/MAIS/db_data/hutt_angle_45.data" INSERT INTO hutt_angle_45;
LOAD FROM "/MAIS/db_data/hutt_angle_90.data" INSERT INTO hutt_angle_90;
LOAD FROM "/MAIS/db_data/player_unit.data" INSERT INTO player_unit;
LOAD FROM "/MAIS/db_data/player_crew.data" INSERT INTO player_crew;
LOAD FROM "/MAIS/db_data/player_slot.data" INSERT INTO player_slot;
LOAD FROM "/MAIS/db_data/player_type.data" INSERT INTO player_type;
LOAD FROM "/MAIS/db_data/player_weapon.data" INSERT INTO player_weapon;
LOAD FROM "/MAIS/db_data/group.data" INSERT INTO group;
LOAD FROM "/MAIS/db_data/group_membership.data" INSERT INTO group_membership;
LOAD FROM "/MAIS/db_data/grp_pre_prgm_ifdc.data" INSERT INTO grp_pre_prgm_ifdc;
LOAD FROM "/MAIS/db_data/pu_pre_prgm_ifdc.data" INSERT INTO pu_pre_prgm_ifdc;
LOAD FROM "/MAIS/db_data/area_boundary.data" INSERT INTO area_boundary;
LOAD FROM "/MAIS/db_data/ext_dev_config.data" INSERT INTO ext_dev_config;
LOAD FROM "/MAIS/db_data/awe_rtca_configs.data" INSERT INTO awe_rtca_configs;
LOAD FROM "/MAIS/db_data/c3_relay.data" INSERT INTO c3_relay;
LOAD FROM "/MAIS/db_data/enforced_filters.data" INSERT INTO enforced_filters;
LOAD FROM "/MAIS/db_data/dr_slot.data" INSERT INTO dr_slot;
LOAD FROM "/MAIS/db_data/encryption.data" INSERT INTO encryption;
LOAD FROM "/MAIS/db_data/encryption_key_idx.data" INSERT INTO encryption_key_idx;
LOAD FROM "/MAIS/db_data/tcu.data" INSERT INTO tcu;
LOAD FROM "/MAIS/db_data/tdma.data" INSERT INTO tdma;
LOAD FROM "/MAIS/db_data/tdma_rtca.data" INSERT INTO tdma_rtca;
LOAD FROM "/MAIS/db_data/tdma_slot_plcmnt.data" INSERT INTO tdma_slot_plcmnt;
LOAD FROM "/MAIS/db_data/wp_1553_config.data" INSERT INTO wp_1553_config;
LOAD FROM "/MAIS/db_data/wp_serial_port.data" INSERT INTO wp_serial_port;
LOAD FROM "/MAIS/db_data/scenario.data" INSERT INTO scenario;
