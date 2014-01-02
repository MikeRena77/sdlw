-----------------------------------------------------------------------------
--   Script Unit: mais_save_script.sql
--   This script contains the commands to save the entire MAIS configuration
--   database to a flat file directory.  This directory is /MAIS/db_data. 
--   This script must be run under dbaccess.  It is recommended that any data
--   already stored under /MAIS/db_data be moved if it is needed for any 
--   reason, this script will overwrite the data in that directory.
--   
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

UNLOAD TO "/MAIS/db_data/ammo.data" SELECT * FROM ammo;
UNLOAD TO "/MAIS/db_data/ammo_index.data" SELECT * FROM ammo_index;
UNLOAD TO "/MAIS/db_data/area_boundary.data" SELECT * FROM area_boundary;
UNLOAD TO "/MAIS/db_data/ext_dev_config.data" SELECT * FROM ext_dev_config;
UNLOAD TO "/MAIS/db_data/authorized_users.data" SELECT * FROM authorized_users;
UNLOAD TO "/MAIS/db_data/awe_rtca_configs.data" SELECT * FROM awe_rtca_configs;
UNLOAD TO "/MAIS/db_data/c3_relay.data" SELECT * FROM c3_relay;
UNLOAD TO "/MAIS/db_data/dir_vulnerability.data" SELECT * FROM dir_vulnerability;
UNLOAD TO "/MAIS/db_data/dr_slot.data" SELECT * FROM dr_slot;
UNLOAD TO "/MAIS/db_data/encryption.data" SELECT * FROM encryption;
UNLOAD TO "/MAIS/db_data/encryption_key_idx.data" SELECT * FROM encryption_key_idx;
UNLOAD TO "/MAIS/db_data/enforced_filters.data" SELECT * FROM enforced_filters;
UNLOAD TO "/MAIS/db_data/firing_element.data" SELECT * FROM firing_element;
UNLOAD TO "/MAIS/db_data/firing_elem_ammo.data" SELECT * FROM firing_elem_ammo;
UNLOAD TO "/MAIS/db_data/group.data" SELECT * FROM group;
UNLOAD TO "/MAIS/db_data/group_membership.data" SELECT * FROM group_membership;
UNLOAD TO "/MAIS/db_data/grp_pre_prgm_ifdc.data" SELECT * FROM grp_pre_prgm_ifdc;
UNLOAD TO "/MAIS/db_data/hutt_angle_0.data" SELECT * FROM hutt_angle_0;
UNLOAD TO "/MAIS/db_data/hutt_angle_45.data" SELECT * FROM hutt_angle_45;
UNLOAD TO "/MAIS/db_data/hutt_angle_90.data" SELECT * FROM hutt_angle_90;
UNLOAD TO "/MAIS/db_data/ind_vulnerability.data" SELECT * FROM ind_vulnerability;
UNLOAD TO "/MAIS/db_data/platform.data" SELECT * FROM platform;
UNLOAD TO "/MAIS/db_data/platform_table.data" SELECT * FROM platform_table;
UNLOAD TO "/MAIS/db_data/player_crew.data" SELECT * FROM player_crew;
UNLOAD TO "/MAIS/db_data/player_slot.data" SELECT * FROM player_slot;
UNLOAD TO "/MAIS/db_data/player_type.data" SELECT * FROM player_type;
UNLOAD TO "/MAIS/db_data/player_unit.data" SELECT * FROM player_unit;
UNLOAD TO "/MAIS/db_data/player_weapon.data" SELECT * FROM player_weapon;
UNLOAD TO "/MAIS/db_data/pu_pre_prgm_ifdc.data" SELECT * FROM pu_pre_prgm_ifdc;
UNLOAD TO "/MAIS/db_data/pre_prgm_missions.data" SELECT * FROM pre_prgm_missions;
UNLOAD TO "/MAIS/db_data/scenario.data" SELECT * FROM scenario;
UNLOAD TO "/MAIS/db_data/tcu.data" SELECT * FROM tcu;
UNLOAD TO "/MAIS/db_data/tdma.data" SELECT * FROM tdma;
UNLOAD TO "/MAIS/db_data/tdma_rtca.data" SELECT * FROM tdma_rtca;
UNLOAD TO "/MAIS/db_data/tdma_slot_plcmnt.data" SELECT * FROM tdma_slot_plcmnt;
UNLOAD TO "/MAIS/db_data/weapon.data" SELECT * FROM weapon;
UNLOAD TO "/MAIS/db_data/wp_1553_config.data" SELECT * FROM wp_1553_config;
UNLOAD TO "/MAIS/db_data/wp_serial_port.data" SELECT * FROM wp_serial_port;
