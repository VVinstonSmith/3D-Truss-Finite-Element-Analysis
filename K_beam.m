function K_local = K_beam(L,E,Iy,Iz,Iyz,Ip,G,A)

K_local=[
     (A*E)/L,         0,               0,              0,               0,              0, -(A*E)/L,         0,               0,              0,               0,              0;
        0,  (G*Ip)/L,               0,              0,               0,              0,        0, -(G*Ip)/L,               0,              0,               0,              0;
        0,         0,   (12*E*Iz)/L^3, -(6*E*Iyz)/L^2,  (12*E*Iyz)/L^3,   (6*E*Iz)/L^2,        0,         0,  -(12*E*Iz)/L^3, -(6*E*Iyz)/L^2, -(12*E*Iyz)/L^3,   (6*E*Iz)/L^2;
        0,         0,  -(6*E*Iyz)/L^2,     (4*E*Iy)/L,   -(6*E*Iy)/L^2,   -(4*E*Iyz)/L,        0,         0,   (6*E*Iyz)/L^2,     (2*E*Iy)/L,    (6*E*Iy)/L^2,   -(2*E*Iyz)/L;
        0,         0,  (12*E*Iyz)/L^3,  -(6*E*Iy)/L^2,   (12*E*Iy)/L^3,  (6*E*Iyz)/L^2,        0,         0, -(12*E*Iyz)/L^3,  -(6*E*Iy)/L^2,  -(12*E*Iy)/L^3,  (6*E*Iyz)/L^2;
        0,         0,    (6*E*Iz)/L^2,   -(4*E*Iyz)/L,   (6*E*Iyz)/L^2,     (4*E*Iz)/L,        0,         0,   -(6*E*Iz)/L^2,   -(2*E*Iyz)/L,  -(6*E*Iyz)/L^2,     (2*E*Iz)/L;
 -(A*E)/L,         0,               0,              0,               0,              0,  (A*E)/L,         0,               0,              0,               0,              0;
        0, -(G*Ip)/L,               0,              0,               0,              0,        0,  (G*Ip)/L,               0,              0,               0,              0;
        0,         0,  -(12*E*Iz)/L^3,  (6*E*Iyz)/L^2, -(12*E*Iyz)/L^3,  -(6*E*Iz)/L^2,        0,         0,   (12*E*Iz)/L^3,  (6*E*Iyz)/L^2,  (12*E*Iyz)/L^3,  -(6*E*Iz)/L^2;
        0,         0,  -(6*E*Iyz)/L^2,     (2*E*Iy)/L,   -(6*E*Iy)/L^2,   -(2*E*Iyz)/L,        0,         0,   (6*E*Iyz)/L^2,     (4*E*Iy)/L,    (6*E*Iy)/L^2,   -(4*E*Iyz)/L;
        0,         0, -(12*E*Iyz)/L^3,   (6*E*Iy)/L^2,  -(12*E*Iy)/L^3, -(6*E*Iyz)/L^2,        0,         0,  (12*E*Iyz)/L^3,   (6*E*Iy)/L^2,   (12*E*Iy)/L^3, -(6*E*Iyz)/L^2;
        0,         0,    (6*E*Iz)/L^2,   -(2*E*Iyz)/L,   (6*E*Iyz)/L^2,     (2*E*Iz)/L,        0,         0,   -(6*E*Iz)/L^2,   -(4*E*Iyz)/L,  -(6*E*Iyz)/L^2,     (4*E*Iz)/L];


end

