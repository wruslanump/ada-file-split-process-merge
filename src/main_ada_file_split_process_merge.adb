-- File   : main_ada_file_split_process_merge.adb
-- Date   : Fri 16 Apr 2021 07:38:14 AM +08
-- Author : wruslandr@gmail.com
-- Version: 1.0 Sun 07 Mar 2021 06:00:42 PM +08
-- ========================================================

-- IMPORT STANDARD ADA PACKAGES
with Ada.Text_IO;
use  Ada.Text_IO;
with Ada.Real_Time; 
use  Ada.Real_Time;
with Ada.Strings.Unbounded;

-- IMPORT USER-DEFINED ADA PACKAGES
with pkg_ada_datetime_stamp;
with pkg_ada_realtime_delays;
with pkg_ada_file_properties;
with pkg_ada_file_line_properties;
with pkg_ada_file_read_write;

-- ========================================================
procedure main_ada_file_split_process_merge
-- ========================================================
--	with SPARK_Mode => on
is 
   -- RENAME STANDARD ADA PACKAGES FOR CONVENIENCE
   package ATIO    renames Ada.Text_IO;
   package ART     renames Ada.Real_Time;
   package ASU     renames Ada.Strings.Unbounded;
      
   -- RENAME USER-DEFINED ADA PACKAGES FOR CONVENIENCE
   package PADTS   renames pkg_ada_datetime_stamp;
   package PARTD   renames pkg_ada_realtime_delays;
   package PAFP    renames pkg_ada_file_properties;
   package PAFLP   renames pkg_ada_file_line_properties;
   package PAFRW   renames pkg_ada_file_read_write;
   
   -- PACKAGE-WIDE VARIABLE DEFINITIONS
   -- ====================================================
   startClock, finishClock   : ART.Time;  

   -- INPUT FILE 
   inp_fhandle      : ATIO.File_Type;
   inp_fmode        : ATIO.File_Mode  := ATIO.In_File;
   inp_fname        : String := "files/bismillah.ngc"; 
   inp_fform        : String := "shared=yes"; 
   inp_fOwnID       : String := "bsm-001";
   
   inp_lineCount    : Integer := 0;
   inp_UBlineStr    : ASU.Unbounded_String;
   files_toSplit    : Integer := 3;
   lines_perFile    : Integer := 0;
   
   start_lineFile_01 : Integer := 0;
   end_lineFile_01   : Integer := 0;
   start_lineFile_02 : Integer := 0;
   end_lineFile_02   : Integer := 0;
   start_lineFile_03 : Integer := 0;
   end_lineFile_03   : Integer := 0;
   
   -- OUTPUT FILES
   out_fhandle_01    : ATIO.File_Type;
   out_fhandle_02    : ATIO.File_Type;
   out_fhandle_03    : ATIO.File_Type;
   
   out_fmode_01      : ATIO.File_Mode  := ATIO.Out_File;
   out_fmode_02      : ATIO.File_Mode  := ATIO.Out_File;
   out_fmode_03      : ATIO.File_Mode  := ATIO.Out_File;
   
   out_fname_01  : String := "files/bismillah.ngc_file_01.txt";
   out_fname_02  : String := "files/bismillah.ngc_file_02.txt";
   out_fname_03  : String := "files/bismillah.ngc_file_03.txt";
      
   -- MERGED FILE
   merged_fhandle : ATIO.File_Type;
   merged_fmode   : ATIO.File_Mode  := ATIO.Append_File;
   merged_fname   : String := "files/bismillah.ngc_merged.txt";
   
   
   -- =====================================================
   procedure display_help_file is 
   -- =====================================================
      this_fhandle : ATIO.File_Type; 
      this_fmode   : ATIO.File_Mode := ATIO.In_File;
      this_fname   : String := "src/main_ada_file_split_process_merge.hlp";
      this_UBlineStr : ASU.Unbounded_String;
   
   begin
      ATIO.Open (this_fhandle, this_fmode, this_fname); 
      
      -- Traverse file line by line and display line to screen
      while not ATIO.End_Of_File (this_fhandle) loop
         this_UBlineStr := ASU.To_Unbounded_String(ATIO.Get_Line (this_fhandle));
         ATIO.Put_Line (ATIO.Standard_Output, ASU.To_String (this_UBlineStr)); 
      end loop;   
      
      ATIO.Close(this_fhandle);
   end display_help_file;
    
   -- =====================================================
   procedure about_this_procedure is
   -- =====================================================   
   begin
      -- Read external file to read description
      display_help_file;
      
   end about_this_procedure;
  
     
