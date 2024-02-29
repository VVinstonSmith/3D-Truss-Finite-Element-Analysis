function [ ka , r ] = ka_r( point1 , point2 )

vector=point2-point1;
ka=atan(vector(2)./vector(1));
if vector(1)<0
    ka=ka+pi;
end

r=-atan(vector(3)./sqrt(vector(1)*vector(1)+vector(2)*vector(2)));

end

