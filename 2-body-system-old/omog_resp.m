function [v, w, x_0] = omog_resp(M,C, K, t)

%
%   Calculation of the omogeneus respons of a dumped 2-body system
%

o = [[0, 0];[0, 0]];
E_1 = [[M, o];[o, M]];
E_2 = [[C, K];[M, o]];
A = E_1\E_2;
[v, w] = eig(A);
for i = length(w)
w_0(i) = w(i,i);
end



o = [1; 1; 1; 1];

x_0p = o(1).*v(1,1:2).*exp(1i.*w_0(1).*t) + o(2).*v(2,1:2).*exp(1i.*w_0(2).*t) + o(3).*v(3,1:2).*exp(1i.*w_0(3).*t) + o(4).*v(4,1:2).*exp(1i.*w_0(4).*t);
x_0 = o(1).*v(1,3:4).*exp(1i.*w_0(1).*t) + o(2).*v(2,3:4).*exp(1i.*w_0(2).*t) + o(3).*v(3,3:4).*exp(1i.*w_0(3).*t) + o(4).*v(4,3:4).*exp(1i.*w_0(4).*t);

end

