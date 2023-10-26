
with Kernel.Serial_Output; use Kernel.Serial_Output;
with Ada.Real_Time; use Ada.Real_Time;
with System; use System;

with Tools; use Tools;
with Devices; use Devices;

-- Packages needed to generate pulse interrupts       
-- with Ada.Interrupts.Names;
-- with Pulse_Interrupt; use Pulse_Interrupt;

package body add is

    ----------------------------------------------------------------------
    ------------- procedure exported 
    ----------------------------------------------------------------------
    procedure Background is
    begin
      loop
        null;
      end loop;
    end Background;
    ----------------------------------------------------------------------

    ----------------------------------------------------------------------
    ----------------------- Protected Objects ----------------------------
    ----------------------------------------------------------------------
    
    Protected body Measures is
      function Calculate_Security_Distance return Distance_Samples_Type is
      begin
         return Distance_Samples_Type((speed/10) ** 2);
      end Calculate_Security_Distance;
      function Get_Distance return Distance_Samples_Type is
      begin 
         return distance;
      end Get_Distance;
      function Get_Speed return Speed_Samples_Type is
      begin
         return speed;
      end Get_Speed;
      procedure Set_Distance(dist: in Distance_Samples_Type) is
      begin
         distance := dist;
      end Set_Distance;
      procedure Set_Speed(spd: in Speed_Samples_Type) is
      begin
         speed := spd;
      end Set_Speed;
    end Measures;
    
    Protected body Sign is
    
       function Get_Cabeza return HeadPosition_Samples_Type is
       begin
          return cabeza;
       end Get_Cabeza;
    
       procedure Set_Cabeza(cab: in HeadPosition_Samples_Type) is
       begin
          cabeza:= cab;
       end Set_Cabeza;
    
       procedure Aviso_Cabeza(cab: in HeadPosition_Samples_Type; cont: in out Integer) is
          v: devices.Volume;
          begin
          if cab(x)>=30 or cab(x)<= -30 then
             cont:= cont + 1;
             if cont>= 2 then
                v:= 5;
                Put_Line("CABEZA INCLINADA");
                Beep(v);
             end if;
          else
             cont:= 0;
          end if;
       end Aviso_Cabeza; 
       
       procedure Set_Position(i: in Integer)is
       begin
          pos:= i;
       end Set_Position;
       
       function Get_Position return Integer is
       begin
          return pos;
       end Get_Position;
       
       procedure Calculate_Dangerous_Distance(dist: in Distance_Samples_Type;       security_dist: in Distance_Samples_Type) is
      begin
         for i in 1..3 loop
            if dist < (security_dist/Distance_Samples_Type(i)) then
                Set_Position(i);
            end if;
         end loop;
      end Calculate_Dangerous_Distance;
      
      procedure take_Alarm is
      begin
         if pos = 3 then
	    Put_Line("PELIGRO COLISION");
	 elsif pos = 2 then
	    Put_Line("DISTANCIA IMPRUDENTE");
	 elsif pos = 1 then
	    Put_Line("DISTANCIA INSEGURA");
	 else
	    Put_Line("SEGURO ");
	 end if;
      end take_Alarm;
      function Turn_Light return Light_States is
      begin
         if pos = 3 then
            return On;
         end if;
         return Off;
      end Turn_Light;
   end Sign;    
       
    
    -----------------------------------------------------------------------
    ------------- declaration of tasks 
    -----------------------------------------------------------------------

    -- Aqui se declaran las tareas que forman el STR
    --Type Volume is new integer range 1..5;

    task body Head_Security is
    cab: HeadPosition_Samples_Type;
    next_delay: Time;
    begin
	loop
	next_delay:= Clock + Milliseconds(400);
	Reading_HeadPosition(cab);
	Sign.Set_Cabeza(cab);

	delay until next_delay;
        end loop;
    end Head_Security;
    
    task body Display is
    cont: Integer:= 0;
    begin 
       loop
       Display_HeadPosition_Sample(Sign.Get_Cabeza);
       Sign.Aviso_Cabeza(Sign.Get_Cabeza, cont);
       Display_Distance (Measures.Get_Distance);
       Display_Speed (Measures.Get_Speed);
       Put_Line("");
       Sign.take_Alarm;  
       end loop;
    end Display;

    task body Distance is
      speed: Speed_Samples_Type;
      dist:  Distance_Samples_Type;
      security_dist: Distance_Samples_Type;
      next_delay: Time;
   begin
      loop	    
         next_delay := Clock + milliseconds(300);
         
         Starting_Notice("Inicia distancia de seguridad");
         Reading_Speed (speed);
         Reading_Distance (dist);
         Measures.Set_Distance(dist);
         Measures.Set_Speed(speed);
	 security_dist := Measures.Calculate_security_distance;
         Sign.Calculate_Dangerous_Distance(dist,security_dist);
         delay until next_delay;
         Starting_Notice("Acaba distacia de seguridad");
      end loop;
   end Distance;


begin
   Starting_Notice ("Programa Principal");
 
   Finishing_Notice ("Programa Principal");
end add;



