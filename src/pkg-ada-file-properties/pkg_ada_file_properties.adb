-- File	 : pkg_ada_file_properties.adb
-- Date	 : Tue 09 Mar 2021 09:18:35 AM +08
-- Author: WRY wruslandr@gmail.com
-- ========================================================
-- REF: https://www.adaic.org/resources/add_content/standards/05rm/html/RM-A-16.html
-- Ada.Directories

-- ADA STANDARD PACKAGES
with Ada.Text_IO;
with Ada.Directories;  
with Ada.Calendar;
with Ada.Calendar.Formatting;
use  Ada.Calendar.Formatting;
with Ada.Strings.Unbounded;

-- USER CREATED ADA PACKAGES 


-- ========================================================
package body pkg_ada_file_properties 
-- ========================================================
--   with SPARK_Mode => on
is

   package ATIO   renames Ada.Text_IO;
   package AD     renames Ada.Directories;
   package ACal   renames Ada.Calendar;
   package ACalF  renames Ada.Calendar.Formatting;
   package ASU    renames Ada.Strings.Unbounded;
   
   
   
   -- =======================================================
   -- TEMPLATE FOR GENERIC FILE VARIABLES
   -- =======================================================
   -- new filehandle possible with sharing
   inp_fhandle  : ATIO.File_Type;   

   -- =====================================================
   procedure exec_file_open (inp_fhandle : in out ATIO.File_Type; -- must be in/out
                             inp_fmode   : in ATIO.File_Mode;
                             inp_fname   : in String; 
                             inp_fform   : in String;
                             inp_fOwnID  : in String
                            )
   -- =====================================================
   -- with SPARK_Mode => on
   is
      
   begin 
      
      -- Attempt to open file  (Does not use inp_fOwnID) 
      ATIO.Open (inp_fhandle, inp_fmode, inp_fname, inp_fform); 
      
      if  not ATIO.Is_Open (inp_fhandle) then
         ATIO.Put_Line ("FAILED. Procedure exec_open_file (inp_fhandle, inp_fmode, inp_fname, inp_fform)");
         -- Never get to this point (intervention by Ada language engine on open failure) 
         
      else  -- COMMENT WHEN NOT REQUIRED LIKE DEBUGGING
            -- ATIO.Put_Line ("SUCCESS. Procedure exec_open_file (inp_fhandle, inp_fmode, inp_fname, " & inp_fform & ")");
            -- ATIO.Put_Line ("inp_fmode   = " & ATIO.File_Mode'Image (inp_fmode));
            -- ATIO.Put_Line ("inp_fname   = " & inp_fname);
            -- ATIO.Put_Line ("inp_fform   = " & inp_fform);
            -- ATIO.Put_Line ("inp_fOwnID  = " & inp_fOwnID);
         null;
      end if;
      -- ATIO.New_Line;
      
   end exec_file_open;
   
   -- =====================================================
   procedure exec_file_close (inp_fhandle : in out ATIO.File_Type; -- Must be in/out 
                              inp_fform   : in String;
                              inp_fOwnID  : in String
                             )
   -- =====================================================
   -- with SPARK_Mode => on
   is
      
   begin 
      
      -- Attempt to close file    
      ATIO.Close (inp_fhandle);   -- fhandle should be closed now.
      
      if  ATIO.Is_Open (inp_fhandle) then  -- fhandle still open
          ATIO.Put_Line ("FAILED. Procedure exec_close_file (inp_fhandle, " & inp_fform & ", " & inp_fOwnID & ")");
          ATIO.New_Line;
      else  -- COMMENT WHEN NOT REQUIRED LIKE DEBUGGING
         -- ATIO.Put_Line ("SUCCESS. Procedure exec_close_file (inp_fhandle, " & inp_fform & ", " & inp_fOwnID & ")");
         -- ATIO.New_Line;
         null;
      end if;
    
   end exec_file_close;
          
   -- NOTE: inp_fhandel_01 will be obtained internally in this package
   -- =====================================================
   procedure exec_file_properties (inp_fmode  : in ATIO.File_Mode;
                                   inp_fname  : in String;
                                   inp_fform  : in String;
                                   inp_fOwnID : in String
                                  )
   -- =====================================================
   -- with SPARK_Mode => on
   is
      
   begin 
         
      -- NOTE CALL ANOTHER PACKAGE
      -- new filehandle possible with sharing
      ATIO.Put_Line("Running... PAFP.exec_file_open (inp_fhandle, inp_fmode, " & inp_fname & ", " & inp_fform & ", " & inp_fOwnID & ")");
      exec_file_open (inp_fhandle, inp_fmode, inp_fname, inp_fform, inp_fOwnID);
      ATIO.Put_Line("Completed: PAFP.exec_file_open (inp_fhandle, inp_fmode, " & inp_fname & ", " & inp_fform & ", " & inp_fOwnID & ")");
      
      ATIO.Put_Line ("inp_fmode  = " & ATIO.File_Mode'Image (inp_fmode));
      ATIO.Put_Line ("inp_fname  = " & inp_fname);
      ATIO.Put_Line ("inp_fform  = " & inp_fform);
      ATIO.Put_Line ("inp_fOwnID = " & inp_fOwnID);
      ATIO.Put_Line ("File Size  = " & AD.File_Size'Image (AD.Size (inp_fname)) & " bytes");
      ATIO.Put_Line ("File Full_Name         = " & AD.Full_Name (inp_fname));
      ATIO.Put_Line ("File Extension         = " & AD.Extension (inp_fname));
      ATIO.Put ("File Modification_Time = "); 
      ATIO.Put_Line (ACALF.Image (AD.Modification_Time (inp_fname)));
      
   -- ATIO.Put ("File_Kind  = ");
   -- ATIO.Put_Line (AD.File_Kind'Image (AD.File_Kind (inp_fname)));
            
      -- NOTE CALL ANOTHER PACKAGE
      ATIO.Put_Line("Running... PAFP.exec_file_close (inp_fhandle, " & inp_fform & ", " & inp_fOwnID & ")");
      exec_file_close (inp_fhandle, inp_fform, inp_fOwnID);
      ATIO.Put_Line("Completed: PAFP.exec_file_close (inp_fhandle, " & inp_fform & ", " & inp_fOwnID & ")");
      
   end exec_file_properties;
   
   -- =====================================================
   procedure display_help_file is 
   -- =====================================================
      inp_fhandle : ATIO.File_Type; 
      inp_fmode   : ATIO.File_Mode := ATIO.In_File;
      inp_fname   : String := "src/pkg-ada-file-properties/pkg_ada_file_properties.hlp";
      inp_UBlineStr : ASU.Unbounded_String;
   
   begin
      ATIO.Open (inp_fhandle, inp_fmode, inp_fname); 
      
      -- Traverse file line by line and display line to screen
      while not ATIO.End_Of_File (inp_fhandle) loop
         inp_UBlineStr := ASU.To_Unbounded_String(ATIO.Get_Line (inp_fhandle));
         ATIO.Put_Line (ATIO.Standard_Output, ASU.To_String (inp_UBlineStr)); 
      end loop;   
      
      ATIO.Close(inp_fhandle);
   end display_help_file;
      
   -- =====================================================
   procedure about_package is 
   -- =====================================================  
   begin
      -- Read from external text file and display      
      display_help_file;
      
   end about_package; 
     
-- =======================================================   
begin  -- FOR PACKAGE BODY
  null;
-- ========================================================
end pkg_ada_file_properties;
-- ========================================================    
