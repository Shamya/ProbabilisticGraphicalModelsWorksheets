function cliquePrint(cp)
sz = size(cp, 2)/10;
keySet =   {'e', 't', 'a', 'i', 'n', 'o', 's', 'h', 'r', 'd'};
valueSet = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
mapObj = containers.Map(keySet,valueSet);
ch = [];
val = mapObj('t');
ch = [ch val];
val = mapObj('a');
ch = [ch val];
val = mapObj('h');
ch = [ch val];
for i = 0:sz-1
    otp = zeros(1,3);
    if i == 0
        cpq = cp(:,1:10);
    else
        cpq = cp(:,((i*10)+1): ((i*10)+10));
    end
    for p = 1:3
        tr = [];
        for q = 1:3
            t = cpq(ch(p),ch(q));
            tr = [tr t];
        end
        otp = [otp; tr];
    end
    otp=otp(2:end,:);
    disp('Clique:');
    disp(otp);
end

end