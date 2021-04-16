-- File	 : pkg_ada_file_properties.ads
-- Date  : Tue 09 Mar 2021 09:18:35 AM +08
-- Author: WRY wruslandr@gmail.com
-- ========================================================
with Ada.Text_IO;

-- ========================================================
package pkg_ada_file_properties 
-- ========================================================
--   with SPARK_Mode => on
is
   -- LIST OF PACKAGES RENAMED 
   package SATIO renames Ada.Text_IO; 
   
   -- LIST OF PROCEDURES
   -- procedure exec_file_properties (inp_fhandle : SATIO.File_Type);
   
   -- LIST OF FUNCTIONS
    -- get_fileName
	-- get_fileDirectory
	-- fileFullPath
	-- fileSize
	-- filePermissions
	-- fileDate  
   
   -- NOTE: No need for inp_fhandle
   procedure exec_file_properties (inp_fmode  : in SATIO.File_Mode; 
                                   inp_fname  : in String; 
                                   inp_fform  : in String;
                                   inp_fOwnID : in String
                                  );
   
   
   
    --   function  Mode (File : in File_Type) return File_Mode;
    --   function  Name (File : in File_Type) return String;
    --   function  Form (File : in File_Type) return String;
    --   function  Size (File : in File_Type) return Count; 
    -- Operates on a file of any mode. Returns the current size of the external file that is associated with the given file.
    
   procedure display_help_file; 
   procedure about_package;
      
-- ========================================================
end pkg_ada_file_properties;
-- ========================================================    
     
