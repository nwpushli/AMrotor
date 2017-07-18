classdef Waterfalldiagramm < handle
   properties
    unit
    rotorsystem
    name=' ---  Wasserfalldiagramm-darstellung  --- '
    abtastrate
    drehzahl
    timeresults
   end
  methods
  function self=Waterfalldiagramm(a, time, drehzahl, mapobj)  
      self.rotorsystem = a;
      self.abtastrate = 1/(time(2)-time(1));
      self.drehzahl = drehzahl;
      self.timeresults = mapobj;
  end
  
  function plot(self,sensors)
      disp(self.name)
             j = 1;
             F_x={}; Y_x={}; AMPL_x={};
             F_y={}; Y_y={}; AMPL_y={};
             Drehzahl = {}; DZ = [];
      
       for sensor = sensors
                      
          for drehzahl = self.drehzahl
            timeresults = self.timeresults(drehzahl);
            self.rotorsystem.time_result.X = timeresults{1,1};
            self.rotorsystem.time_result.X_d = timeresults{1,2};
            self.rotorsystem.time_result.X_dd= timeresults{1,3};
            
            [x_val,beta_pos,y_val,alpha_pos]=sensor.read_sensor_values(self.rotorsystem);
            fs = self.abtastrate;
            value = {[x_val], [y_val]}; %%Hier ist was falsch, Immer nur die gleichen Werte werden �bergeben

                    
                    
                    [f_x,y_x,ampl_x] = FFT_Data_Gesamt (x_val,fs);                    
                    F_x{j,1}= f_x;
                    Y_x{j,1}= y_x;
                    AMPL_x{j,1}= ampl_x;
                    
                    [f_y,y_y,ampl_y] = FFT_Data_Gesamt (y_val,fs);                    
                    F_y{j,1}= f_y;
                    Y_y{j,1}= y_y;
                    AMPL_y{j,1}= ampl_y;
                    
                    DZ(1,1:size(f_y,2))=self.drehzahl(j);
                    
                    Drehzahl{j,1}= DZ;
                    j = j+1;
          end 
          % Umformatierung
         F_x= cell2mat(F_x);
         Y_x= cell2mat(Y_x);
         AMPL_x= cell2mat(AMPL_x);               
                
         F_y= cell2mat(F_y);
         Y_y= cell2mat(Y_y);
         AMPL_y = cell2mat(AMPL_y);
         Drehzahl = cell2mat(Drehzahl);
        % Plot        
         figure('name',[sensor.name, ' at position ',num2str(sensor.Position), '; Waterfall'], 'NumberTitle', 'off');  
         subplot(2,1,1)
         mesh(Drehzahl,F_x,AMPL_x)
         xlabel('Drehzahl [U/min]')
         ylabel('Frequenz [Hz]')
         zlabel('Amplitude')
         title ('Waterfalldiagramm of x-values')
         subplot (2,1,2)
         mesh(Drehzahl,F_y,AMPL_y)
         xlabel('Drehzahl [U/min]')
         ylabel('Frequenz [Hz]')
         zlabel('Amplitude')
         title ('Waterfalldiagramm of y-values')
 
       end
       
     end
      
   end
      
end



