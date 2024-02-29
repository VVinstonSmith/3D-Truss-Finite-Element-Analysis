 beam_num=rod_num;
%%
%K_general  F_general  restrain_general
K_general=zeros(K_dimension);
F_general=zeros(K_dimension,1);
restrain_general=zeros(K_dimension,1);
slider=0;
for ii=1:node_num
    F_general(slider+1:slider+3)=node(ii).F;
    %F_general(slider+1)=node(ii).F(1);F_general(slider+2)=node(ii).F(2);F_general(slider+3)=node(ii).F(3);
    restrain_general(slider+1:slider+3)=node(ii).restrain_trans;
    for k=1:node(ii).group_num
        F_general(slider+3*k+1)=node(ii).Mx(k);
        F_general(slider+3*k+2)=node(ii).My(k);
        F_general(slider+3*k+3)=node(ii).Mz(k);
        restrain_general(slider+3*k+1:slider+3*k+3)=node(ii).restrain_rot(3*(k-1)+1:3*k);
    end
    slider=slider+3*(1+node(ii).group_num);
end
%%
%calculate K
%L E Iy Iz Iyz G A
for ii=1:beam_num
    L=beam3(ii).L;
    E=beam3(ii).E;
    Iy=beam3(ii).Iy;
    Iz=beam3(ii).Iz;
    Iyz=beam3(ii).Iyz;
    Ip=beam3(ii).Ip;
    G=beam3(ii).G;
    A=beam3(ii).A;
    
    K_local=K_beam(L,E,Iy,Iz,Iyz,Ip,G,A);
    [ka ,r]=ka_r( beam3(ii).node1 , beam3(ii).node2 );
    T = TT( ka,r );
    K_local_rotate=T'*K_local*T;
    
%     num1=beam3(ii).node1_num;
%     num2=beam3(ii).node2_num;
    u1_row=beam3(ii).u1_row;
    u2_row=beam3(ii).u2_row;
    ksai1_row=beam3(ii).ksai1_row;
    ksai2_row=beam3(ii).ksai2_row;
    
    T_assemble=zeros(12,K_dimension);
    T_assemble(1,u1_row)=1;T_assemble(3,u1_row+1)=1;T_assemble(5,u1_row+2)=1;
    T_assemble(7,u2_row)=1;T_assemble(9,u2_row+1)=1;T_assemble(11,u2_row+2)=1;
    T_assemble(2,ksai1_row)=1;T_assemble(4,ksai1_row+1)=1;T_assemble(6,ksai1_row+2)=1;
    T_assemble(8,ksai2_row)=1;T_assemble(10,ksai2_row+1)=1;T_assemble(12,ksai2_row+2)=1;
    
    K_general=K_general+T_assemble'*K_local_rotate*T_assemble;
    
end
%%
for ii=1:K_dimension
    if restrain_general(ii)~=-1
        for jj=1:K_dimension
            if jj==ii 
                F_general(jj)=restrain_general(jj);
                K_general(jj,jj)=1;
            else
                F_general(jj)=F_general(jj)-K_general(jj,ii)*restrain_general(ii);
                K_general(jj,ii)=0;K_general(ii,jj)=0;
            end
        end
    end
end
         
U_move=K_general\F_general;
%U_move=pinv(K_general)*F_general;

%% 
for ii=1:beam_num
    beam3(ii).u1=U_move(beam3(ii).u1_row);
    beam3(ii).v1=U_move(beam3(ii).u1_row+1);
    beam3(ii).w1=U_move(beam3(ii).u1_row+2);
    beam3(ii).u2=U_move(beam3(ii).u2_row);
    beam3(ii).v2=U_move(beam3(ii).u2_row+1);
    beam3(ii).w2=U_move(beam3(ii).u2_row+2);
    %p1=beam3(ii).node1;
    %p2=beam3(ii).node2;
    %plot3(p1(1)+beam3(ii).u1,p1(2)+beam3(ii).v1,p1(3)+beam3(ii).w1,'or');hold on;
    %plot3(p2(1)+beam3(ii).u2,p2(2)+beam3(ii).v2,p2(3)+beam3(ii).w2,'or');hold on;
    beam3(ii).ksaix1=U_move(beam3(ii).ksai1_row);
    beam3(ii).ksaiy1=U_move(beam3(ii).ksai1_row+1);
    beam3(ii).ksaiz1=U_move(beam3(ii).ksai1_row+2);
    beam3(ii).ksaix2=U_move(beam3(ii).ksai2_row);
    beam3(ii).ksaiy2=U_move(beam3(ii).ksai2_row+1);
    beam3(ii).ksaiz2=U_move(beam3(ii).ksai2_row+2);
    
    Ue_general=[beam3(ii).u1;beam3(ii).ksaix1;beam3(ii).v1;beam3(ii).ksaiy1;beam3(ii).w1;beam3(ii).ksaiz1;
        beam3(ii).u2;beam3(ii).ksaix2;beam3(ii).v2;beam3(ii).ksaiy2;beam3(ii).w2;beam3(ii).ksaiz2];
        
    inner_point = inner_node( beam3(ii).ka , beam3(ii).r , beam3(ii).node1 , beam3(ii).node2 , Ue_general );
    for k=1:10
        plot3(inner_point(1,:),inner_point(2,:),inner_point(3,:),'-r','Linewidth',2);
    end
    %grid on;
end
           










    