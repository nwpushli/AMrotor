function [M,C,G,K]= assemble_system_matrices(self,rpm,varargin)

         if nargin == 1
             rpm=0;
         elseif nargin==3
             Z=varargin{1};
         end

%% Rotormatrizen aus FEM erstellen
           
            n_nodes=length(self.rotor.mesh.nodes);

            %Lokalisierungsmatrix hat 6x6n 0 Eintr�ge
            %Element L wird dann an der Stelle (i-1)*6 drauf addiert.

%% Add bearing matrices

            M_bearing=sparse(6*n_nodes,6*n_nodes);
            K_bearing=sparse(6*n_nodes,6*n_nodes);
            G_bearing=sparse(6*n_nodes,6*n_nodes);
            C_bearing=sparse(6*n_nodes,6*n_nodes);
            
            
            for bearing = self.bearings
                
                bearing.create_ele_loc_matrix;
                bearing.get_loc_gyroscopic_matrix(rpm);
                bearing.get_loc_damping_matrix(rpm);
                bearing.get_loc_mass_matrix(rpm);
                bearing.get_loc_stiffness_matrix(rpm);
                
                bearing_node = self.rotor.find_node_nr(bearing.position);
                L_ele = sparse(6,6*n_nodes);
                L_ele(1:6,(bearing_node-1)*6+1:(bearing_node-1)*6+6)=bearing.localisation_matrix;

                M_bearing = M_bearing+L_ele'*bearing.mass_matrix*L_ele;
                K_bearing = K_bearing+L_ele'*bearing.stiffness_matrix*L_ele;
                C_bearing = C_bearing+L_ele'*bearing.damping_matrix*L_ele;
                G_bearing = G_bearing+L_ele'*bearing.gyroscopic_matrix*L_ele;
            end

%% Add disc matrices

            M_disc=sparse(6*n_nodes,6*n_nodes);
            K_disc=sparse(6*n_nodes,6*n_nodes);
            G_disc=sparse(6*n_nodes,6*n_nodes);
            
            
            for disc = self.discs
                
                disc.create_ele_loc_matrix;
                disc.get_loc_gyroscopic_matrix;
                disc.get_loc_mass_matrix;
                disc.get_loc_stiffness_matrix;
                
                disc_node = self.rotor.find_node_nr(disc.position);
                L_ele = sparse(6,6*n_nodes);
                L_ele(1:6,(disc_node-1)*6+1:(disc_node-1)*6+6)=disc.localisation_matrix;

                M_disc = M_disc+L_ele'*disc.mass_matrix*L_ele;
                K_disc = K_disc+L_ele'*disc.stiffness_matrix*L_ele;
                G_disc = G_disc+L_ele'*disc.gyroscopic_matrix*L_ele;
            end
            
%% Add seal matrices

            M_seal=sparse(6*n_nodes,6*n_nodes);
            K_seal=sparse(6*n_nodes,6*n_nodes);
            D_seal=sparse(6*n_nodes,6*n_nodes);
                 
            for seal = self.seals 
                seal.create_ele_loc_matrix;
                seal.get_loc_system_matrices(rpm);

                seal_node = self.rotor.find_node_nr(seal.position);
                L_ele = sparse(6,6*n_nodes);
                L_ele(1:6,(seal_node-1)*6+1:(seal_node-1)*6+6)=seal.localisation_matrix;

                M_seal = M_seal+L_ele'*seal.mass_matrix*L_ele;
                K_seal = K_seal+L_ele'*seal.stiffness_matrix*L_ele;
                D_seal = D_seal+L_ele'*seal.damping_matrix*L_ele;        
            end
            
%% Add LookUpTable-component matrices

            M_CompLUTMCK =sparse(6*n_nodes,6*n_nodes);
            K_CompLUTMCK =sparse(6*n_nodes,6*n_nodes);
            D_CompLUTMCK =sparse(6*n_nodes,6*n_nodes);
                 
            for ComponentLookUpTableMCK = self.compLUTMCK 
                ComponentLookUpTableMCK.create_ele_loc_matrix;
                ComponentLookUpTableMCK.get_loc_system_matrices(rpm);

                component_node = self.rotor.find_node_nr(ComponentLookUpTableMCK.position);
                L_ele = sparse(6,6*n_nodes);
                L_ele(1:6,(component_node-1)*6+1:(component_node-1)*6+6)=ComponentLookUpTableMCK.localisation_matrix;

                M_CompLUTMCK  = M_CompLUTMCK +L_ele'*ComponentLookUpTableMCK.mass_matrix*L_ele;
                K_CompLUTMCK  = K_CompLUTMCK +L_ele'*ComponentLookUpTableMCK.stiffness_matrix*L_ele;
                D_CompLUTMCK  = D_CompLUTMCK +L_ele'*ComponentLookUpTableMCK.damping_matrix*L_ele;        
            end            
        
%% Add to global matrices
        M = self.rotor.matrices.M + M_bearing + M_disc + M_seal + M_CompLUTMCK ;
        C = self.rotor.matrices.D + C_bearing + D_seal + D_CompLUTMCK ;
        G = self.rotor.matrices.G + G_bearing + G_disc;
        K = self.rotor.matrices.K + K_bearing + K_disc + K_seal + K_CompLUTMCK ;

        
      
end