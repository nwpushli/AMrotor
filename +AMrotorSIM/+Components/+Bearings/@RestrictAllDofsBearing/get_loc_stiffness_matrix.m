% Licensed under GPL-3.0-or-later, check attached LICENSE file

function [K] = get_loc_stiffness_matrix(self,varargin)
% Provides/builds local stiffness matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :param varargin: Placeholder
%    :return: Stiffness component matrix K
            
    K=sparse(6,6);
    
    for i = 1:6
    K(i,i)=self.cnfg.stiffness;
    end
            
    self.stiffness_matrix = K;
end