clc; clear; close;

rod_num=9;
node_num=10;

% node_position=[
%     -1 , 0 , 0;
%     -1 , 1 , 0;
%     1 , 1 , 0;
%     1 , 0 , 0];
node_position=[
    0 , -327 , 0;%1
    0 , -460 , 541;%2
    0 , -171 , 541;%3
    0 , 171 , 541;%4
    -672 , -171 , 541;%5
    -672 , 171 , 541;%6
    0 , 460 , 541;%7
    0 , 327 , 0;%8
    0 , 10 , 0;%9
    0 , -10 , 0];%10
node_position=node_position.*1e-3;

%平动自由度为全局约束，约束结点
restrain_trans=[
      0 , 0 , 0;%1
   -1 , -1 , -1;%2
   -1 , -1 , -1;%3
   -1 , -1 , -1;%4
    0 ,  0 ,  0;%5
    0 ,  0 ,  0;%6
   -1 , -1 , -1;%7  
    0 ,  0 ,  0;%8
    0 ,  0 ,  0;%9
    0 ,  0 ,  0];%10

% restrain_rot_local=[
%     0,  0, 0,  -1  , -1 , -1;
%     -1 , -1 , -1 , -1 , -1, -1;
%     -1 , -1 ,  -1 , 0 , 0 , 0];

%转动自由度为全局约束，约束单元两端.
%  ksaix1 ksaiy1 ksiaz1 ksaix2 ksaiy2 ksaiz2
restrain_rot_general=[
      0,  0, 0,  -1  , -1 , -1;%1
    -1 , -1 , -1 , -1 , -1, -1;%2
    -1 , -1 , -1 , -1 , -1, -1;%3
     0 , -1 , -1 , -1 , -1, -1;%4
     0 , -1 , -1 , -1 , -1, -1;%5
    -1 , -1 , -1 , -1 , -1, -1;%6
    -1 , -1 , -1 ,  0 ,  0,  0;%7
    -1 , -1 , -1 , -1 ,  0, -1;%8
    -1 , -1 , -1 , -1 ,  0, -1];%9

rod_node=[
    1 , 2;%1
    2 , 3;%2
    3 , 4;%3
    5 , 3;%4
    6 , 4;%5
    4 , 7;%6
    7 , 8;%7
    7 , 9;%8
    2 , 10];%9

%合并自由度，用于杆与杆之间的固支
 clamp=[
    1 , 2;
    2 , 3
    3 , 6;
    6 , 7];
%clamp=[];

%给每个结点加结点集中力
%Fx Fy Fz
node_F=[
     0 , 0 , 0;%1
     1e6 , 0 , 0;%2
     0 , 0 , 0;%3
     0 , 0 , 0;%4
     0 , 0 , 0;%5
     0 , 0 , 0;%6
     0 , 0 , 0;%7  
     0 , 0 , 0;%8
     0 , 0 , 0;%9
     0 , 0 , 0];%10

%给每根杆的两端结点加集中力矩,全局
%Mx1 My1 Mz1 Mx2 My2 Mz2
M_node=[
    0 , 0 , 0 , 0 , 0 , 0;%1
    0 , 0 , 0 , 0 , 0 , 0;%2
    0 , 0 , 0 , 0 , 0 , 0;%3
    0 , 0 , 0 , 0 , 0 , 0;%4
    0 , 0 , 0 , 0 , 0 , 0;%5
    0 , 0 , 0 , 0 , 0 , 0;%6
    0 , 0 , 0 , 0 , 0 , 0;%7
    0 , 0 , 0 , 0 , 0 , 0;%8
   0 , 0 , 0 , 0 , 0 , 0];%9

%给每根杆加均布载荷,全局
%fx mx fy my fz mz
f_const=[
   0 , 0 , 0 , 0 , 0 , 0;%1
   0 , 0 , 0 , 0 , -0 , 0;%2
   0 , 0 , 0 , 0 , 0 , 0;%3
   0 , 0 , 0 , 0 , 0 , 0;%4
   0 , 0 , 0 , 0 , 0 , 0;%5
   0 , 0 , 0 , 0 , 0 , 0;%6
   0 , 0 , 0 , 0 , 0 , 0;%7
   0 , 0 , 0 , 0 , 0 , 0;%8
   0 , 0 , 0 , 0 , 0 , 0];%9

