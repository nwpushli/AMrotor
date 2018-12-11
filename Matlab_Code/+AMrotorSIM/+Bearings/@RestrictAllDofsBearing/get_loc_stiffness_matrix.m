function [K] = get_loc_stiffness_matrix(self,varargin)
            
    K=sparse(6,6);
    
    % dof-order: ux,uy,uz,psix,psiy,psiz
    for i = 1:6
    K(i,i)=self.cnfg.stiffness;
    end
            
    self.stiffness_matrix = K;
end