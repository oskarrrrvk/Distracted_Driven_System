with Devices; use Devices;
with Tools; use Tools;
with System; use System;

package add is
   ----------------------------------------------------------------------------
   ------------------------- Protected Objects --------------------------------
   ----------------------------------------------------------------------------
   
   protected Sign is
      procedure show_alarm    (index: in Integer);
      procedure turn_On_light (index: in Integer);
   private
      type Alarm is ("PELIGRO COLISION","DISTANCIA IMPRUDENTE","DISTANCIA INSEGURA") of String;
   end Sign;
   
   protected Measures is
      procedure show_Distance (distance: in Distance_Samples_Type);
      procedure show_Speed    (speed: in Speed_Samples_Type);
   end Measures;
   
   ----------------------------------------------------------------------------
   ------------------------------- Tasks --------------------------------------
   ----------------------------------------------------------------------------
   
   task Distance is
      pragma Priority (System.Priority'First + 1);
   end Distance;
   
   task Display is
      pragma Priority (System.Priority'First + 1);
   end Display;
   ----------------------------------------------------------------------------
   ---------------------------- Procedures ------------------------------------
   ----------------------------------------------------------------------------
   procedure Background;
end add;
