classdef Modalanalyse < handle
   properties
      name='Modalanalyse'
      rotorsystem
      
      n_ew
      omega
      eigenmatrizen
   end
   methods
       %Konstruktor
       function obj = Modalanalyse(a)
         if nargin == 0
           disp('Keine Modalanalyse m�glich ohne Rotorsystem')
         else
           obj.rotorsystem = a;
         end
       end
      
      function show(obj)
         disp(obj.name);
      end

      function calculate_rotor_only(obj,n_modes,drehzahl)
      
          disp('Berechne Modalanalyse Rotor')
          
          obj.n_ew = n_modes;
          obj.omega=drehzahl/60*2*pi;
           n_nodes=length(obj.rotorsystem.rotor.nodes);
          
          K=obj.rotorsystem.rotor.matrizen.K;
          G=obj.rotorsystem.rotor.matrizen.G;
          M=obj.rotorsystem.rotor.matrizen.M;
          
          [obj.eigenmatrizen.Aev,obj.eigenmatrizen.Aew] = compute_EW_EV(obj.omega,obj.n_ew,K,G,M,n_nodes);
         %[obj.eigenmatrizen.Aev_x,obj.eigenmatrizen.Aev_y,obj.eigenmatrizen.Aev_alpha,obj.eigenmatrizen.Aev_beta,obj.eigenmatrizen.Aew,obj.eigenmatrizen.EVrot,obj.eigenmatrizen.EWrot] = compute_EW_EV(obj.omega,n_modes,K,G,M);
      end
 
      function calculate_rotorsystem(obj,n_modes,drehzahl)
      
          disp('Berechne Modalanalyse Rotorsystem')
          
          obj.n_ew = n_modes;
          obj.omega=drehzahl/60*2*pi;
          
          K=obj.rotorsystem.systemmatrizen.K;
          G=obj.rotorsystem.systemmatrizen.G;
          M=obj.rotorsystem.systemmatrizen.M;
          
          n_nodes=length(obj.rotorsystem.rotor.nodes);
          
          [obj.eigenmatrizen.Aev,obj.eigenmatrizen.Aew] = compute_EW_EV(obj.omega,obj.n_ew,K,G,M,n_nodes);

         %[obj.eigenmatrizen.Aev_x,obj.eigenmatrizen.Aev_y,obj.eigenmatrizen.Aev_alpha,obj.eigenmatrizen.Aev_beta,obj.eigenmatrizen.Aew,obj.eigenmatrizen.EVrot,obj.eigenmatrizen.EWrot] = compute_EW_EV(obj.omega,n_modes,K,G,M);
      
      end
      
      function calculate_rotorsystem_ss(obj,n_modes,drehzahl)
      
          disp('Berechne Modalanalyse Rotorsystem')
          
          obj.n_ew = n_modes;
          obj.omega=drehzahl/60*2*pi;
      
          nodes=obj.rotorsystem.rotor.nodes;
          n_nodes=length(nodes);
          
          
          for n1 = 1:length(obj.omega)

              ss=obj.rotorsystem.systemmatrizen.ss+obj.rotorsystem.systemmatrizen.ss_G*n1;

              ss_mech = ss(1:2*4*n_nodes,1:2*4*n_nodes);
              
             [V,D] = eigs(ss_mech,n_modes*4,'sm');

             obj.eigenmatrizen.V(:,:,n1) = V;
             obj.eigenmatrizen.D(:,:,n1) = D;
          end   
      end
      
   end
   methods(Access=private)
       
   end
end