%给每根杆加线性分布载荷,全局
%fx2 mx2 fy2 my2 fz2 mz2
f_linear =[
    0 , 0 , 0 , 0 , 0 , 0;%1
   0 , 0 , 0 , 0 , 0 , 0;%2
   0 , 0 , 0 , 0 , 0 , 0;%3
   0 , 0 , 0 , 0 , 0 , 0;%4
   0 , 0 , 0 , 0 , 0 , 0;%5
   0 , 0 , 0 , 0 , 0 , 0;%6
   0 , 0 , 0 , 0 , 0 , 0;%7
   0 , 0 , 0 , 0 , 0 , 0;%8
   0 , 0 , 0 , 0 , 0 , 0];%9
          
%%
beam3(1:rod_num)=struct( 'num',0 , 'E',0 , 'mu',0 , 'Iy',0 , 'Iz',0 , 'Iyz',0 , 'Ip',0 , 'G',0 , 'A',0 , 'L',0 ,...
    'node1',[0;0;0] , 'node2',[0;0;0] ,... 
    'ka',0 , 'r',0 ,...
    'node1_num',0 , 'node2_num',0 ,...
    'u1_row',0 , 'ksai1_row',0 , 'u2_row',0 , 'ksai2_row',0 ,...
    'u1',0 , 'ksaix1',0 , 'v1',0 , 'ksaiy1',0 , 'w1',0 , 'ksaiz1',0 ,...
    'u2',0 , 'ksaix2',0 , 'v2',0 , 'ksaiy2',0 , 'w2',0 , 'ksaiz2',0 ,...
    'restrain_rot',[-1,-1,-1,-1,-1,-1] );

node(1:node_num)=struct( 'xyz',[0;0;0] ,...
    'F',[0;0;0] , 'Mx',[0,0,0,0,0] , 'My',[0,0,0,0,0] , 'Mz',[0,0,0,0,0] ,...
    'restrain_trans',[-1,-1,-1] , 'restrain_rot',[-1,-1,-1 , -1,-1,-1 , -1,-1,-1],...
    'belong_num',2 , 'group_num',2,...
    'belong_group',[0,0,0,0,0],...
    'type',['beam3','beam3','beam3','beam3','beam3'],...
    'type_num',[0,0,0,0,0],...
    'node_num',[0,0,0,0,0] );

%%
for ii=1:node_num
    node(ii).xyz=node_position(ii,:)';
    node(ii).belong_num=0;
    node(ii).group_num=0;
    node(ii).restrain_trans=restrain_trans(ii,:);
    node(ii).F=node_F(ii,:)';
end
for ii=1:rod_num
    node(rod_node(ii,1)).belong_num=node(rod_node(ii,1)).belong_num+1;
    node(rod_node(ii,1)).type_num(node(rod_node(ii,1)).belong_num)=ii;
    node(rod_node(ii,1)).node_num(node(rod_node(ii,1)).belong_num)=1;

    node(rod_node(ii,2)).belong_num=node(rod_node(ii,2)).belong_num+1;
    node(rod_node(ii,2)).type_num(node(rod_node(ii,2)).belong_num)=ii;
    node(rod_node(ii,2)).node_num(node(rod_node(ii,2)).belong_num)=2;
end

if isempty(clamp)
    ;
else
    for ii=1:length(clamp(:,1))
        for k1=1:2
            for k2=1:2
                if rod_node(clamp(ii,1),k1)==rod_node(clamp(ii,2),k2)
                    clamp_node=rod_node(clamp(ii,1),k1);
                    node(clamp_node).restrain_rot(node(clamp_node).group_num*3+1:node(clamp_node).group_num*3+3)=[-1 -1 -1];
                    node(clamp_node).group_num=node(clamp_node).group_num+1;
                    for m=1:node(clamp_node).belong_num
                        if node(clamp_node).type_num(m)==clamp(ii,1) || node(clamp_node).type_num(m)==clamp(ii,2)
                            node(clamp_node).belong_group(m)=node(clamp_node).group_num;
                        end
                    end
                end
            end
        end
    end
end    
    
for ii=1:node_num
    for jj=1:node(ii).belong_num
        if node(ii).belong_group(jj)==0
            node(ii).restrain_rot(node(ii).group_num*3+1:node(ii).group_num*3+3)=[-1 -1 -1];
            node(ii).group_num=node(ii).group_num+1;
            node(ii).belong_group(jj)=node(ii).group_num;           
        end
    end
end

