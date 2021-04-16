-- File	: pkg_ada_file_read_write.adb
-- Date	: Tue 23 Feb 2021 04:39:09 PM +08
-- Env	: Linux HPEliteBook8470p-Ub2004-rt38 5.4.66-rt38 
-- #1 SMP PREEMPT_RT Sat Sep 26 16:51:59 +08 2020 x86_64 x86_64 x86_64 GNU/Linux
-- Author: WRY wruslandr@gmail.com
-- ========================================================

-- ADA STANDARD PACKAGES
with Ada.Text_IO;
with Ada.Numerics;

-- ADA STRING MANIPULATION
-- Ada has three(3) types of strings: fixed length, bounded length, unbounded.
with Ada.Strings;
with Ada.Strings.Fixed;
with Ada.Strings.Bounded;
with Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO;
with Ada.Command_Line;


-- WRY CREATED PACKAGES 
-- with pkg_ada_datetime_stamp;

-- ========================================================
package body pkg_ada_file_read_write 
-- ========================================================
--   with SPARK_Mode => on
is

   package ATIO renames Ada.Text_IO;
   package ASU  renames Ada.Strings.Unbounded;
   
   
   -- =======================================================
   -- TEMPLATE FOR GENERIC FILE VARIABLES
   -- =======================================================
   inp_fhandle : ATIO.File_type;
   out_fhandle : ATIO.File_type;
   
   inp_UBlineStr : ASU.Unbounded_String;
   len_UBlineStr : Natural := 999;
   inp_lineCount : Integer := 999; 
   inp_lineStr   : String  := ASU.To_String(inp_UBlineStr);
   
   -- ==================================================== 
   procedure exec_file_read_write (inp_fmode : in ATIO.File_Mode; inp_fname : in String;
                                   out_fmode : in ATIO.File_Mode; out_fname : in String)
   -- =====================================================   
   -- with SPARK_Mode => on 
   is
      
   begin
      ATIO.Put_Line("Run exec_read_write_file (inp_fmode, inp_fname, out_fmode, out_fname)");
      ATIO.Put_Line("inp_fmode = ATIO.In_File ");
      ATIO.Put_Line("inp_fname = " & (inp_fname));
      ATIO.Put_Line("out_fmode = ATIO.Out_File ");
      ATIO.Put_Line("out_fname = " & (out_fname));
      
      ATIO.Put_Line("ToOpen   inp_fname = " & inp_fname);
      ATIO.Open (inp_fhandle, inp_fmode, inp_fname); 
      ATIO.Put_Line("Opened   inp_fname = " & inp_fname & " successfully.");
      
      ATIO.Put_Line("ToCreate out_fname = " & out_fname);
      ATIO.Create (out_fhandle, out_fmode, out_fname); 
      ATIO.Put_Line("Created  out_fname = " & out_fname & " successfully.");
      
      ATIO.New_Line;
      inp_lineCount := 0;
      
      -- Traverse file line by line 
      while not ATIO.End_Of_File (inp_fhandle) loop
         
         -- From file read (get) single line
         inp_UBlineStr := ASU.To_Unbounded_String(ATIO.Get_Line (inp_fhandle));
         
         -- STRIP white spaces at beginning and at end of line,
         -- then compute line length (string length)
         
         len_UBlineStr := ASU.Length (inp_UBlineStr);
         inp_lineCount := inp_lineCount + 1;
         
         --DISPLAY read line to terminal (if required)
         -- ==========================================
         -- ATIO.Put (ATIO.Standard_Output, "LINE_NO " & Integer'Image(inp_lineCount) & " : "); 
         ATIO.Put_Line (ATIO.Standard_Output, ASU.To_String (inp_UBlineStr)); 
         
         -- Write read line to output file
         -- ==========================================
         if len_UBlineStr =  0 then
            -- DISABLE LINE NUMBERS
            ATIO.Put (out_fhandle, "(BLANK LINENO): " & Integer'Image(inp_lineCount)); 
            -- ALSO WRITE BLANK LINES
            ATIO.Put_Line (out_fhandle, ASU.To_String (inp_UBlineStr)); 
         else
             -- WRITE NON BLANK LINES
             ATIO.Put_Line (out_fhandle, ASU.To_String (inp_UBlineStr));
         end if;   
         
      end loop;   
            
      ATIO.Close(inp_fhandle);
      ATIO.Close(out_fhandle);
      
   end exec_file_read_write;
   
     -- =====================================================
   procedure display_help_file is 
   -- =====================================================
      inp_fhandle : ATIO.File_Type; 
      inp_fmode   : ATIO.File_Mode := ATIO.In_File;
      inp_fname   : String := "src/pkg-ada-file-read-write/pkg_ada_file_read_write.hlp";
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
begin
  null;
-- ========================================================
end pkg_ada_file_read_write;
-- ========================================================    
   
  
     
