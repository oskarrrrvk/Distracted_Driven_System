with Devices; use Devices;
with Tools; use Tools;
with System; use System;

-- Packages needed to generate pulse interrupts       
--with Ada.Interrupts.Names;
--with Pulse_Interrupt; use Pulse_Interrupt;


package add is
  -----------------------
  ---Protected Objects---
  -----------------------
  
  
  protected Sign is 
     pragma Priority(System.Priority'First + 5);
     procedure Aviso_Cabeza(cab: in HeadPosition_Samples_Type; cont: in out Integer);
     procedure Calculate_Dangerous_Distance(dist: in Distance_Samples_Type; security_dist: in Distance_Samples_Type);
     procedure take_Alarm;
     procedure Set_Position(i: in integer);
     function  Get_Position return Integer; 
     procedure Giro_Brusco(whlB: in Steering_Samples_Type; whlA: in Steering_Samples_Type);
     function Get_Rude return Boolean;
     function Get_Head_Warning return Boolean;
  private 
     pos: Integer;
     rude: Boolean;
     head_warning: Boolean;
  end Sign;


   protected Measures is
      pragma Priority(System.Priority'First + 5);
      function  Get_Distance return Distance_Samples_Type;
      function  Get_Speed return Speed_Samples_Type; 
      function  Get_Cabeza return HeadPosition_Samples_Type;
      function  Get_Volante return Steering_Samples_Type;
      procedure Set_Distance(dist: in Distance_Samples_Type);
      procedure Set_Speed(spd: in Speed_Samples_Type);
      procedure Set_Cabeza(cab: in HeadPosition_Samples_Type);
      procedure Set_Volante(vol: in Steering_Samples_Type);
      function  Calculate_Security_Distance return Distance_Samples_Type;
   private
      distance: Distance_Samples_Type;
      speed   : Speed_Samples_Type; 
      cabeza: HeadPosition_Samples_Type;
      wheel: Steering_Samples_Type;
   end Measures;
   
   
  -- protected Interrupt_Handler is
  --    pragma Priority Interrupt_Priority'First+1;
  --    procedure Interrupt_Rutine;
  --    pragma Attach_Handler(Interrupt_Rutine,Ada.Interrupts.Names.Name_Id);
  -- end Interrupt_Handler;
   
  procedure Background;
  
  ----------------------------------------
  -----------------Tasks------------------
  ----------------------------------------

  task Distance is
      pragma Priority (System.Priority'First + 3);
  end Distance;

  task Display is
      pragma Priority (System.Priority'First + 1);
  end Display;

  task Head_Security is 
      pragma Priority(System.Priority'First + 5);
  end Head_Security;
  
  task Volante_Steering is
      pragma Priority(System.Priority'First + 2);
   end Volante_Steering;
   
   task Risk is
      pragma Priority(System.Priority'First + 4);
   end Risk;
   
end add;
