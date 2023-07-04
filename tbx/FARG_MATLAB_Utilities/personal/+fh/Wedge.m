function V  = Wedge(v)
V = zeros(3);
V(1,2) = -v(3);
V(2,1) = v(3);
V(3,1) = -v(2);
V(1,3) = v(2);
V(2,3) = -v(1);
V(3,2) = v(1);
end
