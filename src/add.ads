with Devices; use Devices;
with Tools; use Tools;
with System; use System;

package add is
  -----------------------
  --Protected Objects
  -----------------------
  
  protected Sign is 
     function Get_Cabeza return HeadPosition_Samples_Type;
     procedure Set_Cabeza(cab: in HeadPosition_Samples_Type);
     procedure Aviso_Cabeza(cab: in HeadPosition_Samples_Type; cont: in out Integer);
     procedure Calculate_Dangerous_Distance(dist: in Distance_Samples_Type; security_dist: in Distance_Samples_Type);
     procedure take_Alarm;
     function Turn_Light return Light_States;
     procedure Set_Position(i: in integer);
     function Get_Position return Integer; 
  --private atributtes
  private 
     cabeza: HeadPosition_Samples_Type;
     pos: Integer;
  end Sign;


  protected Measures is
      function  Get_Distance return Distance_Samples_Type;
      function  Get_Speed return Speed_Samples_Type; 
      procedure Set_Distance(dist: in Distance_Samples_Type);
      procedure Set_Speed(spd: in Speed_Samples_Type);
      function  Calculate_Security_Distance return Distance_Samples_Type;
   private
      distance: Distance_Samples_Type;
      speed   : Speed_Samples_Type; 
   end Measures;


  procedure Background;
  
  ----------------------------------------
  -----Tasks------------------------------
  ----------------------------------------

  task Distance is
      pragma Priority (System.Priority'First + 3);
  end Distance;

  task Display is
      pragma Priority (System.Priority'First + 1);
  end Display;

  task Head_Security is 
      pragma Priority(System.Priority'First + 2);
  end Head_Security;
end add;
