-- File	 : pkg_ada_file_line_properties.adb
-- Date	 : Tue 09 Mar 2021 09:18:35 AM +08
-- Author: WRY wruslandr@gmail.com
-- ========================================================

-- ADA STANDARD PACKAGES
with Ada.Text_IO;
with Ada.Strings.Unbounded;
use  Ada.Strings.Unbounded;  -- For ASU.Null_Unbounded_String
with Ada.Strings.Fixed;      -- For ASF.Index_Non_Blank
with Ada.Directories;  

-- AVOID LOCAL PACKAGES
-- with pkg_ada_file_open_close;

-- USER CREATED PACKAGES 

-- ========================================================
package body pkg_ada_file_line_properties 
-- ========================================================
--   with SPARK_Mode => on
is
   package ATIO   renames Ada.Text_IO;
   package ASU    renames Ada.Strings.Unbounded;
   package ASF    renames Ada.Strings.Fixed;
   package AD     renames Ada.Directories; 
   
   -- package PAFOC  renames pkg_ada_file_open_close;
   
   -- =======================================================
   -- TEMPLATE FOR GENERIC FILE VARIABLES
   -- =======================================================
   
   -- NEW FILEHANDLE POSSIBLE WITH FILE SHARING
   inp_fhandle_PAFLP  : ATIO.File_Type;   
   inp_UBSlineStr     : ASU.Unbounded_String;
   
   -- COUNTING LENGTH OF STRINGS
   max_UBSlineLength  : Integer := 999;
   min_UBSlineLength  : Integer := 999;
   cur_UBSlineLength  : Integer := 999;   
   
   -- COUNTING LINES
   cnt_lineTotal      : Integer := 999;
   cnt_lineNull       : integer := 999;
   cnt_lineNotNull    : Integer := 999;
   
   int_FirstIndexInString : Integer := 999; -- First index for non-blank in string
   cnt_lineBlank_BUT_WhiteSpace   : Integer := 999;  -- With white spaces
   cnt_lineBlank_NO_WhiteSpace    : Integer := 999;  -- Truly "Null" line
   cnt_lineNonBlank_NonWhiteSpace : Integer := 999;  -- the effective line
   
   -- IMPORTANT: ABOUT SEEING BLANK LINES BUT NOT TRULY BLANK
   -- Examples 
   -- myString1 : String := "   Wruslan Wyusoff";
   -- Then int_FirstIndexInString = 4, meaning with leading 3 white spaces.
   --
   -- myString2 : String := "    ";
   -- Then int_FirstIndexInString = 5, meaning with 4 white spaces.
   --
   -- myString3 : String := ""; 
   -- Then int_FirstIndexInString = 0, meaning a Null string with 0 white spaces.
   
   -- =====================================================
   procedure exec_file_open (inp_fhandle : in out ATIO.File_Type; inp_fmode   : in ATIO.File_Mode; inp_fname   : in String; inp_fform   : in String;
                             inp_fOwnID  : in String )
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
   procedure exec_file_close (inp_fhandle : in out ATIO.File_Type; inp_fform   : in String; inp_fOwnID  : in String)
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
 
   -- =====================================================
   procedure exec_file_line_properties (inp_fmode    : in ATIO.File_Mode; inp_fname    : in String; inp_fform    : in String;
                             inp_fOwnID   : in String )
   -- =====================================================
   -- with SPARK_Mode => on
   is
      
   begin 
     
      -- ==================================================
      -- OPEN: Attempt to open file using PAFOC package
      -- ATIO.Put_Line("Running (2.1) ... exec_file_open (inp_fhandle_PAFLP, inp_fmode, " & inp_fname & ", " & inp_fform & ", " & inp_fOwnID & ")");
      exec_file_open (inp_fhandle_PAFLP, inp_fmode, inp_fname, inp_fform, inp_fOwnID); 
      -- ATIO.Put_Line("Completed (2.1) ... exec_file_open (inp_fhandle_PAFLP, inp_fmode, " & inp_fname & ", " & inp_fform & ", " & inp_fOwnID & ")");
      
      -- DEFINE PACKAGE-WIDE VARIABLES
      -- ==================================================
      cur_UBSlineLength    := -3;    -- Set to low  value for seeing changes 
      max_UBSlineLength    := -5;    -- Set to low  value for seeing changes
      min_UBSlineLength    := 999;   -- Set to high value for seeing changes
     
      cnt_lineTotal        := 0;
      cnt_lineNull         := 0;
      cnt_lineNotNull      := 0;
      
      int_FirstIndexInString := 0;
      cnt_lineBlank_BUT_WhiteSpace   := 0;
      cnt_lineBlank_NO_WhiteSpace    := 0;
      cnt_lineNonBlank_NonWhiteSpace := 0;
      
      -- ==================================================
      -- RUN THE READ FILE LOOP LINE BY LINE
      -- ==================================================
      while not ATIO.End_Of_File (inp_fhandle_PAFLP) loop
         
         -- MUST GET EACH LINE FOR LOOP TO WORK
         inp_UBSlineStr := ASU.To_Unbounded_String(ATIO.Get_Line (inp_fhandle_PAFLP));
         cnt_lineTotal := cnt_lineTotal + 1;
         
         -- ===============================================
         -- (1) COUNT NULL AND NON-NULL LINES
         if inp_UBSlineStr /= ASU.Null_Unbounded_String then
            cnt_lineNotNull := cnt_lineNotNull + 1; 
         else 
            cnt_lineNull := cnt_lineNull + 1;
         end if;
         
         -- ===============================================
         -- (2) GET CURRENT LINE LENGTH (UNBOUNDED LINE STRING)
         cur_UBSlineLength := ASU.Length (inp_UBSlineStr);
         
         -- GET MAX LINE LENGTH
         if cur_UBSlineLength >  max_UBSlineLength then 
            max_UBSlineLength := cur_UBSlineLength;
         end if;
         
         -- GET MIN LINE LENGTH
         if cur_UBSlineLength <= min_UBSlineLength then
            min_UBSlineLength := cur_UBSlineLength;
         end if;  
         
         -- ===============================================
         -- (3) GET INDEX NUMBER (INTEGER VALUE) FOR FIRST CHARACTER IN STRING        
         int_FirstIndexInString := ASF.Index_Non_Blank(ASU.To_String(inp_UBSlineStr));
         
         -- SEEN AS BLANK LINE BUT WITH WHITE SPACES SO LINE LENGTH IS NOT ZERO. 
         -- TECHNICALLY NOT A "Null" LINE.   
         if (cur_UBSlineLength /= 0) and (int_FirstIndexInString = 0) then
            cnt_lineBlank_BUT_WhiteSpace := cnt_lineBlank_BUT_WhiteSpace + 1;
         end if;
                  
         if (cur_UBSlineLength = 0) and (int_FirstIndexInString = 0) then
            cnt_lineBlank_NO_WhiteSpace := cnt_lineBlank_NO_WhiteSpace + 1;
         end if;
         
         -- ===============================================
         -- (4) EFFECTICE USABLE LINES
         if (cur_UBSlineLength /= 0) and (int_FirstIndexInString /= 0) then
            cnt_lineNonBlank_NonWhiteSpace := cnt_lineNonBlank_NonWhiteSpace + 1; 
         end if;   
         
         -- ===============================================    
         -- NOTE: GET FIRST CHARACTER OF LINE STRING (USING SLICE)
         -- ===============================================
         -- CONSIDER: The slice of a long string (like a line)     
         -- 
         -- firstChar := ASU.To_String (ASU.Unbounded_Slice(UBSlineStr, 1, 1));
         --
         -- Define a valid Null string to compare against firstChar as
         --
         --     myNullString : String = "";
         --
         -- The firstChar in the string (using the slice) cannot be used to 
         -- compare against the Null string because as soon the system reads 
         -- a Null string from file, it raises ADA.STRINGS.INDEX_ERROR : 
         -- a-strunb.adb:2027, that is, stops program execution.
         
         -- This happens before having a chance to compare against myNullString.
         -- Ha ha ha. We got around it correctly using Item (3) above:
         --
         --   "cur_UBSlineLength", "int_FirstIndexInString",
         --   "ASF.Index_Non_Blank" and "ASU.Null_Unbounded_String"
         -- 
         -- A white space is counted, so has a length. The first index for 
         -- white space is also counted, so has non-zero location.
         -- 
         --  The combination of linelength = 0 and firstindex = 0
         --  is the identification for a Null string.
         --  
         --  LINELENGTH:  3 FIRSTINDEX:  0   ==> Blank line with 3 white spaces 
         --  LINELENGTH:  0 FIRSTINDEX:  0   ==> True blank line (Null string)
         --
         -- ===============================================
         -- YOU CAN SEE BY THE DEGUGGING SECTION BELOW:
         -- ===============================================
         -- FOR DEBUGGING UNCOMMENT THE STATEMENTS BELOW (VISUAL INSPECTION)
         -- ATIO.Put ("LINENO: " & Integer'Image (cnt_lineTotal) & " ");
         -- if inp_UBSlineStr /= ASU.Null_Unbounded_String then
         --   ATIO.Put ("NotNull  ");
         -- else 
         --   ATIO.Put ("Null <== ");
         -- end if;  
         -- ATIO.Put ("LINELENGTH: " & Integer'Image (cur_UBSlineLength) & " ");
         -- ATIO.Put ("FIRSTINDEX: " & Natural'Image (int_FirstIndexInString) & " ");
         -- ATIO.Put_Line ("LINESTRING: " & ASU.To_String (inp_UBSlineStr) );
         -- END DEBUGGING 
       
      -- ==================================================
      end loop;  
      -- ==================================================
      ATIO.New_Line;
      ATIO.Put_Line ("REPORT ON FILE LINE PROPERTIES");
      ATIO.Put_Line ("   Line properties of file        = " & AD.Full_Name (inp_fname));
      ATIO.Put_Line ("      max_UBSLineLength           = " & Integer'Image(max_UBSLineLength));
      ATIO.Put_Line ("      min_UBSlineLength           = " & Integer'Image(min_UBSlineLength));
      ATIO.Put_Line ("   cnt_lineNull                   = " & Integer'Image(cnt_lineNull) & " (True Null string blank lines)" ); 
      ATIO.Put_Line ("   cnt_lineNotNull                = " & Integer'Image(cnt_lineNotNull) & " (Includes blank lines with all white spaces) "); 
       
      ATIO.Put_Line ("   cnt_lineBlank_BUT_WhiteSpace   = " & Integer'Image(cnt_lineBlank_BUT_WhiteSpace) & " (Blank lines with all white spaces) "); 
      ATIO.Put_Line ("   cnt_lineBlank_NO_WhiteSpace    = " & Integer'Image(cnt_lineBlank_NO_WhiteSpace) & " (Blank lines with no white spaces) "); 
      ATIO.Put_Line ("   cnt_lineNonBlank_NonWhiteSpace = " & Integer'Image(cnt_lineNonBlank_NonWhiteSpace) & " (Effective usable lines)"); 
      ATIO.Put_Line ("   Overall File cnt_lineTotal     = " & Integer'Image(cnt_lineTotal));
      ATIO.New_Line;
      
      -- ==================================================    
      -- -- CLOSE: Attempt to open file using PAFOC package
      -- ATIO.Put_Line("Running (2.2) ... exec_file_close (inp_fhandle_PAFLP, " & inp_fform & ", " & inp_fOwnID & ")");
      exec_file_close (inp_fhandle_PAFLP, inp_fform, inp_fOwnID);
      -- ATIO.Put_Line("Completed (2.2) ... exec_file_close (inp_fhandle_PAFLP, " & inp_fform & ", " & inp_fOwnID & ")");
      
   end exec_file_line_properties;
   
   -- =====================================================
   procedure display_help_file is 
   -- =====================================================
      inp_fhandle : ATIO.File_Type; 
      inp_fmode   : ATIO.File_Mode := ATIO.In_File;
      inp_fname   : String := "src/pkg-ada-file-line-properties/pkg_ada_file_line_properties.hlp";
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
end pkg_ada_file_line_properties;
-- ========================================================    
