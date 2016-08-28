%compute negative energy of true label sequence
function e = negative_energy (x, label,mapObj, wt, wf)
sz = size(label,2);
l = [];
for c = 1:sz
    l = [l mapObj(label(c))];
end
trans = 0;
sz = size(l,2);
for c = 1:sz-1
    trans = trans + wt(l(c),l(c+1));
end

np = node_potential(x, wf);
feat = 0;
for c = 1:sz
    feat = feat + np(l(c),c);
end

e = trans + feat;
end