function T = TT( ka,r )

T=[
  
  cos(ka)*cos(r),              0, cos(r)*sin(ka),              0, -sin(r),       0,              0,              0,              0,              0,       0,       0;
               0, cos(ka)*cos(r),              0, cos(r)*sin(ka),       0, -sin(r),              0,              0,              0,              0,       0,       0;
        -sin(ka),              0,        cos(ka),              0,       0,       0,              0,              0,              0,              0,       0,       0;
               0,       -sin(ka),              0,        cos(ka),       0,       0,              0,              0,              0,              0,       0,       0;
  cos(ka)*sin(r),              0, sin(ka)*sin(r),              0,  cos(r),       0,              0,              0,              0,              0,       0,       0;
               0, cos(ka)*sin(r),              0, sin(ka)*sin(r),       0,  cos(r),              0,              0,              0,              0,       0,       0;
               0,              0,              0,              0,       0,       0, cos(ka)*cos(r),              0, cos(r)*sin(ka),              0, -sin(r),       0;
               0,              0,              0,              0,       0,       0,              0, cos(ka)*cos(r),              0, cos(r)*sin(ka),       0, -sin(r);
               0,              0,              0,              0,       0,       0,       -sin(ka),              0,        cos(ka),              0,       0,       0;
               0,              0,              0,              0,       0,       0,              0,       -sin(ka),              0,        cos(ka),       0,       0;
               0,              0,              0,              0,       0,       0, cos(ka)*sin(r),              0, sin(ka)*sin(r),              0,  cos(r),       0;
               0,              0,              0,              0,       0,       0,              0, cos(ka)*sin(r),              0, sin(ka)*sin(r),       0,  cos(r)];                  

%CrCka=[ cos(r) 0 -sin(r) ; 0 1 0 ; sin(r) 0 cos(r) ] * [ cos(ka) sin(ka) 0 ; -sin(ka) cos(ka) 0 ; 0 0 1]         

end

