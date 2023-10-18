with Devices; use Devices;
with Tools; use Tools;
with System; use System;

package add is
  task send_distance_signal is 
    pragma Priority (System.Priority'First + 1);
  end send_distance_signal;
  procedure Background;
end add;
