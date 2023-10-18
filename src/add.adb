
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

    -----------------------------------------------------------------------
    ------------- declaration of tasks 
    -----------------------------------------------------------------------

    -- Aqui se declaran las tareas que forman el STR


    -----------------------------------------------------------------------
    ------------- body of tasks 
    -----------------------------------------------------------------------

    -- Aqui se escriben los cuerpos de las tareas 
    task body send_distance_signal is
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

	security_dist := Distance_Samples_Type((speed/10) ** 2);
	
	Display_Distance (dist);
	Display_Speed (speed);

	if dist < (security_dist/3) then
	    Starting_Notice ("PELIGRO COLISION");
	    Light(On);
	elsif dist < (security_dist/2) then
	    Starting_Notice ("DISTANCIA IMPRUDENTE");
	    Light(Off);
	elsif dist < security_dist then
	    Starting_Notice ("DISTANCIA INSEGURA");
	    Light(Off);
	end if;

 	delay until next_delay;
	Starting_Notice("Acaba distacia de seguridad");
     end loop;
    end send_distance_signal;

    ----------------------------------------------------------------------
    ------------- procedure para probar los dispositivos 
    ----------------------------------------------------------------------
    procedure Prueba_Dispositivos; 

    Procedure Prueba_Dispositivos is
        Current_V: Speed_Samples_Type := 0;
        Current_H: HeadPosition_Samples_Type := (+2,-2);
        Current_D: Distance_Samples_Type := 0;
        Current_O: Eyes_Samples_Type := (70,70);
        Current_E: EEG_Samples_Type := (1,1,1,1,1,1,1,1,1,1);
        Current_S: Steering_Samples_Type := 0;
    begin
         Starting_Notice ("Prueba_Dispositivo");

         for I in 1..120 loop
         -- Prueba distancia
            --Reading_Distance (Current_D);
            --Display_Distance (Current_D);
            --if (Current_D < 40) then Light (On); 
            --                    else Light (Off); end if;

         -- Prueba velocidad
            --Reading_Speed (Current_V);
            --Display_Speed (Current_V);
            --if (Current_V > 110) then Beep (2); end if;

         -- Prueba volante
            Reading_Steering (Current_S);
            Display_Steering (Current_S);
            if (Current_S > 30) OR (Current_S < -30) then Light (On);
                                                     else Light (Off); end if;

         -- Prueba Posicion de la cabeza
            --Reading_HeadPosition (Current_H);
            --Display_HeadPosition_Sample (Current_H);
            --if (Current_H(x) > 30) then Beep (4); end if;

         -- Prueba ojos
            --Reading_EyesImage (Current_O);
            --Display_Eyes_Sample (Current_O);

         -- Prueba electroencefalograma
            --Reading_Sensors (Current_E);
            --Display_Electrodes_Sample (Current_E);
   
         delay until (Clock + To_time_Span(0.1));
         end loop;

         Finishing_Notice ("Prueba_Dispositivo");
    end Prueba_Dispositivos;


begin
  Starting_Notice ("Programa Principal");
end add;



