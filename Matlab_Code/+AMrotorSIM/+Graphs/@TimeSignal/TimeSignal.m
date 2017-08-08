classdef TimeSignal < handle
   properties
    unit
    rotorsystem
    name=' ---  Zeitsignale  --- '
    time
   end
  methods
  function self=TimeSignal(a, experiment) 
      self.rotorsystem = a;
      self.time = experiment.time;
  end
  
  function plot(self,sensors)
      disp(self.name)
      
          for sensor = sensors

            [x_val,beta_pos,y_val,alpha_pos]=sensor.read_sensor_values(self.rotorsystem);

              
            figure('name',[sensor.name, ' at position ',num2str(sensor.Position), '; Timesignal'], 'NumberTitle', 'off');;
            subplot(2,1,1);
            plot( self.time,x_val);
            xlabel('time [s]');
            ylabel(sensor.unit);
            title([sensor.measurementType, ' in x']);
            subplot(2,1,2);
            plot(self.time, y_val);
            xlabel('time [s]');
            ylabel(sensor.unit);
            title([sensor.measurementType, ' in y']);

          end
      end
      
   end
      
end