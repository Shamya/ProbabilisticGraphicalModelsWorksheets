function Z = resample_Z( Y, alpha, beta, theta )

J = size(Y,2);
K = size(Y,1);
Z     = zeros(K,J);
for k = 1:K
    for j = 1:J
        Z_mean = alpha(k) + beta(k)*theta(j);
        if (Y(k,j) == 1.0)
            m = Z_mean;
            s = 1.0;
            l = 0;
            u = Inf;
            X=trandn((l-m)/s,(u-m)/s);
            Z(k,j) = m+s*X;
        end
        if(isinf(Z(k,j)))
            Z(k,j) = 0;
        end
        if (Y(k,j) == 0.0)
            m = Z_mean;
            s = 1.0;
            l = -Inf;
            u = 0;
            X=trandn((l-m)/s,(u-m)/s);
            Z(k,j) = m+s*X;
        end
        if(isinf(Z(k,j)))
            Z(k,j) = 0;
        end
        if (Y(k,j) ~= 1.0 && Y(k,j) ~= 0.0)
            Z(k,j) = normrnd(Z_mean, 1.0);
        end
    end
end

end

