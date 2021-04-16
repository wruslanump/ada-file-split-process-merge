-- File	 : pkg_ada_file_line_properties.ads
-- Date  : Tue 09 Mar 2021 09:18:35 AM +08
-- Author: WRY wruslandr@gmail.com
-- ========================================================
with Ada.Text_IO;

-- ========================================================
package pkg_ada_file_line_properties 
-- ========================================================
--   with SPARK_Mode => on
is
   -- LIST OF PACKAGES RENAMED -- S for specification (.ads)
   package SATIO renames Ada.Text_IO; 
   
   -- LIST OF PROCEDURES
   procedure exec_file_line_properties (
                             inp_fmode    : in SATIO.File_Mode; 
                             inp_fname    : in String; 
                             inp_fform    : in String;
                             inp_fOwnID   : in String
                            );
   
   procedure display_help_file; 
   procedure about_package;
   
   -- LIST OF FUNCTIONS
      
-- ========================================================
end pkg_ada_file_line_properties;
-- ========================================================    
     