%%
E_steel=200*10.^9;
mu_steel=0.3;
h=0.1;
b=0.01;
Iz=(b*h.^3)./12;
Iy=(h*b.^3)./12;
Iyz=0;
beta=0.312;
Ip=(2*h)*(2*b).^3*beta;
A=b*h;
% rod_Iz=[ Iz ; Iz ; Iz ];
% rod_Iy=[ Iy ; Iy ; Iy ];
% rod_Iyz=[ Iyz ; Iyz ; Iyz ];
% rod_Ip=[ Ip ; Ip ; Ip];
% rod_A=[ A ; A ; A ];
for ii=1:rod_num
    rod_E(ii,1)=E_steel;
    rod_mu(ii,1)=mu_steel;
    rod_Iz(ii,1)=Iz;
    rod_Iy(ii,1)=Iy;
    rod_Iyz(ii,1)=Iyz;
    rod_Ip(ii,1)=Ip;
    rod_A(ii,1)=A;
end

for ii=1:rod_num
    beam3(ii).E=rod_E(ii,1);
    beam3(ii).mu=rod_mu(ii,1);
    beam3(ii).G=0.5*beam3(ii).E./(1+beam3(ii).mu);
    beam3(ii).Iz=rod_Iz(ii,1);
    beam3(ii).Iy=rod_Iy(ii,1);
    beam3(ii).Iyz=rod_Iyz(ii,1);
    beam3(ii).Ip=rod_Ip(ii,1);
    beam3(ii).A=rod_A(ii,1);
    beam3(ii).node1_num=rod_node(ii,1);
    beam3(ii).node2_num=rod_node(ii,2);
    beam3(ii).node1=node(rod_node(ii,1)).xyz;
    beam3(ii).node2=node(rod_node(ii,2)).xyz;
    beam3(ii).L=norm(beam3(ii).node1-beam3(ii).node2);
    [ka12 ,r12]=ka_r( beam3(ii).node1 , beam3(ii).node2 );
	beam3(ii).ka=ka12;
	beam3(ii).r=r12;
end

%%
%固支和地面的连接点 
for ii=1:rod_num
%     T = TT( beam3(ii).ka,beam3(ii).r );
%     T=T([1,3,5],[1,3,5]);
%     beam3(ii).restrain_rot(1:3)=(T'*restrain_rot_local(ii,1:3)')';
%     beam3(ii).restrain_rot(4:6)=(T'*restrain_rot_local(ii,4:6)')';
%     for jj=1:6
%         if abs(beam3(ii).restrain_rot(jj))<1e-3
%             beam3(ii).restrain_rot(jj)=0;
%         else
%             beam3(ii).restrain_rot(jj)=-1;
%         end
%     end
    beam3(ii).restrain_rot(1:3)=restrain_rot_general(ii,1:3);
    beam3(ii).restrain_rot(4:6)=restrain_rot_general(ii,4:6);         
    for m=1:node(beam3(ii).node1_num).belong_num
        if node(beam3(ii).node1_num).type_num(m)==ii
            start=node(beam3(ii).node1_num).belong_group(m);
            node(beam3(ii).node1_num).restrain_rot((start-1)*3+1:start*3)=beam3(ii).restrain_rot(1:3);
        end
    end
    for m=1:node(beam3(ii).node2_num).belong_num
        if node(beam3(ii).node2_num).type_num(m)==ii
            start=node(beam3(ii).node2_num).belong_group(m);
            node(beam3(ii).node2_num).restrain_rot((start-1)*3+1:start*3)=beam3(ii).restrain_rot(4:6);
        end
    end 
end