-- ========================================================   
begin  -- FOR procedure main_xxx
   
   startClock := ART.Clock; PADTS.dtstamp;
   ATIO.Put_Line ("STARTED: main Bismillah 3 times WRY");
   PADTS.dtstamp; ATIO.Put_Line ("Running inside GNAT Studio Community");
   ATIO.New_Line;
   -- about_this_procedure; 
   
   -- CODE BEGINS HERE
   -- =====================================================
   -- PADTS.about_package;
   -- PARTD.about_package;
   -- PAFP.about_package;
   -- PAFLP.about_package;
   -- PAFRW.about_package;
   
   -- GET FILE PROPERTIES
   -- PAFP.exec_file_properties (inp_fmode, inp_fname, inp_fform, inp_fOwnID );
   -- GET LINE PROPERTIES
   -- PAFLP.exec_file_line_properties (inp_fmode, inp_fname, inp_fform, inp_fOwnID );
   
   -- OPEN INPUT FILE - SHARING = YES 
   -- GET TOTAL LINE COUNT
   ATIO.Open (inp_fhandle, inp_fmode, inp_fname, inp_fform); 
   while not ATIO.End_Of_File (inp_fhandle) loop
      inp_UBlineStr := ASU.To_Unbounded_String(ATIO.Get_Line (inp_fhandle));
      inp_lineCount := inp_lineCount + 1;
   end loop;   
   ATIO.Close (inp_fhandle);
   ATIO.Put_line ("Total inp_lineCount = " & Integer'Image(inp_lineCount));
   
   -- SPLIT LINES TO 3 FILES
   lines_perFile := inp_lineCount / files_toSplit;
   ATIO.Put_line ("Calculated lines_perFile = " & Integer'Image(lines_perFile));
   
   start_lineFile_01 := 1; end_lineFile_01 := 1 * (lines_perFile);
   
   start_lineFile_02 := 1 * (lines_perFile) + 1;  end_lineFile_02 := 2 * (lines_perFile);
   
   start_lineFile_03 := 2 * (lines_perFile) + 1;  end_lineFile_03 := inp_lineCount;
   
   -- SPECIFY START AND END LINES FOR EACH FILE
   ATIO.Put_Line ("Lines for_File_01: Start = " & Integer'Image(start_lineFile_01) & " End = " &  Integer'Image(end_lineFile_01));
   ATIO.Put_Line ("Lines for_File_02: Start = " & Integer'Image(start_lineFile_02) & " End = " &  Integer'Image(end_lineFile_02));
   ATIO.Put_Line ("Lines for_File_03: Start = " & Integer'Image(start_lineFile_03) & " End = " &  Integer'Image(end_lineFile_03));
   
   -- SPLIT INTO 3 FILES
   ATIO.Open (inp_fhandle, inp_fmode, inp_fname, inp_fform); 
   ATIO.Create (out_fhandle_01, out_fmode_01, out_fname_01); 
   ATIO.Create (out_fhandle_02, out_fmode_02, out_fname_02);
   ATIO.Create (out_fhandle_03, out_fmode_03, out_fname_03);
   
   -- RESET LINE COUNT
   inp_lineCount := 0;
   
   while not ATIO.End_Of_File (inp_fhandle) loop
      inp_UBlineStr := ASU.To_Unbounded_String(ATIO.Get_Line (inp_fhandle));
      inp_lineCount := inp_lineCount + 1;
      
      if (inp_lineCount >= start_lineFile_01) and (inp_lineCount <= end_lineFile_01) then
         ATIO.Put_Line (out_fhandle_01, ASU.To_String (inp_UBlineStr)); 
         -- ATIO.Put_Line (ATIO.Standard_Output, ASU.To_String (inp_UBlineStr));
      end if;   
      
      if (inp_lineCount >= start_lineFile_02) and (inp_lineCount <= end_lineFile_02) then
         ATIO.Put_Line (out_fhandle_02, ASU.To_String (inp_UBlineStr)); 
         -- ATIO.Put_Line (ATIO.Standard_Output, ASU.To_String (inp_UBlineStr));
      end if; 
      
      if (inp_lineCount >= start_lineFile_03) and (inp_lineCount <= end_lineFile_03) then
         ATIO.Put_Line (out_fhandle_03, ASU.To_String (inp_UBlineStr)); 
         -- ATIO.Put_Line (ATIO.Standard_Output, ASU.To_String (inp_UBlineStr));
      end if; 
      
   end loop;
    
   ATIO.Close (out_fhandle_01);
   ATIO.Close (out_fhandle_02);
   ATIO.Close (out_fhandle_03);
   ATIO.Close (inp_fhandle);
   
   -- PROCESS EACH OF THE 3 FILES IN PARALLEL (TASKING)
   -- TO DO
   -- TO DO
   -- TO DO
   
   -- MERGE THE 3 FILES (APPEND)
   ATIO.Create (merged_fhandle, merged_fmode, merged_fname); 
   ATIO.Open (out_fhandle_01, ATIO.In_File, out_fname_01); 
   ATIO.Open (out_fhandle_02, ATIO.In_File, out_fname_02);
   ATIO.Open (out_fhandle_03, ATIO.In_File, out_fname_03);
   
   
   while not ATIO.End_Of_File (out_fhandle_01) loop
      inp_UBlineStr := ASU.To_Unbounded_String(ATIO.Get_Line (out_fhandle_01));
      ATIO.Put_Line (merged_fhandle, ASU.To_String (inp_UBlineStr)); 
   end loop;
   
   while not ATIO.End_Of_File (out_fhandle_02) loop
      inp_UBlineStr := ASU.To_Unbounded_String(ATIO.Get_Line (out_fhandle_02));
      ATIO.Put_Line (merged_fhandle, ASU.To_String (inp_UBlineStr)); 
   end loop;
   
   while not ATIO.End_Of_File (out_fhandle_03) loop
      inp_UBlineStr := ASU.To_Unbounded_String(ATIO.Get_Line (out_fhandle_03));
      ATIO.Put_Line (merged_fhandle, ASU.To_String (inp_UBlineStr)); 
   end loop;
   
   ATIO.Close (out_fhandle_01);
   ATIO.Close (out_fhandle_02);
   ATIO.Close (out_fhandle_03);
   ATIO.Close (merged_fhandle);
      
   -- CODE ENDS HERE
   -- =====================================================
   
   ATIO.New_Line; PADTS.dtstamp;
   ATIO.Put_line ("ENDED: main Alhamdulillah 3 times WRY. ");
   finishClock := ART.Clock;
   PADTS.dtstamp; ATIO.Put ("Current main() Total ");
   PARTD.exec_display_execution_time(startClock, finishClock); 
-- ========================================================   
end main_ada_file_split_process_merge;
-- ========================================================
