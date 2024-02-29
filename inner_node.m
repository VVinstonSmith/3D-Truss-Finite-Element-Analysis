function position = inner_node( ka,r,node1,node2,Ue_general )

point_num=8;
T=TT(ka,r);
Ue_local=T*Ue_general;
position=zeros(3,point_num+2);

L=norm(node1-node2);
for ii=1:point_num+2
    ksi=-1+(ii-1)*2./(point_num+1);
    N=[
  1/2 - ksi/2,           0,                         0,                                 0,                          0,                                  0, ksi/2 + 1/2,           0,                           0,                                 0,                           0,                                  0;
            0, 1/2 - ksi/2,                         0,                                 0,                          0,                                  0,           0, ksi/2 + 1/2,                           0,                                 0,                           0,                                  0;
            0,           0, ksi^3/4 - (3*ksi)/4 + 1/2,                                 0,                          0, -(L*(- ksi^3 + ksi^2 + ksi - 1))/8,           0,           0, - ksi^3/4 + (3*ksi)/4 + 1/2,                                 0,                           0, -(L*(- ksi^3 - ksi^2 + ksi + 1))/8;
            0,           0,                         0,         (3*ksi^2)/4 - ksi/2 - 1/4, -(2*((3*ksi^2)/4 - 3/4))/L,                                  0,           0,           0,                           0,         (3*ksi^2)/4 + ksi/2 - 1/4,   (2*((3*ksi^2)/4 - 3/4))/L,                                  0;
            0,           0,                         0, (L*(- ksi^3 + ksi^2 + ksi - 1))/8,  ksi^3/4 - (3*ksi)/4 + 1/2,                                  0,           0,           0,                           0, (L*(- ksi^3 - ksi^2 + ksi + 1))/8, - ksi^3/4 + (3*ksi)/4 + 1/2,                                  0;
            0,           0, (2*((3*ksi^2)/4 - 3/4))/L,                                 0,                          0,          (3*ksi^2)/4 - ksi/2 - 1/4,           0,           0,  -(2*((3*ksi^2)/4 - 3/4))/L,                                 0,                           0,          (3*ksi^2)/4 + ksi/2 - 1/4];
 
    Ue_inner_local=N*Ue_local;
    Ue_inner_general=T(1:6,1:6)'*Ue_inner_local;
    
    position(:,ii)=node1+(node2-node1)*(ii-1)./(point_num+1)+...
    [Ue_inner_general(1);Ue_inner_general(3);Ue_inner_general(5)];

end   

end