%   node(1).restrain_rot(1:3)=[0,0,0];
%   node(4).restrain_rot(1:3)=[0,0,0];
%%
%加均布载荷
%fx mx fy my fz mz
%加线性载荷
%fx2 mx2 fy2 my2  
for ii=1:rod_num
    L=beam3(ii).L;
    T = TT( beam3(ii).ka,beam3(ii).r );
    f_ge=T(1:6,1:6)*f_const(ii,:)';
    f_ge_lin=T(1:6,1:6)*f_linear(ii,:)';
    F_ge=T'*[
                    (L*f_ge(1))/2;
                    (L*f_ge(2))/2;
   (L*(f_ge(3) - 2*f_ge(6)./L))/2;
                -(L^2*f_ge(5))/12;
   (L*(f_ge(5) + 2*f_ge(4)./L))/2;
                 (L^2*f_ge(3))/12;
                    (L*f_ge(1))/2;
                    (L*f_ge(2))/2;
   (L*(f_ge(3) + 2*f_ge(6)./L))/2;
                 (L^2*f_ge(5))/12;
   (L*(f_ge(5) - 2*f_ge(4)./L))/2;
                -(L^2*f_ge(3))/12];
            
    F_ge_lin=T'*[
                           (L*f_ge_lin(1))/6;
                           (L*f_ge_lin(2))/6;
  (L*((3*f_ge_lin(3))/10 - f_ge_lin(6)/L))/2;
 -(L*(f_ge_lin(4)/6 + (L*f_ge_lin(5))/15))/2;
  (L*((3*f_ge_lin(5))/10 + f_ge_lin(4)/L))/2;
 -(L*(f_ge_lin(6)/6 - (L*f_ge_lin(3))/15))/2;
                           (L*f_ge_lin(1))/3;
                           (L*f_ge_lin(2))/3;
  (L*((7*f_ge_lin(3))/10 + f_ge_lin(6)/L))/2;
  (L*(f_ge_lin(4)/6 + (L*f_ge_lin(5))/10))/2;
  (L*((7*f_ge_lin(5))/10 - f_ge_lin(4)/L))/2;
  (L*(f_ge_lin(6)/6 - (L*f_ge_lin(3))/10))/2];
    
    node(beam3(ii).node1_num).F=node(beam3(ii).node1_num).F+[F_ge(1);F_ge(3);F_ge(5)];
    node(beam3(ii).node2_num).F=node(beam3(ii).node2_num).F+[F_ge(7);F_ge(9);F_ge(11)];
    node(beam3(ii).node1_num).F=node(beam3(ii).node1_num).F+[F_ge_lin(1);F_ge_lin(3);F_ge_lin(5)];
    node(beam3(ii).node2_num).F=node(beam3(ii).node2_num).F+[F_ge_lin(7);F_ge_lin(9);F_ge_lin(11)];
    for m=1:node(beam3(ii).node1_num).belong_num
        if node(beam3(ii).node1_num).type_num(m)==ii  
             node(beam3(ii).node1_num).Mx(node(beam3(ii).node1_num).belong_group(m))=node(beam3(ii).node1_num).Mx(node(beam3(ii).node1_num).belong_group(m))+F_ge(2)+F_ge_lin(2)+M_node(ii,1);     
             node(beam3(ii).node1_num).My(node(beam3(ii).node1_num).belong_group(m))=node(beam3(ii).node1_num).My(node(beam3(ii).node1_num).belong_group(m))+F_ge(4)+F_ge_lin(4)+M_node(ii,2);
             node(beam3(ii).node1_num).Mz(node(beam3(ii).node1_num).belong_group(m))=node(beam3(ii).node1_num).Mz(node(beam3(ii).node1_num).belong_group(m))+F_ge(6)+F_ge_lin(6)+M_node(ii,3);
        end
    end
    for m=1:node(beam3(ii).node2_num).belong_num
        if node(beam3(ii).node2_num).type_num(m)==ii
             node(beam3(ii).node2_num).Mx(node(beam3(ii).node2_num).belong_group(m))=node(beam3(ii).node2_num).Mx(node(beam3(ii).node2_num).belong_group(m))+F_ge(8)+F_ge_lin(8)+M_node(ii,4);
             node(beam3(ii).node2_num).My(node(beam3(ii).node2_num).belong_group(m))=node(beam3(ii).node2_num).My(node(beam3(ii).node2_num).belong_group(m))+F_ge(10)+F_ge_lin(10)+M_node(ii,5);
             node(beam3(ii).node2_num).Mz(node(beam3(ii).node2_num).belong_group(m))=node(beam3(ii).node2_num).Mz(node(beam3(ii).node2_num).belong_group(m))+F_ge(12)+F_ge_lin(12)+M_node(ii,6);
        end
    end
end
%%    
K_dimension=0;
for ii=1:node_num%遍历所有结点
    
    for jj=1:node(ii).belong_num%遍历结点关联的杆
        p=node(ii).type_num(jj);
        if node(ii).node_num(jj)==1
            beam3(p).u1_row=K_dimension+1;
            beam3(p).ksai1_row=K_dimension+node(ii).belong_group(jj)*3+1;
        elseif node(ii).node_num(jj)==2
            beam3(p).u2_row=K_dimension+1;
            beam3(p).ksai2_row=K_dimension+node(ii).belong_group(jj)*3+1;
        end     
    end
    K_dimension=K_dimension+3+node(ii).group_num*3;
end
K_dimension
    
%picture
figure(1);axis equal;
%axis([-1.5,1.5,0,1.5]);
for ii=1:rod_num
    p1=beam3(ii).node1;
    p2=beam3(ii).node2;
    line([p1(1),p2(1)],[p1(2),p2(2)],[p1(3),p2(3)],'Marker','o','linewidth',2);hold on;
end
%%


