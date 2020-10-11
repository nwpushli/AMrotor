% Licensed under GPL-3.0-or-later, check attached LICENSE file

function [D] = get_loc_damping_matrix(self,varargin)
% Provides/builds local damping matrix of the component in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :param varargin: Placeholder
%    :return: Damping component matrix D
    
     D = sparse(6,6);
    
    D(3,3)=self.cnfg.damping;
 
    self.damping_matrix = D;
end